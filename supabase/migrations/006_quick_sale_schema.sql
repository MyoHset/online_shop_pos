-- ============================================================
-- Add In-Store Quick Sale schema updates
-- Run this in your Supabase SQL editor
-- ============================================================

-- 1. Add order_type column to orders table
ALTER TABLE orders 
ADD COLUMN IF NOT EXISTS order_type text NOT NULL DEFAULT 'online' 
CHECK (order_type IN ('online', 'in_store'));

-- 2. Make customer_name nullable and add default
ALTER TABLE orders ALTER COLUMN customer_name DROP NOT NULL;
ALTER TABLE orders ALTER COLUMN customer_name SET DEFAULT 'Walk-in Customer';

-- 3. Create complete_instant_sale RPC
-- This RPC atomically reserves stock, commits it, and marks the order delivered.
CREATE OR REPLACE FUNCTION complete_instant_sale(p_order_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
  v_item RECORD;
  v_available int;
BEGIN
  -- Loop through all items in the order
  FOR v_item IN (SELECT variant_id, quantity FROM order_items WHERE order_id = p_order_id)
  LOOP
    -- Lock the row for this transaction
    SELECT (stock_quantity - stock_reserved)
    INTO v_available
    FROM product_variants
    WHERE id = v_item.variant_id
    FOR UPDATE;

    IF NOT FOUND THEN
      RAISE EXCEPTION 'Variant % not found', v_item.variant_id;
    END IF;

    IF v_available < v_item.quantity THEN
      RAISE EXCEPTION
        'Insufficient stock for variant %. Available: %, requested: %',
        v_item.variant_id, v_available, v_item.quantity;
    END IF;

    -- Directly deduct from stock_quantity (bypass stock_reserved since it's instant)
    UPDATE product_variants
    SET stock_quantity = stock_quantity - v_item.quantity
    WHERE id = v_item.variant_id;
  END LOOP;

  -- Mark the order as delivered
  UPDATE orders
  SET status = 'delivered'
  WHERE id = p_order_id;
  
END;
$$;
