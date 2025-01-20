SET search_path = gov;

CREATE OR REPLACE FUNCTION fnc_request_gen_approvals
(
    p_request_id UUID
) RETURNS VOID AS 
$BODY$
DECLARE
    v_entity_id             UUID;
    v_request_approval_id   UUID;
    v_entity_id_list        UUID[];
    v_affected_rows         INT;
    r                       RECORD;
BEGIN
    SELECT INTO 
        v_entity_id
        COALESCE(entities.parent_entity_id, entities.entity_id)
    FROM requests
    JOIN entities ON entities.entity_id = requests.entity_id
    WHERE requests.request_id = p_request_id;
    
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Demanda não encontrada.';
    END IF;
    
    WHILE v_entity_id IS NOT NULL
    LOOP
        FOR r IN 
            SELECT 
                request_product_id
            FROM requests_products
            WHERE request_id = p_request_id
            ORDER BY created_at
        LOOP
			
            -- Cria lacuna para aprovação por entidade
            INSERT INTO requests_approvals
            (
                request_product_id
                , request_id
                , quantity_approved
                , approval_entity_id         
                , approval_at
                , approval_by
            ) 
            VALUES
            (
                r.request_product_id
                , p_request_id
                , NULL
                , v_entity_id         
                , NULL
                , NULL
            )
            ON CONFLICT (request_product_id, approval_entity_id)
            DO NOTHING
            RETURNING request_approval_id
            INTO v_request_approval_id;
        END LOOP;
        
        -- Adiciona o ID da entidade na lista
        v_entity_id_list = ARRAY_APPEND(v_entity_id_list, v_entity_id);
        
        -- Busca a entidade de nível superior
        SELECT INTO v_entity_id
            parent_entity_id
        FROM entities
        WHERE entity_id = v_entity_id;
    END LOOP;
    
    IF v_entity_id_list IS NULL THEN
        v_entity_id_list = ARRAY[]::UUID[];
    END IF;
    -- Se a função foi chamada mais de uma vez, 
    -- exclui os registros de aprovação que sobrearem.
    -- Isso pode acontecer se a hierarquia das entidades 
    -- foi anterada entre cada uma das execuções da função.
    --
    -- Exclui as aprovações
    DELETE FROM requests_approvals
    USING requests_products
    WHERE requests_products.request_product_id = requests_approvals.request_product_id
    AND requests_products.request_id = p_request_id
    AND NOT requests_approvals.approval_entity_id = ANY(v_entity_id_list);
    
END
$BODY$
LANGUAGE plpgsql;

--select * from requests_statuses
--SELECT fnc_request_gen_approvals(request_id) FROM requests