SET search_path = gov;

CREATE OR REPLACE FUNCTION fnc_vehicle_entries_exits_gen_queue_number(
    p_entity UUID
)
RETURNS INT AS
$BODY$
DECLARE
	v_result INT;
BEGIN
    -- 220 foi o último numero gerado manualmente
	SELECT INTO v_result GREATEST(220,COALESCE(MAX(queue_number),0)) +1
	FROM vehicle_entries_exits
	WHERE entity_id = p_entity;
	
	RETURN v_result;

END;
$BODY$
LANGUAGE plpgsql;