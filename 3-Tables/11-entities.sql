CREATE TABLE entities
(
	entity_id 			    UUID NOT NULL DEFAULT gen_random_uuid(),
	name				    TEXT,
	parent_entity_id	    UUID,
    level                   INT NOT NULL,
	organization_id		    INT,
    address_set_id          UUID,
	enabled				    BOOLEAN NOT NULL DEFAULT TRUE,
    callcenter              BOOLEAN NOT NULL DEFAULT FALSE,
    delivery_address_set_id UUID,
    default_user_group_name TEXT,
	created_at			    TIMESTAMPTZ,
	updated_at			    TIMESTAMPTZ,
	CONSTRAINT pk_entities_id PRIMARY KEY (entity_id),
	CONSTRAINT fk_entities_organizationid FOREIGN KEY (organization_id) 
        REFERENCES organizations (organization_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT fk_entities_parententityid FOREIGN KEY (parent_entity_id) 
        REFERENCES entities (entity_id) 
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_entities_addrsetid FOREIGN KEY (address_set_id) 
        REFERENCES address_sets (address_set_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_entities_deliveryaddrsetid FOREIGN KEY (delivery_address_set_id) 
        REFERENCES address_sets (address_set_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE entities IS 'Cadastro de entidades. Uma entidade é uma organização lógica, não necessáriamente vinculada à um CNPJ. Exemplo: Regionais da Defesa Civil, ONG, abrigos, orgão governamentais.';

COMMENT ON COLUMN entities.entity_id IS 'Identificador da entidade'; 
COMMENT ON COLUMN entities.name IS 'Nome da entidade'; 
COMMENT ON COLUMN entities.parent_entity_id IS 'Identificador da entidade superior'; 
COMMENT ON COLUMN entities.level IS 'Nível hierarquico da entidade em relação aos níveis superiores, sendo 0 (zero) o mais elevado (ordem decrescente).'; 
COMMENT ON COLUMN entities.organization_id IS 'Identificador da organização vinculada à entidade.'; 
COMMENT ON COLUMN entities.address_set_id IS 'Identificador do conjunto de endereços'; 
COMMENT ON COLUMN entities.enabled IS 'Se true, indica que a entidade está habilitada.'; 
COMMENT ON COLUMN entities.callcenter IS 'Se true, indica que a entidade é um callcenter. Neste caso, existem alguns comportamentos diferenciados na rotina de registro de doações/ofertas.'; 
COMMENT ON COLUMN entities.delivery_address_set_id IS 'Identificador do conjunto de endereços de entrega.'; 
COMMENT ON COLUMN entities.default_user_group_name IS 'Nome do grupo de usuário padrão da entidade.'; 
COMMENT ON COLUMN entities.created_at IS 'Data e hora de criação do registro.'; 
COMMENT ON COLUMN entities.updated_at IS 'Data e hora da última vez que o registro foi atualizado.'; 
