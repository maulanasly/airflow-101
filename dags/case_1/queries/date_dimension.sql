INSERT INTO dim_date
SELECT
  TO_CHAR("date", 'yyyymmdd')::INT AS id
  , "date"
  , EXTRACT(MONTH FROM "date") AS "month"
  , CASE
      WHEN EXTRACT(QUARTER FROM "date") = 1 THEN 1
      WHEN EXTRACT(QUARTER FROM "date") = 2 THEN 2
      WHEN EXTRACT(QUARTER FROM "date") = 3 THEN 3
      WHEN EXTRACT(QUARTER FROM "date") = 4 THEN 4
  END AS quarter_of_year
  , EXTRACT(YEAR FROM "date") AS "year"
  ,   CASE
    WHEN EXTRACT(ISODOW FROM date) IN (6, 7) THEN TRUE
    ELSE FALSE
  END AS is_weekend
FROM (
  SELECT '2010-01-01'::DATE + SEQUENCE.DAY AS date
  FROM GENERATE_SERIES(0, 10000) AS SEQUENCE (DAY)
  GROUP BY SEQUENCE.DAY
) DQ
WHERE NOT EXISTS (
  SELECT
    id
  FROM dim_date
)
ORDER BY 1 DESC;