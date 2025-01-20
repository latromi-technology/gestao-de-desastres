CREATE OR REPLACE FUNCTION fnc_offer_product_remove (
	p_username          TEXT,
    p_offer_product_id  UUID 
) RETURNS VOID AS 
$BODY$
DECLARE
    r                   RECORD;  
    v_product_others    TEXT;
    v_product_name      TEXT;
    v_product_id        INT;
    v_quantity          NUMERIC(10,2);
    v_status            CHAR(1);
    v_offer_id          UUID;
BEGIN

    -- Exclui e retorna informações da linha removida
    DELETE FROM offers_products 
    WHERE offer_product_id = p_offer_product_id
    RETURNING offer_id, quantity, product_others, product_id 
    INTO v_offer_id, v_quantity, v_product_others, v_product_id;
    
    IF v_offer_id IS NULL THEN
        RETURN;
    END IF;
    
    -- Se for uma doação já confirmada, adiciona 
    -- uma mensagem no histórico, indicando que o donativo foi removido
    SELECT INTO v_status status
    FROM offers
    WHERE offer_id = v_offer_id;

    IF v_status = 'T' THEN
        RETURN;
    END IF;

    -- Atualiza data de modificação
    UPDATE offers
    SET updated_at = CURRENT_TIMESTAMP,
        updated_by = p_username
    WHERE offer_id = v_offer_id;
    
    IF v_product_id IS NOT NULL THEN
        SELECT INTO r
            products.name AS product_name, 
            units.symbol AS unit_symbol
        FROM products
        JOIN units ON units.unit_id = products.offer_unit_id
        WHERE products.product_id = v_product_id;
        
        PERFORM fnc_offer_history_add(p_username, v_offer_id, 
            format('Donativo removido: %s %s %s', r.product_name, ROUND(v_quantity, 1), r.unit_symbol));
    ELSE
        PERFORM fnc_offer_history_add(p_username, v_offer_id, 
            format('Donativo removido: %s %s', v_product_others, v_quantity));
    END IF;
END;
$BODY$
LANGUAGE plpgsql;