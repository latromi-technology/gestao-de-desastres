SET search_path = gov;

DROP FUNCTION IF EXISTS fnc_text_reduce;
CREATE OR REPLACE FUNCTION fnc_text_reduce(
    p_text              TEXT, 
    p_limit             INT,
    p_remove_breaks     BOOLEAN DEFAULT true
) RETURNS TEXT AS 
$BODY$
DECLARE
    v_result TEXT = p_text;
BEGIN

    IF TRIM(COALESCE(p_text, '')) = '' THEN
        RETURN p_text;
    END IF;
    
    IF p_remove_breaks THEN
        v_result = REPLACE(v_result, E'\r\n', E'\n');
        v_result = REPLACE(v_result, E'\r', E'\n');
        v_result = REPLACE(v_result, E'\n', E' ');
    END IF;

    -- Troca TABs por um espaço
    v_result = REPLACE(v_result, E'\t', ' ');

    -- Remove espaços em duplicidade
    v_result = REGEXP_REPLACE(v_result, ' +', ' ', 'g');
    
    -- Corta o excesso de texto e coloca "..."
    IF char_length(v_result) > p_limit THEN
        v_result = SUBSTR(v_result, 0, p_limit -3)||'...';
    END IF;
    
    RETURN v_result;
END;
$BODY$
LANGUAGE plpgsql;