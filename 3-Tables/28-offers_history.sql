CREATE TABLE offers_history
(
	offer_history_id 	SERIAL NOT NULL,
	offer_id			UUID NOT NULL,
	operator_username	TEXT,
	operator_notes		TEXT,
	created_at 			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	type 				CHAR(1) NOT NULL DEFAULT 'U',
	CONSTRAINT pk_offerhistory_id PRIMARY KEY (offer_history_id),
	CONSTRAINT fk_offerhistory_offerid FOREIGN KEY (offer_id) REFERENCES offers(offer_id) ON DELETE CASCADE ON UPDATE CASCADE
);
COMMENT ON TABLE offers_history IS 'Informações inseridas pelo operador e registradas em formato de histórico na oferta (doação).';
COMMENT ON COLUMN offers_history.offer_history_id IS 'Identificador da entrada no histórico da oferta';
COMMENT ON COLUMN offers_history.operator_username IS 'Nome de usuário do operador que inseriu a informação no histórico';
COMMENT ON COLUMN offers_history.operator_notes IS 'Texto inserido pelo operador no histórico';
COMMENT ON COLUMN offers_history.created_at IS 'Data e hora em que o registro foi criado';
COMMENT ON COLUMN offers_history.type IS 'Tipo de modificação: U-Update, X-Cancel';