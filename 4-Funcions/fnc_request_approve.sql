SET search_path = gov;

DROP FUNCTION IF EXISTS fnc_request_approve;
CREATE OR REPLACE FUNCTION fnc_request_approve
(
    p_username              TEXT,
    p_entity_id             UUID,
    p_request_product_id    UUID,
    p_quantity_approved     NUMERIC(10,2) DEFAULT NULL
) 
    RETURNS VOID AS 
$BODY$  
DECLARE
    v_quantity                  NUMERIC(10,2);
    v_request_id                UUID;
    v_status                    CHAR(1);
    v_approval_status           CHAR(1);
    v_approval_status_prev      CHAR(1);
    v_affected_rows             INT;
    v_entity_level              INT;
    v_approval_level            INT;
    r                           RECORD;    
BEGIN
    
    SELECT INTO 
        v_request_id
        , v_quantity
        , v_approval_level
        
        requests.request_id
        , requests_products.quantity
        , requests.approval_level
    FROM requests
    JOIN requests_products ON requests_products.request_id = requests.request_id
    WHERE request_product_id = p_request_product_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Material não encontrado.';
    END IF;
    
    IF p_quantity_approved IS NOT NULL AND p_quantity_approved > v_quantity THEN
        RAISE EXCEPTION 'Quantidade aprovada não pode ser superior à quantidade solicitada.';
    END IF;
    
    -- Obtem o nivel da entidade (0 no topo)
    SELECT INTO 
        v_entity_level
        level
    FROM entities
    WHERE entity_id = p_entity_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Entidade não encontrada: %', p_entity_id;
    END IF;
    
    -- Tabela com lacunas de aprovação
    UPDATE requests_approvals
    SET quantity_approved = COALESCE(p_quantity_approved, v_quantity)
    , approval_at = CURRENT_TIMESTAMP
    , approval_by = p_username
	WHERE request_product_id = p_request_product_id 
	AND approval_entity_id = p_entity_id;
    
    GET DIAGNOSTICS v_affected_rows = row_count;
    
    IF v_affected_rows <= 0 THEN
        RAISE EXCEPTION 'Nenhuma lacuna de aprovação foi preenchida na atualização.';
    END IF;
    
    -- Coloca em processo de aprovação
    IF v_status = 'C' THEN
        UPDATE requests
        SET status = 'A'
        WHERE request_id = v_request_id;
    END IF;
    
    -- Atualiza a aprovação do produto
    IF v_approval_level IS NULL OR v_approval_level >= v_entity_level THEN
        UPDATE requests_products
        SET quantity_approved = COALESCE(p_quantity_approved, v_quantity)
        , approval_at = CURRENT_TIMESTAMP
        , approval_by = p_username
        WHERE request_product_id = p_request_product_id;
    END IF;
    
    -- Obtém o status atual
    SELECT INTO 
        v_status, v_approval_status
        status, approval_status
    FROM requests
    WHERE request_id = v_request_id;
	
	IF NOT FOUND THEN
		RAISE INFO 'Lacuna para preenchimento do status da entidade não encontrado.';
	END IF;
    
    v_approval_status_prev = v_approval_status;
    
    IF v_approval_status IN('O', 'R', 'P', 'T') THEN
        SELECT INTO r
            --requests_approvals.request_approval_id,
            SUM(requests_products.quantity) total,
            SUM(COALESCE(requests_approvals.quantity_approved,0)) total_approved,
            MAX(CASE WHEN requests_approvals.quantity_approved IS NULL THEN 1 ELSE 0 END) has_nulls
        FROM requests_products
        LEFT JOIN requests_approvals
        ON requests_approvals.request_product_id = requests_products.request_product_id
        AND requests_approvals.approval_entity_id = p_entity_id
        WHERE requests_products.request_id = v_request_id
		;--GROUP BY 1;
    
        IF FOUND AND (v_approval_level IS NULL OR v_approval_level >= v_entity_level OR v_entity_level = 0) THEN
            -- Grava o level da entidade de maior autoridade que já fez a aprovação
            UPDATE requests
            SET approval_level = v_entity_level
            WHERE request_id = v_request_id;
            v_approval_status = null;
            IF r.has_nulls = 0 THEN
                IF r.total = r.total_approved THEN
                    -- Aprovado Total
                    v_approval_status = 'T'; 
                ELSIF r.total_approved = 0 THEN
                    -- Parcialmente Aprovado, ou Reprovado
                    --v_approval_status = CASE WHEN r.has_nulls = 1 THEN 'P' ELSE 'R' END;
                    v_approval_status = 'R';
                ELSIF r.total_approved < r.total THEN
                    -- Parcialmente Aprovado
                    v_approval_status = 'P'; 
                END IF;
            END IF;
            --RAISE INFO '% total %, total_approved %, has_nulls: %', v_status, r.total, r.total_approved, r.has_nulls;
            IF v_approval_status IS NOT NULL THEN
                UPDATE requests
                SET approval_status = v_approval_status
                , approval_at = CASE WHEN v_approval_status_prev <> v_approval_status THEN 
                                    CURRENT_TIMESTAMP 
                                ELSE 
                                    requests.approval_at
                                END
                WHERE request_id = v_request_id;
            END IF;
        END IF;
    END IF;
    
END;
$BODY$
LANGUAGE plpgsql;

--SELECT fnc_request_gen_approvals(request_id) FROM requests


/*
select * from requests_statuses
select * from requests_approvals where quantity_approved is not null

select fnc_request_gen_approvals(request_id) FROM requests 
*/
--SELECT fnc_request_approve('admin', '182ea075-767b-4489-8617-df4099ddb54d', '7aa37b4d-edbd-4f71-adc1-5081a9df9f74');