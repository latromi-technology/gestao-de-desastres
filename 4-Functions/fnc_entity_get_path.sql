SET search_path = gov;
CREATE OR REPLACE FUNCTION fnc_entity_path(p_entity_id UUID, p_separator TEXT DEFAULT '/')
    RETURNS text AS 
$BODY$
DECLARE
   v_result TEXT;
BEGIN
	EXECUTE 
    'WITH RECURSIVE t(name, parent_id) AS (
        SELECT name, parent_entity_id FROM entities WHERE entity_id = $1

      UNION ALL

        SELECT e.name||$2||t.name, e.parent_entity_id
        FROM entities e, t
        WHERE entity_id = t.parent_id
    )
    SELECT name FROM t WHERE parent_id IS NULL'
		USING p_entity_id, p_separator
		INTO v_result;

    RETURN v_result;
END;
$BODY$
LANGUAGE 'plpgsql' STABLE;


--select fnc_entity_path(entity_id) FROm entities