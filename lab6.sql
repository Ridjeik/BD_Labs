CREATE OR REPLACE FUNCTION random_phone_number()
RETURNS VARCHAR(20) AS $$
DECLARE
    area_code VARCHAR(3);
    exchange VARCHAR(3);
    subscriber VARCHAR(4);
BEGIN
    -- Генеруємо випадковий код області (3 цифри)
    area_code := LPAD(FLOOR(random() * 1000)::VARCHAR, 3, '0');
    -- Генеруємо випадковий код обміну (3 цифри)
    exchange := LPAD(FLOOR(random() * 1000)::VARCHAR, 3, '0');
    -- Генеруємо випадковий номер абонента (4 цифри)
    subscriber := LPAD(FLOOR(random() * 10000)::VARCHAR, 4, '0');
    -- Форматуємо та повертаємо випадковий номер телефону
    RETURN area_code || '-' || exchange || '-' || subscriber;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION random_date(start_date DATE, end_date DATE)
RETURNS DATE AS $$
DECLARE
    date_range INTERVAL;
BEGIN
    date_range := end_date - start_date;
    RETURN start_date + random() * date_range;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE update_customer_address(
    IN customer_id INT,
    IN new_address VARCHAR(255)
)
AS $$
BEGIN
    UPDATE customer
    SET address = new_address
    WHERE customer_id = customer_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE calculate_discount(
    IN purchase_amount DECIMAL,
    IN customer_age INT,
    OUT discount DECIMAL
)
AS $$
BEGIN
    IF purchase_amount >= 100 AND customer_age >= 65 THEN
        -- Знижка 15% для покупців віком 65 і старше з покупкою на 100 або більше
        discount := 0.15;
    ELSIF purchase_amount >= 50 THEN
        -- Знижка 10% для покупок на 50 або більше
        discount := 0.10;
    ELSE
        -- Без знижки для менших покупок
        discount := 0;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TABLE IF NOT EXISTS cashier_tickets_sold (
    cashier_id INT PRIMARY KEY,
    tickets_sold INT DEFAULT 0,
	FOREIGN KEY (cashier_id) REFERENCES cashier(cashier_id)
);

CREATE OR REPLACE PROCEDURE update_tickets_sold_by_cashier(new_sale_id int)
AS $$
DECLARE
    tickets CURSOR FOR
        SELECT *
        FROM ticket
		WHERE ticket.sale_id = new_sale_id;
    ticket_rec RECORD;
    total_tickets_sold INT;
	updated_cashier_id INT;
BEGIN
	updated_cashier_id := (SELECT sale.cashier_id FROM sale WHERE sale.sale_id = new_sale_id);

	IF updated_cashier_id IS NOT NULL THEN
	
	RAISE NOTICE 'test(%)', updated_cashier_id;

	IF NOT EXISTS (SELECT 1 FROM cashier_tickets_sold WHERE cashier_tickets_sold.cashier_id = updated_cashier_id) THEN
		INSERT INTO cashier_tickets_sold(cashier_id) VALUES (updated_cashier_id);
	END IF;
	
	SELECT tickets_sold INTO total_tickets_sold
	FROM cashier_tickets_sold
	WHERE cashier_tickets_sold.cashier_id = updated_cashier_id;
	
    FOR ticket_rec IN tickets
    LOOP
     	total_tickets_sold := total_tickets_sold + 1;
    END LOOP;
	
	UPDATE cashier_tickets_sold
    SET tickets_sold = total_tickets_sold
    WHERE cashier_tickets_sold.cashier_id = updated_cashier_id;
	
	END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION on_tickets_added() RETURNS trigger AS
$$
DECLARE
	new_sales CURSOR FOR
		SELECT sale_id
		FROM new_tickets
		GROUP BY sale_id;
BEGIN
	FOR sale IN new_sales
	LOOP
		CALL update_tickets_sold_by_cashier(sale.sale_id);
	END LOOP;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER ticket_add
AFTER INSERT ON ticket
REFERENCING NEW TABLE AS new_tickets
FOR EACH STATEMENT
EXECUTE FUNCTION on_tickets_added();
