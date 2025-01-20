CREATE SCHEMA IF NOT EXISTS gov;

SET SEARCH_PATH = gov;

CREATE OR REPLACE FUNCTION fnc_normalize(
	p_text text,
	p_flags text DEFAULT 'up'::text)
    RETURNS text
    LANGUAGE 'plpgsql'
AS $BODY$
    -- p_flags: 
    --     u (transform to Uppercase) 
    --     p (remove Punctuation)

DECLARE
    v_result TEXT = p_text;
    v_puncts TEXT[] = ARRAY['cç', 'aäáãàâ', 'eëéèê', 'iïíìî', 'oöóõòô', 'uüúùû'];
BEGIN
   
    -- Tratamento para remover os acentos
    IF p_flags ILIKE '%p%' THEN
        FOR i IN 1..ARRAY_UPPER(v_puncts, 1)
        LOOP
            v_result = REGEXP_REPLACE(v_result, '['||v_puncts[i]||']', SUBSTR(v_puncts[i], 1, 1), 'gi');
        END LOOP;
    END IF;

    IF p_flags ILIKE '%u%' THEN
       v_result = UPPER(v_result);   
    ELSIF p_flags ILIKE '%l%' THEN
       v_result = LOWER(v_result);
    END IF;

    -- Remove espaços em branco duplicados, no início e final
    v_result = REGEXP_REPLACE(v_result, ' +', ' ', 'g');
    v_result = REGEXP_REPLACE(v_result, '(?<=[^a-z0-9]) +(?=[a-z0-9])', '', 'gi'); -- Exemplo "hot - dog" vira hot-dog
    v_result = REGEXP_REPLACE(v_result, '(?<=[a-z0-9]) +(?=[^a-z0-9])', '', 'gi');
    v_result = TRIM(v_result);

    RETURN v_result;  
END;
$BODY$;

