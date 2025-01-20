CREATE TABLE hubs_products
(
	hub_product_id 	SERIAL NOT NULL,
	hub_id 			INT NOT NULL,
	product_id 		INT NOT NULL,
	CONSTRAINT pk_hubsproducts_id PRIMARY KEY (hub_product_id),
	CONSTRAINT uk_hubsproducts_hubid_productid UNIQUE (hub_id, product_id),
	CONSTRAINT fk_hubsproducts_hubid FOREIGN KEY (hub_id) REFERENCES hubs(hub_id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_hubsproducts_productid FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE ON UPDATE CASCADE
);
COMMENT ON TABLE hubs_products IS 'Essa tabela contém o produtos que podem ser armazenados ou processados na base logística';
COMMENT ON COLUMN hubs_products.hub_product_id IS 'Identificador do registro';
COMMENT ON COLUMN hubs_products.hub_id IS 'Identificador da base logística';
COMMENT ON COLUMN hubs_products.product_id IS 'Identificador do produto';