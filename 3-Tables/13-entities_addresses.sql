CREATE TABLE entities_addresses
(
    entity_id           UUID NOT NULL,
    address_id          UUID NOT NULL,
    CONSTRAINT pk_entitiesaddress_enityid_addressid PRIMARY KEY (entity_id, address_id),
    CONSTRAINT fk_entitiesaddress_enityid FOREIGN KEY (entity_id) REFERENCES entities (entity_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_entitiesaddress_addressid FOREIGN KEY (address_id) REFERENCES addresses (address_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE entities_addresses IS '[Obsoleto: Essa tabela foi descontinuada, e no lugar dela, passamos a utilizar "address_sets"] Conjunto de endereços da entidade.';