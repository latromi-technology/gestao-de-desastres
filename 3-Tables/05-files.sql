CREATE TABLE files
(
    file_id         UUID NOT NULL DEFAULT gen_random_uuid(),
    file_name       TEXT,
    binary_id       UUID,
    mime_type       TEXT,
    external_url    TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMPTZ,
    CONSTRAINT pk_files_fileid PRIMARY KEY (file_id),
    CONSTRAINT fk_files_binaryid FOREIGN KEY (binary_id) 
        REFERENCES binaries (binary_id) ON UPDATE CASCADE ON DELETE RESTRICT
);
COMMENT ON TABLE files IS 'Armazena a referência aos arquivos. Quando a coluna "binary_hash" estiver preenchida, significa que o arquivo foi salvo no banco de dados. Neste caso, o conteúdo dele está gravado na tabela "storage.binaries".';
COMMENT ON COLUMN files.file_id IS 'Identificador do Arquivo (UUID)';
COMMENT ON COLUMN files.binary_id IS 'Referência do binário (FK com a tabela "binaries")';
COMMENT ON COLUMN files.mime_type IS 'Tipo de conteúdo do arquivo. Exemplo: "text/plain", "text/html", "image/jpeg"';
COMMENT ON COLUMN files.external_url IS 'URL externa do arquivo. Quando essa URL for informada, significa que o arquivo está armazenado em outro local que não seja o banco de dados.';
COMMENT ON COLUMN files.created_at IS 'Data e hora de criação do arquivo';
COMMENT ON COLUMN files.updated_at IS 'Data e hora de atualização do arquivo';