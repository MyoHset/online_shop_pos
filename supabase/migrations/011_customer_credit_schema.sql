-- ============================================================
-- 011_customer_credit_schema.sql
-- Customer Management & Credit Repayment (Phase 1)
-- Run this in your Supabase SQL Editor
-- ============================================================

-- 0. Ensure the shared "updated_at" trigger function exists
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

-- 1. Create customers table
CREATE TABLE IF NOT EXISTS customers (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  shop_id          uuid,
  name             text NOT NULL,
  phone            text NOT NULL,
  address          text,
  credit_limit     numeric(12,2) NOT NULL DEFAULT 0.00 CHECK (credit_limit >= 0),
  current_debt     numeric(12,2) NOT NULL DEFAULT 0.00 CHECK (current_debt >= 0),
  repayment_cycle  text NOT NULL DEFAULT 'monthly' CHECK (repayment_cycle IN ('weekly', 'monthly', 'net30')),
  notes            text,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now()
);

-- Trigger for customers updated_at
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_trigger WHERE tgname = 'customers_updated_at'
  ) THEN
    CREATE TRIGGER customers_updated_at
      BEFORE UPDATE ON customers
      FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
  END IF;
END;
$$;

-- Indexes for fast search by name & phone
CREATE INDEX IF NOT EXISTS idx_customers_phone ON customers(phone);
CREATE INDEX IF NOT EXISTS idx_customers_name ON customers(name);
CREATE INDEX IF NOT EXISTS idx_customers_shop_id ON customers(shop_id);

-- 2. Create customer_transactions table (Ledger for debts & repayments)
CREATE TABLE IF NOT EXISTS customer_transactions (
  id               uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  customer_id      uuid NOT NULL REFERENCES customers(id) ON DELETE CASCADE,
  order_id         uuid REFERENCES orders(id) ON DELETE SET NULL,
  transaction_type text NOT NULL CHECK (transaction_type IN ('debt', 'repayment', 'opening_balance')),
  amount           numeric(12,2) NOT NULL CHECK (amount > 0),
  payment_method   text DEFAULT 'cash' CHECK (payment_method IN ('cash', 'cod', 'kbzPay', 'wavePay', 'bankTransfer')),
  balance_after    numeric(12,2) NOT NULL DEFAULT 0.00,
  notes            text,
  created_at       timestamptz NOT NULL DEFAULT now()
);

CREATE INDEX IF NOT EXISTS idx_customer_transactions_cust_id ON customer_transactions(customer_id);
CREATE INDEX IF NOT EXISTS idx_customer_transactions_created_at ON customer_transactions(created_at DESC);

-- 3. Add customer reference to orders table if not present
ALTER TABLE orders ADD COLUMN IF NOT EXISTS customer_id uuid REFERENCES customers(id) ON DELETE SET NULL;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS is_credit boolean NOT NULL DEFAULT false;
ALTER TABLE orders ADD COLUMN IF NOT EXISTS due_date timestamptz;

-- 4. Atomic RPC to record customer repayment
CREATE OR REPLACE FUNCTION record_customer_repayment(
  p_customer_id    uuid,
  p_amount         numeric(12,2),
  p_payment_method text,
  p_notes          text DEFAULT NULL
)
RETURNS numeric(12,2) LANGUAGE plpgsql AS $$
DECLARE
  v_current_debt  numeric(12,2);
  v_new_debt      numeric(12,2);
BEGIN
  -- Lock customer row for update
  SELECT current_debt INTO v_current_debt
  FROM customers
  WHERE id = p_customer_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Customer % not found', p_customer_id;
  END IF;

  IF p_amount <= 0 THEN
    RAISE EXCEPTION 'Repayment amount must be greater than 0';
  END IF;

  -- Calculate new debt (clamp to 0 so debt doesn't become negative)
  v_new_debt := GREATEST(0.00, v_current_debt - p_amount);

  -- Update customer debt
  UPDATE customers
  SET current_debt = v_new_debt,
      updated_at = now()
  WHERE id = p_customer_id;

  -- Insert ledger entry
  INSERT INTO customer_transactions (
    customer_id,
    transaction_type,
    amount,
    payment_method,
    balance_after,
    notes
  ) VALUES (
    p_customer_id,
    'repayment',
    p_amount,
    p_payment_method,
    v_new_debt,
    p_notes
  );

  RETURN v_new_debt;
END;
$$;

-- 5. Enable Row Level Security (RLS)
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE customer_transactions ENABLE ROW LEVEL SECURITY;

-- Allow authenticated and anon access (consistent with current POS schema policies)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'customers' AND policyname = 'Allow all access to customers'
  ) THEN
    CREATE POLICY "Allow all access to customers" ON customers FOR ALL USING (true) WITH CHECK (true);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies WHERE tablename = 'customer_transactions' AND policyname = 'Allow all access to customer_transactions'
  ) THEN
    CREATE POLICY "Allow all access to customer_transactions" ON customer_transactions FOR ALL USING (true) WITH CHECK (true);
  END IF;
END;
$$;