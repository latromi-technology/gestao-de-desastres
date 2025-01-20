SET SEARCH_PATH = gov;

CREATE OR REPLACE FUNCTION fnc_offer_calc_weight(p_offer_id UUID )
    RETURNS VOID AS 
 $BODY$
DECLARE
    r_offer RECORD;
BEGIN
    SELECT INTO r_offer
        o.estimated_weight_kg, 
        COUNT(op.offer_product_id) AS total
    FROM offers o
    JOIN offers_products op ON op.offer_id = o.offer_id
    WHERE o.offer_id = p_offer_id
    GROUP BY o.offer_id, o.estimated_weight_kg;
    
    IF FOUND AND COALESCE(r_offer.estimated_weight_kg, 0) > 0 AND r_offer.total > 0 THEN
        UPDATE offers_products
        SET estimated_weight_kg = r_offer.estimated_weight_kg / r_offer.total
        WHERE offer_id = p_offer_id;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

