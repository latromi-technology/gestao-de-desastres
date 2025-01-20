CREATE TABLE binaries
(
    binary_id       UUID NOT NULL DEFAULT gen_random_uuid(),
    binary_hash     VARCHAR(64) NOT NULL,
    size            INT NOT NULL DEFAULT 0,
    mime_type       TEXT,
    content         BYTEA,
    CONSTRAINT pk_binaries_id PRIMARY KEY (binary_id),
    CONSTRAINT fk_binaries_hash UNIQUE (binary_hash)
);
COMMENT ON TABLE binaries IS 'Tabela onde são armazenados os arquivos binários (blobs), como fotos por exemplo.';
COMMENT ON COLUMN binaries.binary_id IS 'Identificador do binário (UUID)';
COMMENT ON COLUMN binaries.binary_hash IS 'HASH SHA256 do binário';
COMMENT ON COLUMN binaries.size IS 'Tamanho do binário em bytes';
COMMENT ON COLUMN binaries.content IS 'Conteúdo do binário (array de bytes)';