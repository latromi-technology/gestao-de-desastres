CREATE TABLE requests_approvals
(
    request_approval_id     UUID NOT NULL DEFAULT gen_random_uuid(),
    request_id              UUID NOT NULL,
    request_product_id      UUID NOT NULL,
    quantity_approved       NUMERIC(10,2),
    approval_entity_id      UUID NOT NULL,         
    approval_at             TIMESTAMPTZ,
    approval_by             TEXT,
    CONSTRAINT pk_requestappr_approval_id PRIMARY KEY (request_approval_id),
    CONSTRAINT uk_requestappr_requestproductid_approvalentityid UNIQUE (request_product_id, approval_entity_id),
    CONSTRAINT fk_requestappr_requestid FOREIGN KEY (request_id)
        REFERENCES requests (request_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_requestappr_requestproductid FOREIGN KEY (request_product_id)
        REFERENCES requests_products (request_product_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_requestappr_approvalentityid FOREIGN KEY (approval_entity_id)
        REFERENCES entities (entity_id)
        ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE requests_approvals IS 'Registro de aprovações da demanda (histórico)';
COMMENT ON COLUMN requests_approvals.request_approval_id IS 'Identificador da aprovação';
COMMENT ON COLUMN requests_approvals.request_id IS 'Identificador da demanda';
COMMENT ON COLUMN requests_approvals.request_product_id IS 'Identificador do produto';
COMMENT ON COLUMN requests_approvals.quantity_approved IS 'Quantidade aprovada';
COMMENT ON COLUMN requests_approvals.approval_entity_id IS 'Identificador da entidade responsável pela aprovação';
COMMENT ON COLUMN requests_approvals.approval_at IS 'Data e hora da aprovação';
COMMENT ON COLUMN requests_approvals.approval_by IS 'Nome de usuário de quem aprovou';