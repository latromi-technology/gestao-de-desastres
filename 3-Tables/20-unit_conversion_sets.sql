CREATE TABLE unit_conversion_sets
(
    unit_conversion_set_id      UUID NOT NULL DEFAULT gen_random_uuid(),
    name                        VARCHAR(63) NOT NULL,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_unitconversionsets_id PRIMARY KEY (unit_conversion_set_id)
);
COMMENT ON TABLE unit_conversion_sets IS 'Conjuntos de conversão de unidades';
COMMENT ON COLUMN unit_conversion_sets.unit_conversion_set_id IS 'Identificador do conjunto de conversões de unidade';
COMMENT ON COLUMN unit_conversion_sets.name IS 'Nome do conjunto';
COMMENT ON COLUMN unit_conversion_sets.created_at IS 'Data e hora de criação do registro';
COMMENT ON COLUMN unit_conversion_sets.updated_at IS 'Data e hora em que o registro foi atualizado pela última vez';