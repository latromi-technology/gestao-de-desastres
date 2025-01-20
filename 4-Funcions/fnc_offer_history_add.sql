DROP FUNCTION IF EXISTS fnc_offer_updated;
DROP FUNCTION IF EXISTS fnc_offer_history_add;

CREATE OR REPLACE FUNCTION fnc_offer_history_add (
	p_username 		TEXT, 
	p_offer_id 		UUID, 
	p_notes 		TEXT,
	p_type			CHAR(1) DEFAULT 'U'
)
RETURNS UUID AS 
$BODY$
--p_type: U-Update, X-Cancel
DECLARE
	v_result UUID;
BEGIN
	INSERT INTO offers_history
	(
		offer_id
		, operator_username
		, operator_notes
		, type
	)
	VALUES
	(
		p_offer_id
		, p_username
		, p_notes
		, p_type
	) 
	RETURNING offer_id INTO v_result;
	
	RETURN v_result;
END;
$BODY$
LANGUAGE plpgsql;
	