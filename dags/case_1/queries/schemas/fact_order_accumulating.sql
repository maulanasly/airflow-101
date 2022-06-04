CREATE TABLE IF NOT EXISTS fact_order_accumulating (
  "order_date_id" int,
  "invoice_date_id" int,
  "payment_date_id" int,
  "customer_id" int,
  "order_number" varchar,
  "invoice_number" varchar,
  "payment_number" varchar,
  "total_order_quantity" int,
  "total_order_usd_amount" decimal,
  "order_to_invoice_lag_days" int,
  "invoice_to_payment_lag_days" int
);

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fact_order_accumulating_customer_id_idx') THEN
      ALTER TABLE fact_order_accumulating
            ADD CONSTRAINT fact_order_accumulating_customer_id_idx FOREIGN KEY (customer_id)
                REFERENCES dim_customers (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fact_order_accumulating_order_date_idx') THEN
      ALTER TABLE fact_order_accumulating
            ADD CONSTRAINT fact_order_accumulating_order_date_idx FOREIGN KEY (order_date_id)
                REFERENCES dim_date (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fact_order_accumulating_invoice_date_idx') THEN
      ALTER TABLE fact_order_accumulating
            ADD CONSTRAINT fact_order_accumulating_invoice_date_idx FOREIGN KEY (invoice_date_id)
                REFERENCES dim_date (id);
    END IF;
    IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conname = 'fact_order_accumulating_payment_date_idx') THEN
      ALTER TABLE fact_order_accumulating
            ADD CONSTRAINT fact_order_accumulating_payment_date_idx FOREIGN KEY (payment_date_id)
                REFERENCES dim_date (id);
    END IF;
END;
$$;
