CREATE TABLE users
(
	user_id				UUID NOT NULL DEFAULT gen_random_uuid(),
	username			TEXT NOT NULL,
	password			TEXT,
	person_id			INT,
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at			TIMESTAMPTZ,
	CONSTRAINT pk_users_id PRIMARY KEY (user_id),
	CONSTRAINT fk_users_person_id FOREIGN KEY (person_id) REFERENCES persons(person_id)  ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT uk_users_username UNIQUE (username)
);
COMMENT ON TABLE users IS 'Cadastros dos usuários';
COMMENT ON COLUMN users.user_id IS 'Identificador do usuário';
COMMENT ON COLUMN users.username IS 'Nome de usuário';
COMMENT ON COLUMN users.password IS 'Senha do usuário';
COMMENT ON COLUMN users.person_id IS 'Identificador da pessoa associada ao usuário';
COMMENT ON COLUMN users.created_at IS 'Data e hora em que o registro foi criado';