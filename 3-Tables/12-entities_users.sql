CREATE TABLE entities_users
(
	entity_id			UUID NOT NULL,
	user_id				UUID NOT NULL,
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_entitiesusers_entityid PRIMARY KEY (entity_id, user_id),
	CONSTRAINT fk_entitiesusers_entityid FOREIGN KEY (entity_id) REFERENCES entities(entity_id) ON UPDATE CASCADE ON DELETE CASCADE,
	CONSTRAINT fk_entitiesusers_userid FOREIGN KEY (user_id) REFERENCES users(user_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT uk_entitiesusers_userid UNIQUE (user_id)
);
COMMENT ON TABLE entities_users IS 'Usuários que fazem parte de uma entidade';
COMMENT ON COLUMN entities_users.entity_id IS 'Identificador da entidade';
COMMENT ON COLUMN entities_users.user_id IS 'Identificador do usuário';
COMMENT ON COLUMN entities_users.created_at IS 'Data e hora de criação do registro';