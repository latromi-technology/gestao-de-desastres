DROP FUNCTION IF EXISTS fnc_request_supply;
CREATE OR REPLACE FUNCTION fnc_request_supply
(
    p_username              TEXT,
    p_request_product_id    UUID,
    p_source_hub_id         INT,
    p_quantity_supplied     NUMERIC(10,2),
    p_operation             VARCHAR(3) DEFAULT 'SET'
) 
    RETURNS VOID AS 
$BODY$  
DECLARE
    r_product           RECORD;
    v_total_supplied    NUMERIC(10,2);
    v_supply_progress   NUMERIC;
BEGIN
    --p_operation: 'ADD' ou 'SET'

    SELECT INTO r_product
        request_id, quantity, quantity_approved, quantity_supplied
    FROM requests_products
    WHERE requests_products.request_product_id = p_request_product_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Material não encontrado.';
    END IF;
    
    IF r_product.quantity_approved IS NULL THEN
        RAISE EXCEPTION 'Material não aprovado.';
    END IF;
    
    -- Total atendido
    v_total_supplied = 
        CASE WHEN p_operation = 'ADD' THEN
            COALESCE(r_product.quantity_supplied, 0) + p_quantity_supplied
        ELSE
            p_quantity_supplied
        END;
    
    -- Apenas atualiza a quantidade.
    -- TODO: Utilizar o hub de origem
    UPDATE requests_products
    SET quantity_supplied = v_total_supplied
    , supplied_at = CURRENT_TIMESTAMP
    , supplied_by = p_username
    WHERE requests_products.request_product_id = p_request_product_id;
    
    -- Obtém o progresso total
    SELECT INTO v_supply_progress
        ROUND(AVG(CASE WHEN COALESCE(quantity_approved,0)=0 
            THEN 100 
            ELSE 100.0 / quantity_approved * COALESCE(quantity_supplied,0)
            END),1) AS progress
    FROM requests_products
    WHERE request_id = r_product.request_id;
	--return;
	IF v_supply_progress > 999.9 THEN
		RAISE EXCEPTION 'O atendimento desta demanda excede o limite de 999.9%%';
	END IF;
	
	--RAISE EXCEPTION '%', v_supply_progress;
    
    UPDATE requests
    SET supply_progress = v_supply_progress
    WHERE request_id = r_product.request_id;

END;
$BODY$
LANGUAGE plpgsql;