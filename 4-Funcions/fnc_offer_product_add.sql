SET SEARCH_PATH = gov;

--DROP FUNCTION fnc_offer_add_product;
CREATE OR REPLACE FUNCTION fnc_offer_product_add(
	p_username          TEXT,
    p_offer_id 			UUID, 
	p_product_id 		INT, 
	p_quantity 			NUMERIC(10,2),
	p_product_others 	TEXT DEFAULT NULL,
	p_notes				TEXT DEFAULT NULL
)
RETURNS UUID AS 
$BODY$
DECLARE
	r           RECORD;
    v_status    CHAR(1);
    v_result    UUID;
BEGIN
	
	PERFORM TRUE
	FROM offers_products
	WHERE offer_id = p_offer_id
	AND product_id = p_product_id;

	IF FOUND THEN
        
		UPDATE offers_products
		SET quantity = offers_products.quantity + p_quantity
		WHERE offer_id = p_offer_id
		AND product_id = p_product_id;
	ELSE
		INSERT INTO offers_products
		(
			offer_id
			, product_id
			, quantity
			, unit_id
			, product_others
			, notes
		)
		VALUES
		(
			p_offer_id
			, p_product_id
			, p_quantity
			, (SELECT offer_unit_id FROM products WHERE product_id = p_product_id)
			, p_product_others
			, p_notes
		) 
		--ON CONFLICT (product_id) DO UPDATE SET quantity = offers_products.quantity + p_quantity
		RETURNING offer_product_id INTO v_result;

	END IF;
    
    
    -- Se for uma doação já confirmada, adiciona 
    -- uma mensagem no histórico, indicando que o donativo foi removido
    SELECT INTO v_status status
    FROM offers
    WHERE offer_id = p_offer_id;

    IF v_status != 'T' THEN
        -- Atualiza data de modificação
        UPDATE offers
        SET updated_at = CURRENT_TIMESTAMP,
            updated_by = p_username
        WHERE offer_id = p_offer_id;
        
        -- Inclui no log
        IF p_product_id IS NOT NULL THEN
            SELECT INTO r
                products.name AS product_name, 
                units.symbol AS unit_symbol
            FROM products
            JOIN units ON units.unit_id = products.offer_unit_id
            WHERE products.product_id = p_product_id;
            
            PERFORM fnc_offer_history_add(p_username, p_offer_id, 
                format('Donativo adicionado: %s %s %s', r.product_name, ROUND(p_quantity, 1), r.unit_symbol));
        ELSE
            PERFORM fnc_offer_history_add(p_username, p_offer_id, 
                format('Donativo adicionado: %s %s', p_product_others, ROUND(p_quantity, 1)));
        END IF;
    END IF;
	RETURN v_result;
END;
$BODY$
LANGUAGE plpgsql;