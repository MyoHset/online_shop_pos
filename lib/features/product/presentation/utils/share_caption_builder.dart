import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../domain/entities/variant_detail.dart';

class ShareCaptionBuilder {
  static String build({required String shopName, required List<VariantDetail> items}) {
    final lines = items.map((v) =>
        '${v.productName} (${v.size ?? ''}/${v.color ?? ''}) - ${CurrencyFormatter.format(v.finalPrice)} ks, ${v.availableStock} left').join('\n');
    return '$shopName မှ ရွေးချယ်ထားပါသည်:\n\n$lines\n\n'
        '(ဈေးနှုန်း/ပမာဏများ ပြောင်းလဲနိုင်ပါသည်)';
  }
}

Future<File> downloadAndCacheImage(String url) async {
  final tempDir = await getTemporaryDirectory();
  final fileName = url.split('/').last;
  final file = File('${tempDir.path}/$fileName');

  if (await file.exists()) {
    return file;
  }

  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    await file.writeAsBytes(response.bodyBytes);
    return file;
  } else {
    throw Exception('Failed to download image');
  }
}

Future<void> shareTopResults(List<VariantDetail> allResults, String shopName) async {
  final top10 = allResults.take(10).toList();
  final imageFiles = <XFile>[];

  for (final item in top10) {
    if (item.primaryImage != null && item.primaryImage!.isNotEmpty) {
      try {
        final file = await downloadAndCacheImage(item.primaryImage!);
        imageFiles.add(XFile(file.path));
      } catch (e) {
        // Skip if image download fails
      }
    }
  }

  final caption = ShareCaptionBuilder.build(shopName: shopName, items: top10);
  
  if (kIsWeb || Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    debugPrint('Share preview (Desktop/Web):\n$caption');
    debugPrint('Image files count: ${imageFiles.length}');
    await Clipboard.setData(ClipboardData(text: caption));
    return;
  }

  if (imageFiles.isNotEmpty) {
    await Share.shareXFiles(imageFiles, text: caption);
  } else {
    await Share.share(caption);
  }
}
