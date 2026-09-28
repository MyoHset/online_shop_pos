import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('app_en.arb and app_my.arb have matching keys', () {
    final enFile = File('lib/l10n/app_en.arb');
    final myFile = File('lib/l10n/app_my.arb');

    expect(enFile.existsSync(), isTrue, reason: 'app_en.arb must exist');
    expect(myFile.existsSync(), isTrue, reason: 'app_my.arb must exist');

    final enMap = jsonDecode(enFile.readAsStringSync()) as Map<String, dynamic>;
    final myMap = jsonDecode(myFile.readAsStringSync()) as Map<String, dynamic>;

    final enKeys = enMap.keys.where((k) => !k.startsWith('@')).toSet();
    final myKeys = myMap.keys.where((k) => !k.startsWith('@')).toSet();

    final missingInMy = enKeys.difference(myKeys);
    final extraInMy = myKeys.difference(enKeys);

    expect(
      missingInMy,
      isEmpty,
      reason: 'Keys present in app_en.arb but missing in app_my.arb: $missingInMy',
    );

    expect(
      extraInMy,
      isEmpty,
      reason: 'Keys present in app_my.arb but missing in app_en.arb: $extraInMy',
    );
  });
}
