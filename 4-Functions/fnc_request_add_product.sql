SET SEARCH_PATH = gov;
DROP FUNCTION IF EXISTS fnc_request_add_product;
CREATE OR REPLACE FUNCTION fnc_request_add_product(
	p_username          TEXT,
    p_request_id 	    UUID,
	p_product_id 		INT,
    p_unit_id           INT,
	p_quantity 			NUMERIC(10,2),
	p_notes				TEXT DEFAULT NULL
)
RETURNS UUID AS 
$BODY$
DECLARE
	v_result UUID;
BEGIN
	
	PERFORM TRUE
	FROM requests_products
	WHERE request_id = p_request_id
	AND product_id = p_product_id;

	IF FOUND THEN
		UPDATE requests_products
		SET 
            quantity = requests_products.quantity + p_quantity
            , updated_at = CURRENT_TIMESTAMP
            , updated_by = p_username
		WHERE request_id = p_request_id
		AND product_id = p_product_id;
	ELSE
		INSERT INTO requests_products
		(
			request_id
			, product_id
			, quantity
			, unit_id
			, notes
		)
		VALUES
		(
			p_request_id
			, p_product_id
			, p_quantity
			, (SELECT request_unit_id FROM products WHERE product_id = p_product_id)
			, p_notes
		) 
		RETURNING request_product_id INTO v_result;
	END IF;
    
	RETURN v_result;
END;
$BODY$
LANGUAGE plpgsql;