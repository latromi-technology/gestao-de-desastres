CREATE TABLE regions_cities
(
	region_id			INT NOT NULL,
	city_id				INT NOT NULL,
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	created_by			TEXT,
	updated_at			TIMESTAMPTZ,
	updated_by			TEXT,
	CONSTRAINT pk_hubscities_regionid_cityid PRIMARY KEY (region_id, city_id),
	CONSTRAINT fk_hubscities_regionid FOREIGN KEY (region_id) REFERENCES regions (region_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_hubscities_cityid FOREIGN KEY (city_id) REFERENCES cities (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE regions_cities IS 'Relação de munícipios atendidos por cada coordenadorias regionais de proteção e defesa civil (regionais)';
COMMENT ON COLUMN regions_cities.region_id IS 'Identificador da regional';
COMMENT ON COLUMN regions_cities.city_id IS 'Identificador da cidade';
COMMENT ON COLUMN regions_cities.created_at IS 'Data e hora de criação do registro no banco de dados';
COMMENT ON COLUMN regions_cities.created_by IS 'Nome de usuário de quem inseriou o registro';
COMMENT ON COLUMN regions_cities.updated_at IS 'Data e hora da última modificação no registro';
COMMENT ON COLUMN regions_cities.updated_by IS 'Nome de usuário de quem fez a última atualização no registro';