CREATE TABLE offers_products
(
	offer_product_id	UUID NOT NULL DEFAULT gen_random_uuid(),
	offer_id			UUID NOT NULL,
	product_id			INT,
	product_others		TEXT,
	unit_id				INT,
	quantity			NUMERIC(10,2),
	notes				TEXT,
    estimated_weight_kg DECIMAL(10,2),
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_offersproducts_id PRIMARY KEY (offer_product_id),
	CONSTRAINT fk_offersproducts_offerid FOREIGN KEY (offer_id) REFERENCES offers(offer_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_offersproducts_productid FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_offersproducts_unitid FOREIGN KEY (unit_id) REFERENCES units(unit_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE offers_products IS 'Produtos registrados na oferta (doação)';
COMMENT ON COLUMN offers_products.offer_product_id IS 'Identificador do produto registrado na oferta (doação)';
COMMENT ON COLUMN offers_products.offer_id IS 'Identificador da oferta (doação)';
COMMENT ON COLUMN offers_products.product_id IS 'Identificador do produto';
COMMENT ON COLUMN offers_products.product_others IS 'Outros (descritivo). Texto usado para descrever produtos que não estão cadastrados';
COMMENT ON COLUMN offers_products.unit_id IS 'Identificador da unidade de medida';
COMMENT ON COLUMN offers_products.quantity IS 'Quantidade do donativo. Se estiver NULL, é porque o doador não sabe a quantidade correta';
COMMENT ON COLUMN offers_products.notes IS 'Observações sobre o donativo';
COMMENT ON COLUMN offers_products.estimated_weight_kg IS 'Peso estimado total do donativo';
COMMENT ON COLUMN offers_products.created_at IS 'Data e hora de registro do produto na oferta';