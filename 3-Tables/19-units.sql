CREATE TABLE units
(
	unit_id 	SERIAL NOT NULL,
	name		TEXT NOT NULL,
	symbol		TEXT,
	CONSTRAINT pk_units_id PRIMARY KEY (unit_id),
	CONSTRAINT uk_units_symbol UNIQUE (symbol)
);
COMMENT ON TABLE units IS 'Cadastro de unidades de medidas';
COMMENT ON COLUMN units.unit_id IS 'Identificador da unidade de medida';
COMMENT ON COLUMN units.name IS 'Nome da unidade de medida. Exemplo: Quilo, Caixa, Unidade';
COMMENT ON COLUMN units.symbol IS 'Simbolo/Sigla da unidade de medida. Exemplo: KG, CX, UN';

-- Insere unidades
INSERT INTO units (name, symbol) 
	VALUES  ('Unidade', 'UN'),
			('Litros', 'L'),
			('Sacos 50L', 'SC50L'),
			('Kit', 'KIT'),
			('Kilogramas', 'KG'),
			('Pallet', 'PLT');