import 'package:supabase/supabase.dart';
import 'lib/core/constants/supabase_constants.dart';

void main() async {
  final client = SupabaseClient(
    SupabaseConstants.supabaseUrl,
    SupabaseConstants.supabaseAnonKey,
  );

  try {
    // 1. Insert Order
    final orderData = await client.from('orders').insert({
      'customer_name': 'Test User',
      'status': 'pending',
      'total_amount': 100.0,
    }).select().single();
    print('Order inserted: ${orderData['id']}');

    // 2. Fetch a variant
    final variantData = await client.from('product_variants').select('id').limit(1).maybeSingle();
    if (variantData == null) {
      print('No variants found in DB to test order_items.');
      return;
    }
    final variantId = variantData['id'];

    // 3. Insert Order Item
    final itemRow = {
      'order_id': orderData['id'],
      'variant_id': variantId,
      'quantity': 1,
      'unit_price': 100.0,
      'subtotal': 100.0,
    };
    
    await client.from('order_items').insert([itemRow]);
    print('Order item inserted successfully.');
  } catch (e) {
    print('Error occurred: $e');
  }
}
