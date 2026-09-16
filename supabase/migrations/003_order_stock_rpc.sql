-- ============================================================
-- Add missing RPC functions for order stock management
-- Run this in your Supabase SQL editor
-- ============================================================

-- Atomically reserve stock for all items in an order
CREATE OR REPLACE FUNCTION reserve_order_stock(p_order_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
  item RECORD;
BEGIN
  FOR item IN SELECT variant_id, quantity FROM order_items WHERE order_id = p_order_id LOOP
    PERFORM reserve_stock(item.variant_id, item.quantity);
  END LOOP;
END;
$$;

-- Release reserved stock for all items in an order (e.g. on cancel)
CREATE OR REPLACE FUNCTION release_order_stock(p_order_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
  item RECORD;
BEGIN
  FOR item IN SELECT variant_id, quantity FROM order_items WHERE order_id = p_order_id LOOP
    PERFORM release_stock(item.variant_id, item.quantity);
  END LOOP;
END;
$$;

-- Confirm stock deduction for all items in an order (e.g. on deliver)
CREATE OR REPLACE FUNCTION commit_order_stock(p_order_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
  item RECORD;
BEGIN
  FOR item IN SELECT variant_id, quantity FROM order_items WHERE order_id = p_order_id LOOP
    PERFORM confirm_stock_deduction(item.variant_id, item.quantity);
  END LOOP;
END;
$$;
