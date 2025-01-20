CREATE TABLE countries 
(
    country_id		SERIAL NOT NULL,
    name            TEXT NOT NULL,
    alpha2          VARCHAR(2) NOT NULL,
    CONSTRAINT pk_country_id PRIMARY KEY (country_id),
    CONSTRAINT uk_country_alpha2 UNIQUE(alpha2)
);
COMMENT ON TABLE countries IS 'Cadastro de Países';
COMMENT ON COLUMN countries.country_id IS 'Identificador do país';
COMMENT ON COLUMN countries.name IS 'Nome do país';
COMMENT ON COLUMN countries.alpha2 IS 'Sigla de 2 caracteres do país';

-- Insere "Brasil"
INSERT INTO countries  (alpha2, name) VALUES ('BR', 'Brasil');