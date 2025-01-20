CREATE TABLE faq_categories
(
	faq_category_id		SERIAL NOT NULL,
	name				TEXT,
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT pk_faq_categories_id PRIMARY KEY (faq_category_id)
);
COMMENT ON TABLE faq_categories IS 'Categorias de FAQ (perguntas frequentes)';
COMMENT ON COLUMN faq_categories.faq_category_id IS 'Identificador da categoria';
COMMENT ON COLUMN faq_categories.name IS 'Nome da categoria';
COMMENT ON COLUMN faq_categories.created_at IS 'Data e hora em que o registro foi criado';

-- Insere categoria de FAQ
INSERT INTO faq_categories (name) VALUES ('Doações'); 