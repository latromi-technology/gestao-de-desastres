set search_path=gov;

CREATE OR REPLACE FUNCTION fnc_time_pretty (p_time INTERVAL)
	RETURNS TEXT AS 
$BODY$
DECLARE

BEGIN
	IF p_time > interval '1 hour' THEN
		RETURN TO_CHAR(p_time, 'HH:MI:SS');
	ELSIF p_time > interval '1 minute' THEN
		RETURN TO_CHAR(p_time, 'MI:SS');
	ELSE
		RETURN TO_CHAR(p_time, 'SS "seg"');
	END IF;
END;
$BODY$
LANGUAGE plpgsql STABLE;