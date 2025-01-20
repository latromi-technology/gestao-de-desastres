CREATE TABLE requests_products
(
	request_product_id	UUID NOT NULL DEFAULT gen_random_uuid(),	
	request_id			UUID NOT NULL,
	product_id			INT NOT NULL,
	unit_id				INT NOT NULL,
	quantity			NUMERIC(10,2),
    quantity_edited     NUMERIC(10,2),
	quantity_approved	NUMERIC(10,2),
    quantity_supplied   NUMERIC(10,2),
	notes				TEXT,
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by          TEXT,
    updated_at          TIMESTAMPTZ,
    approved_by         TEXT,
    approved_at         TIMESTAMPTZ,
    supplied_at         TIMESTAMPTZ,
    supplied_by         TEXT,
	CONSTRAINT pk_requestproducts_id PRIMARY KEY (request_product_id),
	CONSTRAINT fk_requestproducts_requestid FOREIGN KEY (request_id) REFERENCES requests (request_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT pk_requestproducts_unitid FOREIGN KEY (unit_id) REFERENCES units (unit_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_requestproducts_productid FOREIGN KEY (product_id) REFERENCES products (product_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE requests_products IS 'Produtos que compões a demanda';
COMMENT ON COLUMN requests_products.request_product_id IS 'Identificador do registro de solicitação de produto na demanda';
COMMENT ON COLUMN requests_products.product_id IS 'Identificador do produto';
COMMENT ON COLUMN requests_products.unit_id IS 'Identificador da unidade de medida usada para quantificar o produto';
COMMENT ON COLUMN requests_products.quantity IS 'Quantidade solicitada';
COMMENT ON COLUMN requests_products.quantity_edited IS 'Quantidade modificada após a solicitação';
COMMENT ON COLUMN requests_products.quantity_approved IS 'Quantidade aprovada';
COMMENT ON COLUMN requests_products.quantity_supplied IS 'Quantidade atendida';
COMMENT ON COLUMN requests_products.notes IS 'Observações associadas ao produto';
COMMENT ON COLUMN requests_products.created_at IS 'Data e hora em que o registro foi inserido';
COMMENT ON COLUMN requests_products.updated_at IS 'Data e hora da última atualização do registro';
COMMENT ON COLUMN requests_products.updated_by IS 'Nome de usuário de quem fez a última atualização no registro';
COMMENT ON COLUMN requests_products.approved_at IS 'Data e hora da aprovação';
COMMENT ON COLUMN requests_products.approved_by IS 'Nome de usuário de quem fez a aprovação';
COMMENT ON COLUMN requests_products.supplied_at IS 'Data e hora do atendimento da demanda';
COMMENT ON COLUMN requests_products.supplied_by IS 'Nome de usuário de quem registrou o atendimento da demanda';