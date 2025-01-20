CREATE TABLE addresses
(
    address_id          UUID NOT NULL DEFAULT gen_random_uuid(),
	name                TEXT,
    state_id            INT NOT NULL,
    city_id		        INT NOT NULL,
    city_name           TEXT,
    cep                 TEXT,
    district            TEXT,
    address             TEXT NOT NULL,
    address_number      INT,
    address_complement  TEXT,
    address_set_id      UUID,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_address_id PRIMARY KEY (address_id),
    CONSTRAINT fk_address_addrsetid FOREIGN KEY (address_set_id) 
        REFERENCES address_sets (address_set_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_address_stateid FOREIGN KEY (state_id) 
        REFERENCES states (state_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_address_cityid FOREIGN KEY (city_id) 
        REFERENCES cities (city_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE addresses IS 'Endereços cadastrados. Os endereços podem ser cadastrados a vulso ou associados a um conjunto de endereços.';
COMMENT ON COLUMN addresses.address_id IS 'Identificador do endereços (UUID)';
COMMENT ON COLUMN addresses.name IS 'Nome do endereço. Exemplo: Escritório, Depósito, CD-01';
COMMENT ON COLUMN addresses.state_id IS 'Referência do Estado/UF (FK com a tabela "states").';
COMMENT ON COLUMN addresses.city_id IS 'Referência da Cidade (FK com a tabela "cities").';
COMMENT ON COLUMN addresses.city_name IS 'Campo para preenchimento livre do nome da cidade, nos casos onde a cidade não esteja cadastrada.';
COMMENT ON COLUMN addresses.cep IS 'Código de endereço postal';
COMMENT ON COLUMN addresses.district IS 'Nome do Bairro';
COMMENT ON COLUMN addresses.address IS 'Descrição da Rua/Logradouro/Avenida (sem número)';
COMMENT ON COLUMN addresses.address_number IS 'Número do endereço. Se não existir, informar NULL';
COMMENT ON COLUMN addresses.address_complement IS 'Complemento de endereço. Exemplo (Bloco A, Apto 123)';
COMMENT ON COLUMN addresses.address_set_id IS 'Referência do conjunto de endereços (FK com a tabela "address_sets")';