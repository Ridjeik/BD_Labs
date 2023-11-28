--CREATE INDEX IF NOT EXISTS idx_price_row_number ON ticket USING btree(price, row_number);
--SELECT COUNT(*) FROM ticket WHERE price > 90 AND row_number = 1;

--CREATE INDEX IF NOT EXISTS idx_customer_name_len ON customer(length(first_name || ' ' || last_name));
SELECT * FROM customer WHERE
length(first_name || ' ' || last_name) = 10;