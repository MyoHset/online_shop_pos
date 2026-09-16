-- ============================================================
-- Add shop_id to orders table
-- Run this in your Supabase SQL editor
-- ============================================================

ALTER TABLE orders ADD COLUMN IF NOT EXISTS shop_id uuid;

-- (Optional) If you have a shops table, you can add a foreign key constraint:
-- ALTER TABLE orders ADD CONSTRAINT fk_shop_id FOREIGN KEY (shop_id) REFERENCES shops(id) ON DELETE CASCADE;
