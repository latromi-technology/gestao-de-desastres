SET SEARCH_PATH = gov;

DROP FUNCTION IF EXISTS fnc_unit_convert;

CREATE OR REPLACE FUNCTION fnc_unit_convert
(
    p_in_unit_id_conversion_set_ids UUID[],
    p_quantity NUMERIC(15,5),
    p_in_unit_id INT,
    p_out_unit_id INT,
    p_depth INT DEFAULT 0,
    p_reverse BOOLEAN DEFAULT FALSE,
	p_already_proccessed_unit_conversion_id_list UUID[] DEFAULT ARRAY[]::UUID[]

) RETURNS NUMERIC(15,5) AS 
$BODY$
DECLARE
    r_unit RECORD;
    v_result NUMERIC(15,5);
BEGIN

	IF p_in_unit_id = p_out_unit_id THEN
		RETURN p_quantity;
	END IF;
    
    IF NOT p_reverse THEN
        FOR r_unit IN
            SELECT uc.unit_conversion_id, uc.converter, uc.in_unit_id, uc.out_unit_id
            FROM unit_conversions uc
            WHERE uc.unit_conversion_set_id = ANY(p_in_unit_id_conversion_set_ids)
			AND NOT uc.unit_conversion_id = ANY(p_already_proccessed_unit_conversion_id_list)
            AND uc.in_unit_id = p_in_unit_id
            -- Este ORDER BY faz com que conversão direta seja listada como primeiro registro, caso esteja disponível 
            ORDER BY CASE WHEN uc.out_unit_id = p_out_unit_id THEN 1 ELSE 2 END
        LOOP
			
			IF r_unit.out_unit_id = p_out_unit_id THEN
                RAISE INFO '% para % = x%', p_in_unit_id, p_out_unit_id, r_unit.converter;
				RETURN p_quantity * r_unit.converter;
            END IF;

            -- Inicia busca recursiva
            v_result =  
                fnc_unit_convert(
                    p_in_unit_id_conversion_set_ids, 
                    p_quantity  * r_unit.converter,
                    r_unit.out_unit_id,
                    p_out_unit_id,
                    p_depth + 1,
                    FALSE,
					ARRAY_APPEND(p_already_proccessed_unit_conversion_id_list, r_unit.unit_conversion_id)
                );
            
            EXIT WHEN v_result IS NOT NULL;
        END LOOP;
    END IF;
    
    -- Se já encontrou um resultado, 
    -- ou está dentro de um processamento recursivo, sai fora
    IF v_result IS NOT NULL OR (NOT p_reverse AND p_depth > 0) THEN
        RETURN v_result;
    END IF;
    
    -- Tenta encontrar a conversão através do caminho inverso
	r_unit=null;
    FOR r_unit IN 
        SELECT uc.unit_conversion_id, uc.converter, uc.in_unit_id, uc.out_unit_id
        FROM unit_conversions uc
        WHERE uc.unit_conversion_set_id = ANY(p_in_unit_id_conversion_set_ids)
		AND NOT uc.unit_conversion_id = ANY(p_already_proccessed_unit_conversion_id_list)
        AND uc.out_unit_id = p_in_unit_id
        -- Este ORDER BY faz com que conversão direta seja listada como primeiro registro, caso esteja disponível 
        ORDER BY CASE WHEN uc.in_unit_id = p_out_unit_id THEN 1 ELSE 2 END
    LOOP
        IF r_unit.in_unit_id = p_out_unit_id THEN
			RAISE INFO '% para % = ÷%', p_in_unit_id, p_out_unit_id, r_unit.converter;
            RETURN p_quantity / r_unit.converter;
        END IF;
        
        -- Inicia busca recursiva
        v_result =  
            fnc_unit_convert(
                p_in_unit_id_conversion_set_ids, 
                p_quantity / r_unit.converter,
                r_unit.in_unit_id,
                p_out_unit_id,
                p_depth + 1,
                TRUE,
				ARRAY_APPEND(p_already_proccessed_unit_conversion_id_list, r_unit.unit_conversion_id)
            );
        
        EXIT WHEN v_result IS NOT NULL;
    END LOOP; 
    
    RETURN v_result;
END;
$BODY$
LANGUAGE plpgsql STABLE;

