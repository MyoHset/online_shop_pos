-- ============================================================
-- 012_credit_sale_and_overdue_schema.sql
-- Customer Credit Sale Checkout, Partial Payments & Overdue Tracking (Phase 2)
-- Run this in your Supabase SQL Editor
-- ============================================================

-- 1. Ensure payments.method is text (to prevent enum type mismatch 42804 error) and allow 'credit'
ALTER TABLE payments ALTER COLUMN method TYPE text USING method::text;
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payments_method_check;
ALTER TABLE payments ADD CONSTRAINT payments_method_check 
  CHECK (method IN ('cod', 'cash', 'kbz_pay', 'wave_pay', 'bank_transfer', 'credit', 'kbzPay', 'wavePay', 'bankTransfer'));

-- Also allow 'credit' in customer_transactions table
ALTER TABLE customer_transactions DROP CONSTRAINT IF EXISTS customer_transactions_payment_method_check;
ALTER TABLE customer_transactions ADD CONSTRAINT customer_transactions_payment_method_check 
  CHECK (payment_method IN ('cash', 'cod', 'kbz_pay', 'wave_pay', 'bank_transfer', 'credit', 'kbzPay', 'wavePay', 'bankTransfer'));

-- 2. Add suspension columns to customers table
ALTER TABLE customers ADD COLUMN IF NOT EXISTS is_suspended boolean NOT NULL DEFAULT false;
ALTER TABLE customers ADD COLUMN IF NOT EXISTS suspended_reason text;

-- 3. Atomic RPC to process instant credit sale (stock deduction + credit ledger)
CREATE OR REPLACE FUNCTION process_instant_credit_sale(
  p_order_id       uuid,
  p_customer_id    uuid,
  p_total_amount   numeric(12,2),
  p_paid_amount    numeric(12,2),
  p_payment_method text,
  p_due_date       timestamptz
)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
  v_credit_amount numeric(12,2);
  v_current_debt  numeric(12,2);
  v_new_debt      numeric(12,2);
  v_is_suspended  boolean;
BEGIN
  -- 1. Check customer status
  SELECT current_debt, is_suspended INTO v_current_debt, v_is_suspended
  FROM customers
  WHERE id = p_customer_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Customer % not found', p_customer_id;
  END IF;

  IF v_is_suspended THEN
    RAISE EXCEPTION 'Credit sale blocked: Customer account is suspended.';
  END IF;

  -- 2. Calculate credit portion
  v_credit_amount := GREATEST(0.00, p_total_amount - p_paid_amount);

  -- 3. Update order with customer info, credit flag and due date
  UPDATE orders
  SET customer_id = p_customer_id,
      is_credit = true,
      due_date = p_due_date,
      status = 'delivered'
  WHERE id = p_order_id;

  -- 4. Deduct inventory via instant sale RPC
  PERFORM complete_instant_sale(p_order_id);

  -- 5. Record payments
  IF p_paid_amount > 0 THEN
    -- Record partial upfront payment
    INSERT INTO payments (
      order_id,
      method,
      amount,
      status,
      paid_at
    ) VALUES (
      p_order_id,
      p_payment_method,
      p_paid_amount,
      'partial',
      now()
    );
  END IF;

  IF v_credit_amount > 0 THEN
    -- Record credit pending payment
    INSERT INTO payments (
      order_id,
      method,
      amount,
      status,
      paid_at
    ) VALUES (
      p_order_id,
      'credit',
      v_credit_amount,
      'pending',
      NULL
    );

    -- 6. Update customer current debt
    v_new_debt := v_current_debt + v_credit_amount;
    UPDATE customers
    SET current_debt = v_new_debt,
        updated_at = now()
    WHERE id = p_customer_id;

    -- 7. Insert customer transaction ledger record
    INSERT INTO customer_transactions (
      customer_id,
      order_id,
      transaction_type,
      amount,
      payment_method,
      balance_after,
      notes
    ) VALUES (
      p_customer_id,
      p_order_id,
      'debt',
      v_credit_amount,
      'credit',
      v_new_debt,
      'Order #' || SUBSTRING(p_order_id::text, 1, 8) || ' (Credit Sale)'
    );
  END IF;
END;
$$;
