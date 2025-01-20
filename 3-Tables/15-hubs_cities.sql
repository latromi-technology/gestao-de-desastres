CREATE TABLE hubs_cities
(
	hub_id				INT NOT NULL,
	city_id				INT NOT NULL,
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	created_by			TEXT,
	updated_at			TIMESTAMPTZ,
	updated_by			TEXT,
	CONSTRAINT pk_hubscities_hubid_cityid PRIMARY KEY (hub_id, city_id),
	CONSTRAINT fk_hubscities_hubid FOREIGN KEY (hub_id) REFERENCES hubs (hub_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_hubscities_cityid FOREIGN KEY (city_id) REFERENCES cities (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE hubs_cities IS 'Cidades atendidas pela base logística.';
COMMENT ON COLUMN hubs_cities.hub_id IS 'Identificador da base logística.';
COMMENT ON COLUMN hubs_cities.city_id IS 'Identificador da cidade atendida.';
COMMENT ON COLUMN hubs_cities.created_at IS 'Data e hora de criação do registro no banco de dados.';
COMMENT ON COLUMN hubs_cities.created_by IS 'Nome de usuário de quem inseriu o registro.';
COMMENT ON COLUMN hubs_cities.updated_at IS 'Data e hora de atualização do registro no banco de dados.';
COMMENT ON COLUMN hubs_cities.updated_by IS 'Nome de usuário de quem fez a última atualização no registro.';