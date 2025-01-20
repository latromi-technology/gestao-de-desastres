CREATE TABLE persons
(
    person_id            SERIAL NOT NULL,
    cpf                    VARCHAR(11),
    name                TEXT,
    phone1_name         TEXT,
    phone1_number       TEXT,
    phone2_name         TEXT,
    phone2_number       TEXT,
    email               TEXT,
    notes               TEXT,
    address_set_id      UUID,
    status              CHAR(1) NOT NULL DEFAULT 'C',
    created_at            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMPTZ,
    CONSTRAINT pk_person_id PRIMARY KEY (person_id),
    CONSTRAINT uk_person_cpf UNIQUE (cpf),
    CONSTRAINT fk_persons_addrsetid FOREIGN KEY (address_set_id) 
        REFERENCES address_sets (address_set_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE persons IS 'Cadastro de Pessoas';
COMMENT ON COLUMN persons.person_id IS 'Identificador da pessoa cadastrada';
COMMENT ON COLUMN persons.cpf IS 'Número do CPF (sem separadores)';
COMMENT ON COLUMN persons.name IS 'Nome completo da pessoa';
COMMENT ON COLUMN persons.phone1_name IS 'Identificação do telefone principal. Exemplo: Celular, Comercial';
COMMENT ON COLUMN persons.phone1_number IS 'Número do telefone principal (com DDD, sem formatação)';
COMMENT ON COLUMN persons.phone2_name IS 'Identificação do telefone alternativo. Exemplo: Celular, Comercial';
COMMENT ON COLUMN persons.phone2_number IS 'Número do telefone alternativo (com DDD, sem formatação)';
COMMENT ON COLUMN persons.email IS 'Endereço de e-mail';
COMMENT ON COLUMN persons.notes IS 'Observações sobre a pessoa';
COMMENT ON COLUMN persons.address_set_id IS 'ID do endereço da pessoa';
COMMENT ON COLUMN persons.status IS 'Situação do cadastro: T-Temporary, C-Created';
COMMENT ON COLUMN persons.created_at IS 'Data e hora de criação do registro';
COMMENT ON COLUMN persons.updated_at IS 'Data e hora em que o registro foi atualizado pela última vez';