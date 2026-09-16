import 'package:supabase/supabase.dart';
import 'lib/core/constants/supabase_constants.dart';

void main() async {
  final client = SupabaseClient(
    SupabaseConstants.supabaseUrl,
    SupabaseConstants.supabaseAnonKey,
  );

  final orders = await client.from('orders').select('*').order('created_at', ascending: false).limit(3);
  print('Recent orders: $orders');

  final orderItems = await client.from('order_items').select('*').order('created_at', ascending: false).limit(5);
  print('Recent order items: $orderItems');
}
