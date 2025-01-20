SET search_path = gov;
DROP FUNCTION IF EXISTS fnc_user_get_entities;
CREATE OR REPLACE FUNCTION fnc_user_get_entities(
    p_username TEXT
)
    RETURNS SETOF UUID AS
$BODY$
DECLARE
    r RECORD;
BEGIN
	PERFORM 1
	FROM users
	WHERE username = p_username;

    FOR r IN 
        SELECT  
            eu.entity_id AS entity_id_list
        FROM users u
        JOIN entities_users eu ON eu.user_id = u.user_id
        WHERE username = p_username
    LOOP
		RETURN NEXT r.entity_id_list;
    END LOOP;

END;
$BODY$
LANGUAGE plpgsql;

    


--select fnc_user_get_entities('thiago_casces')




    