INSERT INTO dim_customers
(
    id
    , name
    , inserted_at
)

WITH
existing AS (
    SELECT COALESCE(MAX(id), 0) FROM dim_customers
)
SELECT
    id
    , name
    , CURRENT_TIMESTAMP AS inserted_at
FROM customers
WHERE id > (SELECT * FROM existing)
