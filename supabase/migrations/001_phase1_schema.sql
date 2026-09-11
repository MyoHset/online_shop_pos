-- ============================================================
-- Shop POS — Phase 1 Database Migration
-- Run this in your Supabase SQL editor (or via supabase CLI)
-- ============================================================

-- ── Enable UUID generation ────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ── orders ───────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS orders (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_name    text NOT NULL,
  customer_phone   text,
  customer_address text,
  status           text NOT NULL DEFAULT 'pending'
                   CHECK (status IN ('pending','confirmed','packed','shipped','delivered','cancelled')),
  total_amount     numeric(12,2) NOT NULL DEFAULT 0,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

-- Auto-update updated_at on row modification
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

CREATE TRIGGER orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ── order_items ───────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS order_items (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id    uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  variant_id  uuid NOT NULL REFERENCES product_variants(id),
  quantity    int  NOT NULL CHECK (quantity > 0),
  unit_price  numeric(12,2) NOT NULL,
  subtotal    numeric(12,2) NOT NULL,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS order_items_order_id_idx ON order_items(order_id);
CREATE INDEX IF NOT EXISTS order_items_variant_id_idx ON order_items(variant_id);

-- ── payments ──────────────────────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS payments (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id    uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  method      text NOT NULL
              CHECK (method IN ('cod','kbzPay','wavePay','bankTransfer')),
  amount      numeric(12,2) NOT NULL CHECK (amount > 0),
  status      text NOT NULL DEFAULT 'pending'
              CHECK (status IN ('pending','paid','partial')),
  paid_at     timestamptz,
  created_at  timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS payments_order_id_idx ON payments(order_id);

-- ── SKU auto-generation trigger ───────────────────────────────────────────────
-- Generates a SKU of format: PRD-{COLOR}-{SIZE}-{RANDOM6}
-- only if the inserted row has no SKU.
CREATE OR REPLACE FUNCTION generate_variant_sku()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
  _color_part text;
  _size_part  text;
  _random     text;
BEGIN
  IF NEW.sku IS NULL OR NEW.sku = '' THEN
    _color_part := COALESCE(UPPER(LEFT(NEW.color, 3)), 'XXX');
    _size_part  := COALESCE(UPPER(LEFT(NEW.size, 2)), 'XX');
    _random     := UPPER(SUBSTRING(gen_random_uuid()::text, 1, 6));
    NEW.sku := _color_part || '-' || _size_part || '-' || _random;
  END IF;
  RETURN NEW;
END;
$$;

-- Apply to product_variants if the trigger doesn't already exist
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger
    WHERE tgname = 'variant_sku_gen'
  ) THEN
    CREATE TRIGGER variant_sku_gen
      BEFORE INSERT ON product_variants
      FOR EACH ROW EXECUTE FUNCTION generate_variant_sku();
  END IF;
END;
$$;

-- ── RPC: reserve_stock ────────────────────────────────────────────────────────
-- Atomically checks available stock and increments stock_reserved.
-- Raises an exception if insufficient stock, which rolls back the transaction.
CREATE OR REPLACE FUNCTION reserve_stock(
  p_variant_id uuid,
  p_quantity   int
)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
  v_available int;
BEGIN
  -- Lock the row for this transaction
  SELECT (stock_quantity - stock_reserved)
  INTO v_available
  FROM product_variants
  WHERE id = p_variant_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Variant % not found', p_variant_id;
  END IF;

  IF v_available < p_quantity THEN
    RAISE EXCEPTION
      'Insufficient stock for variant %. Available: %, requested: %',
      p_variant_id, v_available, p_quantity;
  END IF;

  UPDATE product_variants
  SET stock_reserved = stock_reserved + p_quantity
  WHERE id = p_variant_id;
END;
$$;

-- ── RPC: release_stock ────────────────────────────────────────────────────────
-- Releases reserved stock back to available (on order cancellation).
CREATE OR REPLACE FUNCTION release_stock(
  p_variant_id uuid,
  p_quantity   int
)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  UPDATE product_variants
  SET stock_reserved = GREATEST(0, stock_reserved - p_quantity)
  WHERE id = p_variant_id;
END;
$$;

-- ── RPC: confirm_stock_deduction ─────────────────────────────────────────────
-- On delivery/full payment: decrements both stock_quantity and stock_reserved.
CREATE OR REPLACE FUNCTION confirm_stock_deduction(
  p_variant_id uuid,
  p_quantity   int
)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  UPDATE product_variants
  SET
    stock_quantity = GREATEST(0, stock_quantity - p_quantity),
    stock_reserved = GREATEST(0, stock_reserved - p_quantity)
  WHERE id = p_variant_id;
END;
$$;

-- ── RLS policies (disabled by default for Phase 1 single-user) ───────────────
-- Uncomment and configure when adding multi-user/staff auth in Phase 2.

-- ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
-- ALTER TABLE payments ENABLE ROW LEVEL SECURITY;

-- CREATE POLICY "Allow all for authenticated" ON orders
--   FOR ALL USING (auth.role() = 'authenticated');
-- CREATE POLICY "Allow all for authenticated" ON order_items
--   FOR ALL USING (auth.role() = 'authenticated');
-- CREATE POLICY "Allow all for authenticated" ON payments
--   FOR ALL USING (auth.role() = 'authenticated');

-- ── Supabase Storage bucket ───────────────────────────────────────────────────
-- Run this separately in the Supabase dashboard > Storage > New Bucket
-- or via the API. Name: 'variant-images', Public: true.
-- INSERT INTO storage.buckets (id, name, public)
-- VALUES ('variant-images', 'variant-images', true)
-- ON CONFLICT DO NOTHING;
