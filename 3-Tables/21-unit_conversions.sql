CREATE TABLE unit_conversions
(
    unit_conversion_id      UUID NOT NULL DEFAULT gen_random_uuid(),
    unit_conversion_set_id  UUID NOT NULL,
    in_unit_id              INT NOT NULL,
    out_unit_id             INT NOT NULL,
	converter               NUMERIC(10,5) NOT NULL,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_unitconversions_id PRIMARY KEY (unit_conversion_id),
    CONSTRAINT uk_unitconversions_unitconvsetid_unitin_unitout UNIQUE(unit_conversion_set_id, in_unit_id, out_unit_id),
    CONSTRAINT fk_unitconversions_unitin FOREIGN KEY (in_unit_id) REFERENCES units (unit_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_unitconversions_unitout FOREIGN KEY (out_unit_id) REFERENCES units (unit_id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_unitconversions_unitconvsetid FOREIGN KEY (unit_conversion_set_id) REFERENCES unit_conversion_sets (unit_conversion_set_id) 
        ON DELETE CASCADE ON UPDATE CASCADE
);
COMMENT ON TABLE unit_conversions IS 'Conversões de unidades do conjunto';
COMMENT ON COLUMN unit_conversions.unit_conversion_id IS 'Identificador da conversão de unidade';
COMMENT ON COLUMN unit_conversions.unit_conversion_set_id IS 'Identificador do conjunto de conversões de unidades';
COMMENT ON COLUMN unit_conversions.in_unit_id IS 'Identificador da unidade de medida de entrada';
COMMENT ON COLUMN unit_conversions.out_unit_id IS 'Identificador da unidade de medida de saída';
COMMENT ON COLUMN unit_conversions.converter IS 'Fator de conversão';
COMMENT ON COLUMN unit_conversions.created_at IS 'Data e hora em que o registro foi criado';
COMMENT ON COLUMN unit_conversions.updated_at IS 'Data e hora em que o registro foi atualizado pela última vez';