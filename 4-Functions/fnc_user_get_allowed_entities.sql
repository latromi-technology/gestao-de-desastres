SET search_path = gov;

CREATE OR REPLACE FUNCTION fnc_user_get_allowed_entities(
    p_username TEXT
)
    RETURNS SETOF UUID AS
$BODY$
DECLARE
    r       RECORD;
    v_found BOOLEAN = FALSE;
BEGIN

    FOR r IN 
        SELECT  
            eu.entity_id AS entity_id_list
        FROM users u
        JOIN entities_users eu ON eu.user_id = u.user_id
        WHERE username = p_username
    LOOP
		v_found = TRUE;
		RETURN NEXT r.entity_id_list;
    END LOOP;
    
    IF NOT v_found THEN
		RAISE INFO 'Teste %',v_found;
        RETURN QUERY
            SELECT entity_id
            FROM entities;
    END IF;
    

END;
$BODY$
LANGUAGE plpgsql;

    


--WHERE entity_id IN (select fnc_user_get_allowed_entities('latromi\daniel.giacomelli'))




    