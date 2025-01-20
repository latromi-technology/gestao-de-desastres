CREATE TABLE categories
(
	category_id 		SERIAL 	NOT NULL,
	name				TEXT,
	CONSTRAINT pk_categories_id PRIMARY KEY (category_id)
);
COMMENT ON TABLE categories IS 'Categorias de produtos';
COMMENT ON COLUMN categories.category_id IS 'Identificador da categoria';
COMMENT ON COLUMN categories.name IS 'Nome da categoria';