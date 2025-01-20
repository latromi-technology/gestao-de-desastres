CREATE TABLE cities
(
	city_id			SERIAL NOT NULL,
	name			TEXT NOT NULL,
	normalized_name TEXT NOT NULL,
	state_id		INT NOT NULL,
	cod_ibge		INT,
	CONSTRAINT pk_cities_id PRIMARY KEY (city_id),
	CONSTRAINT fk_cities_id FOREIGN KEY (state_id) REFERENCES states (state_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE cities IS 'Cadastro de cidade';
COMMENT ON COLUMN cities.city_id IS 'Identificador da cidade';
COMMENT ON COLUMN cities.name IS 'Nome da cidade';
COMMENT ON COLUMN cities.normalized_name IS 'Nome normalizado da cidade';
COMMENT ON COLUMN cities.state_id IS 'Identificador do estado';
COMMENT ON COLUMN cities.cod_ibge IS 'Código do IBGE da cidade';