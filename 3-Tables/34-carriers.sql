CREATE TABLE carriers
(
    carrier_id      SERIAL NOT NULL,
    name            TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by      TEXT,
    updated_at      TIMESTAMPTZ,
    updated_by      TEXT,
    CONSTRAINT pk_carriers_carrierid PRIMARY KEY (carrier_id)
);
COMMENT ON TABLE carriers IS 'Cadastro de transportadoras';
COMMENT ON COLUMN carriers.carrier_id IS 'Identificador da transportadora';
COMMENT ON COLUMN carriers.name IS 'Nome da transportadora';
COMMENT ON COLUMN carriers.created_at IS 'Data e hora em que o registro foi criado';
COMMENT ON COLUMN carriers.created_by IS 'Nome de usuário de quem criou o registro';
COMMENT ON COLUMN carriers.updated_at IS 'Data e hora da última vez que o registro foi modificado';
COMMENT ON COLUMN carriers.updated_by IS 'Nome de usuário de quem modificou o registro pela última vez';