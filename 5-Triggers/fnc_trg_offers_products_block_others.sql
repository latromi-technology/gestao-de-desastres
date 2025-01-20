CREATE OR REPLACE FUNCTION gov.fnc_trg_offers_products_block_others ()
    RETURNS SETOF TRIGGER AS
$BODY$
DECLARE
    v_callcenter BOOLEAN = FALSE;
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        
        SELECT INTO 
            v_callcenter
            entities.callcenter
        FROM offers_products
        JOIN offers ON offers.offer_id = offers_products.offer_id
        JOIN entities ON entities.entity_id = offers.entity_id
        WHERE offers_products.offer_product_id = NEW.offer_product_id;
        
        IF NEW.product_id IS NULL AND v_callcenter THEN
            RAISE EXCEPTION 'Donativos fora da lista padrão não estão habilitados no momento.';
        END IF;
        RETURN NEW;
    ELSE
        RETURN OLD;
    END IF;
END;
$BODY$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_offers_products_block_others ON offers_products CASCADE;
CREATE TRIGGER trg_offers_products_block_others
    AFTER INSERT OR UPDATE
    ON gov.offers_products
    FOR EACH ROW
    EXECUTE FUNCTION gov.fnc_trg_offers_products_block_others();
    