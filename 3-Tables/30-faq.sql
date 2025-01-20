CREATE TABLE faq
(
	faq_id				SERIAL NOT NULL,
	question_text		TEXT,
	answer_text			TEXT,
	faq_category_id		INT NOT NULL,
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	created_by			TEXT,
	updated_at			TIMESTAMPTZ,
	updated_by			TEXT,
	reported_at			TIMESTAMPTZ,
	reported_by			TEXT,
	reported_text		TEXT,
	CONSTRAINT pk_faq_id PRIMARY KEY (faq_id)
);
COMMENT ON TABLE faq IS 'FAQ (perguntas frequentes). Este recurso é usado pelos operadores do Callcenter para tirar dúvidas durante as ligações';
COMMENT ON COLUMN faq.faq_id IS 'Identificador da pergunta';
COMMENT ON COLUMN faq.question_text IS 'Texto da pergunta';
COMMENT ON COLUMN faq.answer_text IS 'Texto da resposta (aceita HTML)';
COMMENT ON COLUMN faq.faq_category_id IS 'Identificador da categoria de FAQ';
COMMENT ON COLUMN faq.created_at IS 'Data e hora em que o registro foi criado';
COMMENT ON COLUMN faq.created_by IS 'Nome de usuário de quem inseriu o registro';
COMMENT ON COLUMN faq.updated_at IS 'Data e hora em que o registro foi alterado pela última vez';
COMMENT ON COLUMN faq.updated_by IS 'Nome de usuário de quem atualizou o registro pela última vez';
COMMENT ON COLUMN faq.reported_at IS 'Data e hora da última vez que um usuário reportou um erro no FAQ';
COMMENT ON COLUMN faq.reported_by IS 'Nome de usuário de quem reportou um erro no FAQ pela última vez';
COMMENT ON COLUMN faq.reported_text IS 'Texto fornecido pelo usuário que reportou um erro no FAQ pela última vez';