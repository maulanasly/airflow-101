CREATE TABLE IF NOT EXISTS dim_customers (
  "id" int,
  "name" varchar,
  "inserted_at" TIMESTAMP
)

ALTER TABLE public.dim_customers ADD PRIMARY KEY (id);

CREATE INDEX dim_customers_name_idx
  ON dim_customers(name);
