CREATE TABLE organizations
(
	organization_id 	SERIAL NOT NULL,
	cnpj				VARCHAR(14),
	name				TEXT NOT NULL,
	state_id			INT,
	city_id				INT,
	city_name			TEXT,
	cep					VARCHAR(8),
	district			TEXT,
	address				TEXT,
	address_number		INT,
	address_complement	TEXT,
	coordinates			point,
    address_set_id      UUID,
    main_contact_name   TEXT,
    main_contact_phone  TEXT,
    main_contact_email  TEXT,
    alt_contact_name    TEXT,
    alt_contact_phone   TEXT,
    alt_contact_email   TEXT,
    notes               TEXT,
    status              CHAR(1) NOT NULL DEFAULT 'C',
	created_at			TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at          TIMESTAMPTZ,
	CONSTRAINT pk_organizations_id PRIMARY KEY (organization_id),
	CONSTRAINT uk_organizations_cnpj UNIQUE (cnpj),
	CONSTRAINT fk_organizations_cityid FOREIGN KEY (city_id) REFERENCES cities (city_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_organizations_addrsetid FOREIGN KEY (address_set_id) 
        REFERENCES address_sets (address_set_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE organizations IS 'Cadastro de organizações/empresas';
COMMENT ON COLUMN organizations.cnpj IS 'CNPJ da organização';
COMMENT ON COLUMN organizations.name IS 'Nome da organização';
COMMENT ON COLUMN organizations.state_id IS '[Obsoleto] Referência do estado/UF (FK com a tabela "states"). Este campo só é preenchido pela tela de doações do Callcenter';
COMMENT ON COLUMN organizations.city_id IS '[Obsoleto] Referência da cidade (FK com a tabela "cities"). Este campo só é preenchido pela tela de doações do Callcenter';
COMMENT ON COLUMN organizations.city_name IS '[Obsoleto] Campo para preenchimento livre do nome da cidade, nos casos onde a cidade não esteja cadastrada. Este campo só é preenchido pela tela de doações do Callcenter';
COMMENT ON COLUMN organizations.cep IS '[Obsoleto] Código de Endereço Postal. Este campo só é preenchido pela tela de doações do Callcenter';
COMMENT ON COLUMN organizations.district IS '[Obsoleto] Nome do bairro. Este campo só é preenchido pela tela de doações do Callcenter';
COMMENT ON COLUMN organizations.address IS '[Obsoleto] Descrição da Rua/Logradouro/Avenida (sem número). Este campo só é preenchido pela tela de doações do Callcenter';
COMMENT ON COLUMN organizations.address_number IS '[Obsoleto] Número do endereço. Se não existir, informar NULL. Este campo só é preenchido pela tela de doações do Callcenter';
COMMENT ON COLUMN organizations.address_complement IS '[Obsoleto] Complemento de endereço. Exemplo (Bloco A, Apto 123). Este campo só é preenchido pela tela de doações do Callcenter';
COMMENT ON COLUMN organizations.coordinates IS '[Obsoleto] Coordenadas do endereço';
COMMENT ON COLUMN organizations.address_set_id IS 'Referência do conjunto de endereços (FK com a tabela "address_sets")';
COMMENT ON COLUMN organizations.main_contact_name IS 'Nome do contato principal';
COMMENT ON COLUMN organizations.main_contact_phone IS 'Telefone do contato principal';
COMMENT ON COLUMN organizations.main_contact_email IS 'E-mail do contato principal';
COMMENT ON COLUMN organizations.alt_contact_name IS 'Nome do contato alternativo';
COMMENT ON COLUMN organizations.alt_contact_phone IS 'Telefone do contato alternativo';
COMMENT ON COLUMN organizations.alt_contact_email IS 'E-mail do contato alternativo';
COMMENT ON COLUMN organizations.notes IS 'Observações gerais sobre a organização';
COMMENT ON COLUMN organizations.status IS 'Situação do cadastro: T-temporario, C-Criado';
COMMENT ON COLUMN organizations.created_at IS 'Data e hora do registro da organização';
COMMENT ON COLUMN organizations.updated_at IS 'Data e hora de alteração da organização';