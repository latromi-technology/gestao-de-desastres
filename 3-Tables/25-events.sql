CREATE TABLE events
(	
	event_id	SERIAL NOT NULL,
	name		TEXT,
	code		VARCHAR(2),
	created_at  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at	TIMESTAMPTZ,
	CONSTRAINT pk_events_id PRIMARY KEY (event_id),
	CONSTRAINT uk_events_code UNIQUE (code)
);
COMMENT ON TABLE events IS 'Eventos';
COMMENT ON COLUMN events.event_id IS 'Identificador do evento';
COMMENT ON COLUMN events.name IS 'Nome do evento';
COMMENT ON COLUMN events.code IS 'Código fornecido para o evento';
COMMENT ON COLUMN events.created_at IS 'Data e hora em que o registro foi criado';
COMMENT ON COLUMN events.updated_at IS 'Data e hora em que o registro foi atualizado pela última vez';