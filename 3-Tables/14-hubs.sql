CREATE TABLE hubs
(    
    hub_id                	SERIAL NOT NULL,
    name                	TEXT,
    main_contact_name    	TEXT,
    main_contact_phone    	TEXT,
    main_contact_email    	TEXT,
    alt_contact_name    	TEXT,
    alt_contact_phone    	TEXT,
    alt_contact_email    	TEXT,
    cep                    	VARCHAR(8),
    city_id                	INT,
    district            	TEXT,
    address                	TEXT,
    coordinates            	point,
    enabled             	BOOLEAN NOT NULL DEFAULT TRUE,
    hub                 	BOOLEAN NOT NULL DEFAULT FALSE,
    dc                  	BOOLEAN NOT NULL DEFAULT TRUE,
    created_at             	TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_hubs_id PRIMARY KEY (hub_id),
    CONSTRAINT pk_hubs_cityid FOREIGN KEY (city_id) REFERENCES cities (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE hubs IS 'Cadastro dos bases logísticas, local onde os donativos são recebidos e processados antes de serem entregues no destino final (municipio)';
COMMENT ON COLUMN hubs.hub_id IS 'Identificador da base logística';
COMMENT ON COLUMN hubs.name IS 'Nome da base logística';
COMMENT ON COLUMN hubs.main_contact_name IS 'Nome do contato principal na base';
COMMENT ON COLUMN hubs.main_contact_phone IS 'Telefone do contato principal na base';
COMMENT ON COLUMN hubs.main_contact_email IS 'E-mail do contato principal na base';
COMMENT ON COLUMN hubs.alt_contact_name IS 'Nome do contato alternativo na base';
COMMENT ON COLUMN hubs.alt_contact_phone IS 'Telefone do contato alternativo na base';
COMMENT ON COLUMN hubs.alt_contact_email IS 'E-mail do contato alternativo na base';
COMMENT ON COLUMN hubs.cep IS 'Código Postal do endereço da base';
COMMENT ON COLUMN hubs.city_id IS 'Identificador da Cidade';
COMMENT ON COLUMN hubs.district IS 'Bairro da base';
COMMENT ON COLUMN hubs.address IS 'Rua e número do endereço da base';
COMMENT ON COLUMN hubs.coordinates IS 'Coordenadas (latitude e longitude) da base';
COMMENT ON COLUMN hubs.enabled IS 'Se true, indica que a base está habilitada para receber doações. Bases desabilitadas não são listadass como destinos possíveis das doações.';
COMMENT ON COLUMN hubs.hub IS 'Se true, indica que a base logística é um Hub. Hubs são responsáveis por abastecer os centros de distribuição.';
COMMENT ON COLUMN hubs.dc IS 'Se true, indica que a base logística é um CD (Centro de Distribuição). Os CDs distribuem os donativos aos munípios.';
COMMENT ON COLUMN hubs.created_at IS 'Data e hora de criação do registro no banco de dados';