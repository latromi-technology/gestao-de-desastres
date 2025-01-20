SET search_path = gov;

CREATE OR REPLACE FUNCTION fnc_user_get_entities(
    p_username      TEXT,
    p_routine       TEXT
)
    RETURNS SETOF UUID AS
$BODY$
/*
    p_routine: Rotina que está solicitando as entidades:
                - OFFERS (doações)
                - REQUESTS (demandas)
                - YMS (Gerenciamento de Pátio)
*/
DECLARE
    r       RECORD;
    v_found BOOLEAN = FALSE;
BEGIN
    /*
    FOR r IN 
        -- Entidade que o usuário faz parte
        SELECT  
            eu.entity_id AS entity_id_list
        FROM users u
        JOIN entities_users eu ON eu.user_id = u.user_id
        WHERE username = p_username
    LOOP
		v_found = TRUE;
		RETURN NEXT r.entity_id_list;
    END LOOP;*/

    FOR r IN
        WITH RECURSIVE t(entity_id, is_child) AS (
            SELECT DISTINCT
                eu.entity_id, false
            FROM users u
            JOIN entities_users eu ON eu.user_id = u.user_id
            WHERE username = p_username

          UNION ALL

            SELECT e.entity_id, true
            FROM entities e, t
            WHERE e.parent_entity_id = t.entity_id
        )
        SELECT DISTINCT entity_id, is_child 
        FROM t
    LOOP
		v_found = TRUE;
        
        -- Quando for "demandas" precisa retornar todas 
        -- as entidades abaixo (filhas).
        IF p_routine NOT IN ('REQUESTS') THEN
            CONTINUE WHEN r.is_child;
        END IF;
        
		RETURN NEXT r.entity_id;
    END LOOP;

    -- Se o usuário não está associado a 
    -- nenhuma entidade, ele te acesso a todas
    IF NOT v_found THEN
        RETURN QUERY SELECT entity_id FROM entities;
    END IF;

END;
$BODY$
LANGUAGE plpgsql;

    



    