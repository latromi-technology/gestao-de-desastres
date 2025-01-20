SET SEARCH_PATH = gov;


CREATE OR REPLACE FUNCTION fnc_entity_get_level(p_entity_id UUID)
    RETURNS INT AS 
$BODY$
DECLARE
    v_result INT;
BEGIN
    EXECUTE 
    'WITH RECURSIVE t(entity_id, name, level) AS (
        
        SELECT entity_id, name, 0 AS level
        FROM entities
        WHERE parent_entity_id IS NULL

      UNION ALL

        SELECT e.entity_id, e.name, t.level+1
        FROM entities e, t
        WHERE e.parent_entity_id = t.entity_id
    )
    SELECT level 
    FROM t
    WHERE entity_id = $1'
        USING p_entity_id
        INTO v_result;

    RETURN v_result;

END;
$BODY$
LANGUAGE plpgsql;

--select fnc_entity_get_level (entity_id) from entities
