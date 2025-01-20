CREATE TABLE products
(
	product_id 			        SERIAL NOT NULL,
	name 				        TEXT NOT NULL,
	offer_unit_id		        INT,
	request_unit_id		        INT,
    priority                    INT,
	category_id 		        INT,
	created_at			        TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at			        TIMESTAMPTZ,
	weight_kg 			        NUMERIC(10,2),
    allow_offer                 BOOLEAN NOT NULL DEFAULT FALSE,
    icon_file_id                UUID,
    short_description           VARCHAR(15),
    offer_short_description     VARCHAR(30),
    request_short_description   VARCHAR(30),
    unit_conversion_set_id      UUID,
	CONSTRAINT pk_products_id PRIMARY KEY (product_id),
	CONSTRAINT fk_products_offerunitid FOREIGN KEY (offer_unit_id) REFERENCES units(unit_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_products_requestunitid FOREIGN KEY (request_unit_id) REFERENCES units(unit_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_products_categoryid FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_products_iconfileid FOREIGN KEY (icon_file_id)
        REFERENCES files (file_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT fk_products_unitconvsetid  FOREIGN KEY (unit_conversion_set_id) 
        REFERENCES unit_conversion_sets (unit_conversion_set_id) ON DELETE SET NULL ON UPDATE CASCADE
);
COMMENT ON TABLE products IS 'Cadastro de produtos (donativos)';
COMMENT ON COLUMN products.product_id IS 'Identificador do produto';
COMMENT ON COLUMN products.name IS 'Nome do produto';
COMMENT ON COLUMN products.offer_unit_id IS 'Identificador da unidade de medida usada nas ofertas (doações).';
COMMENT ON COLUMN products.request_unit_id IS 'Identificador da unidade de medida usada nas demandas (necessidades dos munícipios).';
COMMENT ON COLUMN products.priority IS 'Número que indica o nível de pririodade de um produto como donativo. Quanto maior o número, maior a demanda.';
COMMENT ON COLUMN products.category_id IS 'Identificador da categoria do produto';
COMMENT ON COLUMN products.created_at IS 'Data e hora de criação do registro no banco de dados';
COMMENT ON COLUMN products.updated_at IS 'Data e hora da última atulaização do registro no banco de dados';
COMMENT ON COLUMN products.weight_kg IS 'Peso aproximado do produto em KG';
COMMENT ON COLUMN products.allow_offer IS 'Se true, indique o produto está habilitado para ser recebido através de doações. Produtos desabilitados não são listados na tela de registro de doações do SAC.';
COMMENT ON COLUMN products.icon_file_id IS 'Identificador do arquivo PNG com o ícone do produto.';
COMMENT ON COLUMN products.short_description IS '[Obsoleto: Esta coluna deixou de ser usada e foi subsituida por "offer_short_description" e "request_short_description"] Descrição curta do produto para ofertas. Este campo é usado para adicionar observações ao nome do produto. O texto é exibido entre parenteses ao lado do nome do produto.';
COMMENT ON COLUMN products.offer_short_description IS 'Descrição curta do produto para demandas. Este campo é usado para adicionar observações ao nome do produto. O texto é exibido entre parenteses ao lado do nome do produto.';
COMMENT ON COLUMN products.request_short_description IS 'Descrição curta do produto para ofertas (doações). Este campo é usado para adicionar observações ao nome do produto. O texto é exibido entre parenteses ao lado do nome do produto.';
COMMENT ON COLUMN products.unit_conversion_set_id IS 'Id do conjunto de unidades de conversão associado';

-- Insere produtos iniciais
INSERT INTO products (name, offer_unit_id, request_unit_id)
	VALUES 	('Kits de Cesta Básica',(SELECT unit_id FROM units WHERE symbol = 'UN')		,(SELECT unit_id FROM units WHERE symbol = 'PLT')),	
			('Água',   				(SELECT unit_id FROM units WHERE symbol = 'L')		,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Roupa Masculina',  	(SELECT unit_id FROM units WHERE symbol = 'SC50L')	,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Roupa Feminina',  	(SELECT unit_id FROM units WHERE symbol = 'SC50L')	,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Roupa Infantil',  	(SELECT unit_id FROM units WHERE symbol = 'SC50L')	,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Calçados',  			(SELECT unit_id FROM units WHERE symbol = 'SC50L')	,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Colchões',  			(SELECT unit_id FROM units WHERE symbol = 'UN')		,(SELECT unit_id FROM units WHERE symbol = 'UN')),
			('Cama/Mesa/Banho',  	(SELECT unit_id FROM units WHERE symbol = 'KIT')	,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Limpeza',  			(SELECT unit_id FROM units WHERE symbol = 'KIT')	,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Ração Pet',  			(SELECT unit_id FROM units WHERE symbol = 'KG')		,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Higiene',  			(SELECT unit_id FROM units WHERE symbol = 'KIT')	,(SELECT unit_id FROM units WHERE symbol = 'PLT')),
			('Cobertor',  			(SELECT unit_id FROM units WHERE symbol = 'UN')		,(SELECT unit_id FROM units WHERE symbol = 'UN'));