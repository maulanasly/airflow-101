TRUNCATE TABLE fact_order_accumulating;

INSERT INTO fact_order_accumulating
(
	customer_id
	, order_number
	, invoice_number
	, payment_number
	, total_order_quantity
	, total_order_usd_amount
	, order_to_invoice_lag_days
	, invoice_to_payment_lag_days
	, order_date_id
	, invoice_date_id
	, payment_date_id
)
WITH
orderline_x_products AS (
	SELECT
		a.order_line_number
	    , a.order_number
	    , a.product_id
	    , a.quantity
	    , a.usd_amount
		, b.name AS product_name
	FROM order_lines a
	JOIN products b
		ON a.product_id = b.id
)
, invoices_x_payments AS (
	SELECT
		a.invoice_number
		, a.order_number
		, a.date AS invoice_date
		, b.payment_number
	    , b.date AS payment_date
	FROM invoices a
	LEFT JOIN payments b
		USING(invoice_number)
)
, final_orders AS (
	SELECT
		a.order_number
		, a.customer_id
		, a.date AS order_date
		, b.name AS customer_name
		, c.order_line_number
		, c.product_id
		, c.product_name
	    , c.quantity
	    , c.usd_amount
		, d.invoice_number
		, d.invoice_date
		, d.payment_number
		, d.payment_date
	FROM orders a
	JOIN dim_customers b
		ON b.id = a.customer_id
	JOIN orderline_x_products c
		ON c.order_number = a.order_number
	JOIN invoices_x_payments d
		ON d.order_number = a.order_number
)
SELECT
	customer_id
	, order_number
	, invoice_number
	, payment_number
	, SUM(quantity) AS total_order_quantity
	, SUM(usd_amount) AS total_order_usd_amount
	, SUM(invoice_date - order_date) AS order_to_invoice_lag_days
	, SUM(payment_date - invoice_date) AS invoice_to_payment_lag_days
	, CAST(TO_CHAR((ARRAY_AGG(order_date))[1], 'yyyymmdd') AS INT) AS order_date_id
	, CAST(TO_CHAR((ARRAY_AGG(invoice_date))[1], 'yyyymmdd') AS INT) AS invoice_date_id
	, CAST(TO_CHAR((ARRAY_AGG(payment_date))[1], 'yyyymmdd') AS INT) AS payment_date_id
FROM final_orders
GROUP BY 1, 2, 3, 4;
