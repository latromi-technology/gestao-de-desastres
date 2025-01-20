CREATE OR REPLACE FUNCTION fnc_format_protocol(p_protocol TEXT)
RETURNS TEXT AS 
$BODY$
DECLARE

BEGIN
	IF CHAR_LENGTH(p_protocol) = 14 THEN
		RETURN SUBSTR(p_protocol, 1, 2)
			|| ' ' || SUBSTR(p_protocol, 3, 3) 
			|| '-' || SUBSTR(p_protocol, 6, 3) 
			|| '-' || SUBSTR(p_protocol, 9, 3)
            || '-' || SUBSTR(p_protocol, 12);
	END IF;
	RETURN p_protocol;
END;
$BODY$
LANGUAGE plpgsql STABLE;