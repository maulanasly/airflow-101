CREATE TABLE IF NOT EXISTS dim_date (
  "id" int,
  "date" date,
  "month" int,
  "quarter_of_year" int,
  "year" int,
  "is_weekend" boolean
);

ALTER TABLE public.dim_date ADD PRIMARY KEY (id);

CREATE INDEX dim_date_date_actual_idx
  ON dim_date(date);

COMMIT;
