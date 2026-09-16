-- ============================================================
-- Fix RLS (Row-Level Security) for Orders and Order Items
-- Run this in your Supabase SQL editor
-- ============================================================

-- If you accidentally enabled RLS without adding a policy, 
-- you will get a "violates row-level security policy" error (42501).

-- Option A: Disable RLS for Phase 1 (Recommended for testing)
ALTER TABLE orders DISABLE ROW LEVEL SECURITY;
ALTER TABLE order_items DISABLE ROW LEVEL SECURITY;
ALTER TABLE payments DISABLE ROW LEVEL SECURITY;

-- Option B: If you want to keep RLS enabled, uncomment the following lines 
-- to allow ANY user (including anonymous) to insert and select data.
/*
CREATE POLICY "Allow all for anon and authenticated" ON orders
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all for anon and authenticated" ON order_items
  FOR ALL USING (true) WITH CHECK (true);
*/
