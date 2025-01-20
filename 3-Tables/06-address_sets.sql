CREATE TABLE address_sets
(
    address_set_id      UUID NOT NULL DEFAULT gen_random_uuid(),
    name                TEXT,
    main_address_id     UUID,
    created_at          TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT pk_addresssets_id PRIMARY KEY (address_set_id)
);
COMMENT ON TABLE address_sets IS 'Conjunto de endereços. Por exemplo, uma pessoa pode ter mais de um endereço cadastrado (Casa, Escritório). Os endereços são agrupados no conjunto de endereços e o ID do conjunto é assoaciado ao cadastro da pessoa';
COMMENT ON COLUMN address_sets.address_set_id IS 'Identificador do conjunto de endereços (UUID)';
COMMENT ON COLUMN address_sets.name IS 'Nome do conjunto de endereços.';
COMMENT ON COLUMN address_sets.main_address_id IS 'Referência do endereço principal, dentre os endereços que fazem parte do conjunto.';
COMMENT ON COLUMN address_sets.created_at IS 'Data e hora de criação do conjunto de endereços.';