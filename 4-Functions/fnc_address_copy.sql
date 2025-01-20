SET SEARCH_PATH = gov;

DROP FUNCTION IF EXISTS fnc_address_copy;

CREATE OR REPLACE FUNCTION fnc_address_copy(
    p_src_address_id UUID, 
    p_name TEXT,
    p_dest_address_id UUID DEFAULT NULL
)
    RETURNS UUID AS 
$BODY$
DECLARE
    v_result UUID;
BEGIN
    
    IF p_dest_address_id IS NULL THEN
        INSERT INTO addresses (
            name
            , state_id
            , city_id
            , city_name
            , cep
            , district
            , address
            , address_number
            , address_complement
        )
        SELECT
            p_name
            , state_id
            , city_id
            , city_name
            , cep
            , district
            , address
            , address_number
            , address_complement
        FROM addresses
        WHERE address_id = p_src_address_id
        RETURNING address_id 
        INTO v_result;
    ELSE
        UPDATE addresses
        SET name = p_name
            , state_id = a.state_id
            , city_id = a.city_id
            , city_name = a.city_name
            , cep = a.cep
            , district = a.district
            , address = a.address
            , address_number = a.address_number
            , address_complement = a.address_complement
        FROM addresses a
        WHERE a.address_id = p_src_address_id
        AND addresses.address_id = p_dest_address_id
        RETURNING addresses.address_id 
        INTO v_result;
    END IF; 
    
    RETURN v_result;
END;
$BODY$
LANGUAGE plpgsql;