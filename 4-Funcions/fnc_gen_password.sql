SET SEARCH_PATH = gov;

CREATE OR REPLACE FUNCTION fnc_gen_password(p_length INT DEFAULT 8)
  RETURNS text AS
$BODY$
DECLARE
	v_password text;
	v_chars text;
	v_chars_specials text;
	v_special_pos INT;
BEGIN
	v_password = ''; 
	v_chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
	v_chars_specials = '^@*?$%#()[]{}!';
	
	WHILE(
		COALESCE(SUBSTRING(v_password from '.*[a-z]+.*'),'') = '' OR 
		COALESCE(SUBSTRING(v_password from '.*[A-Z]+.*'),'') = '' OR 
		COALESCE(SUBSTRING(v_password from '.*[0-9]+.*'),'') = '') 
	LOOP
		v_password = '';
		FOR i IN 1..p_length LOOP
		 v_password = v_password || SUBSTRING(v_chars, CEIL(random()*LENGTH(v_chars))::integer, 1);
		END LOOP;
	END LOOP;
	
	v_special_pos = CEIL(random()*p_length)::INT;
	v_password = SUBSTR(v_password, 1, v_special_pos-1)
				||SUBSTRING(v_chars_specials, CEIL(random()*LENGTH(v_chars_specials))::integer, 1)
				||SUBSTR(v_password, v_special_pos+1);
	RETURN v_password;
END;
$BODY$
  LANGUAGE plpgsql;
  
--select fnc_gen_password(10)