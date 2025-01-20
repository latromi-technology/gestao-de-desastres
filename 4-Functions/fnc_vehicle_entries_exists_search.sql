set search_path = gov;
DROP FUNCTION IF EXISTS fnc_vehicle_entries_exists_search;
CREATE OR REPLACE FUNCTION fnc_vehicle_entries_exists_search(
    p_start_date    DATE,
    p_end_date      DATE,
    p_search_text   TEXT
    
) RETURNS SETOF INT AS 
$BODY$
DECLARE
    v_query             TEXT;
    v_search_text       TEXT = p_search_text;
    v_regex_escape      TEXT = '][.\\|()-?*{}';
    v_puncts            TEXT[] = ARRAY['cç', 'aäáãàâ', 'eëéèê', 'iïíìî', 'oöóõòô', 'uüúùû'];
BEGIN
    --Faz o escape dos carecteres especiais de expressão regular
    FOR i IN 1..LENGTH(v_regex_escape)
    LOOP
        v_search_text = REPLACE(v_search_text, SUBSTR(v_regex_escape,i,1), '[' ||SUBSTR(v_regex_escape,i,1) || ']');
    END LOOP;

    -- Tratamento para desconsiderar os acentos
    FOR i IN 1..ARRAY_UPPER(v_puncts, 1)
    LOOP
        v_search_text = REGEXP_REPLACE(v_search_text, '['||v_puncts[i]||']', '['||v_puncts[i]||']', 'gi');
    END LOOP;
        
    v_query = 
    $sql$
        SELECT
            vee.vehicle_entry_exit_id
        FROM vehicle_entries_exits vee
        LEFT JOIN carriers carr ON carr.carrier_id = vee.carrier_id
        LEFT JOIN truck_types tp ON tp.truck_type_id = vee.vehicle_type_id
        LEFT JOIN cities ct ON ct.city_id = vee.city_id
        WHERE vee.status  <> 'T'
    $sql$;
    
    -- Data Inicial
    IF COALESCE(TRIM(v_search_text, '')) <> '' THEN
        v_query = v_query || 
        ' AND (vee.driver_name ~* $1 
            OR tp.name ~* $1
			OR carr.name ~* $1 
            OR ct.name ~* $1
            OR vee.city_name ~* $1
            OR vee.vehicle_plate ~* $1
            )';
    END IF;
    
    -- Data Inicial
    IF p_start_date IS NOT NULL THEN
        v_query = v_query || ' AND vee.created_at >= $2';
    END IF;
    
    -- Data final
    IF p_end_date IS NOT NULL THEN
        v_query = v_query || ' AND COALESCE(vee.outbound_at, vee.started_at, vee.inbound_at, vee.authorized_at, vee.created_at) <= $3';
    END IF;
    
    RETURN QUERY
        EXECUTE v_query 
        USING v_search_text, p_start_date, p_end_date + INTERVAL '59:59:59.999';
    
END;
$BODY$
LANGUAGE plpgsql;
/*
select fnc_vehicle_entries_exists_search ('2024-01-01', '2024-12-31', 'exercito')

*/