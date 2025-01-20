CREATE TABLE regions
(	
	region_id			SERIAL NOT NULL,
	name				TEXT,
	--cnpj				VARCHAR(14),
	city_id				INT,
	main_contact_name	TEXT,
	main_contact_phone	TEXT,
	main_contact_email	TEXT,
	alt_contact_name	TEXT,
	alt_contact_phone	TEXT,
	alt_contact_email	TEXT,
	cep					VARCHAR(8),
	district			TEXT,
	address				TEXT,
	coordinates			point,
	created_at 			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_regions_id PRIMARY KEY (region_id),
	CONSTRAINT pk_regions_cityid FOREIGN KEY (city_id) REFERENCES cities (city_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE regions IS 'Cadastro das coordenadorias regionais de proteção e defesa civil (regionais).';
COMMENT ON COLUMN regions.region_id IS 'Identificador da regional';
COMMENT ON COLUMN regions.name IS 'Nome da regional';
COMMENT ON COLUMN regions.city_id IS 'Identificador da cidade da regional';
COMMENT ON COLUMN regions.main_contact_name  IS 'Nome do contato principal na regional';
COMMENT ON COLUMN regions.main_contact_phone IS 'Telefone do contato principal na regional';
COMMENT ON COLUMN regions.main_contact_email IS 'E-mail do contato principal na regional';
COMMENT ON COLUMN regions.alt_contact_name  IS 'Nome do contato alternativo na regional';
COMMENT ON COLUMN regions.alt_contact_phone IS 'Telefone do contato alternativo na regional';
COMMENT ON COLUMN regions.alt_contact_email IS 'E-mail do contato alternativo na regional';
COMMENT ON COLUMN regions.cep IS 'Código posta da regional';
COMMENT ON COLUMN regions.district IS 'Bairro da regional';
COMMENT ON COLUMN regions.address IS 'Endereço da regional';
COMMENT ON COLUMN regions.coordinates IS 'Coordenadas (latitude, longitude) da regional';
COMMENT ON COLUMN regions.created_at IS 'Data e hora de criação do registro no banco de dados';