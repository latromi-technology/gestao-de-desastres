CREATE TABLE truck_types
(
	truck_type_id		SERIAL NOT NULL,
	name				TEXT NOT NULL,
	capacity_kg			NUMERIC(10,2),
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at			TIMESTAMPTZ,
	CONSTRAINT pk_trucktype_id PRIMARY KEY (truck_type_id)
);
COMMENT ON TABLE truck_types IS 'Tipos de veículos (inicialmente eram apenas caminhões)';
COMMENT ON COLUMN truck_types.truck_type_id IS 'Identificador do tipo de veículo';
COMMENT ON COLUMN truck_types.name IS 'Nome do tipo de veículo';
COMMENT ON COLUMN truck_types.capacity_kg IS 'Capacidade do veículo em KG';
COMMENT ON COLUMN truck_types.created_at IS 'Data e hora de criação do registro no banco de dados';
COMMENT ON COLUMN truck_types.updated_at IS 'Data e hora da última modificação no registro';