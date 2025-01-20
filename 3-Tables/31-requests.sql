CREATE TABLE requests
(
    request_id              UUID NOT NULL DEFAULT gen_random_uuid(),
    request_number          INT,
    protocol                VARCHAR(20) NOT NULL,
    subject                 TEXT,
    entity_id               UUID,
    requester_name          TEXT,  
    request_date            DATE NOT NULL DEFAULT CURRENT_DATE,
    created_at              TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by              TEXT,
    updated_at              TIMESTAMPTZ,
    updated_by              TEXT,
    canceled_at             TIMESTAMPTZ,
    canceled_by             TEXT,
    canceled_reason         TEXT,
    delivery_address_id     UUID,
    delivery_method         CHAR(1) NOT NULL DEFAULT 'T',
    responsible_name        TEXT,
    responsible_phone       TEXT,
    pickup_date             TIMESTAMPTZ,
    closed_at               TIMESTAMPTZ,
    closed_by               TEXT,
    status                  CHAR(1) NOT NULL DEFAULT 'T',
    current_event_id        INT,
    approval_status         CHAR(1) DEFAULT 'O',
    notes                   TEXT,
    supply_progress         NUMERIC(4,1) NOT NULL DEFAULT 0,
    approval_level          INT,
    approval_at             TIMESTAMPTZ,
    CONSTRAINT pk_requests_id PRIMARY KEY (request_id),
    CONSTRAINT ck_requests_supplyprogress CHECK (supply_progress >= 0),
    CONSTRAINT fk_requests_entityid FOREIGN KEY (entity_id) REFERENCES entities(entity_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_requests_deliveryaddrid FOREIGN KEY (delivery_address_id) REFERENCES addresses (address_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);

COMMENT ON TABLE requests IS 'Registro de solicitações de materiais (demandas)';
COMMENT ON COLUMN requests.request_id IS 'Identificador da demanda';
COMMENT ON COLUMN requests.request_number IS 'Número sequência da demanda. Este é um Identificador alternativo de fácil leitura para uso interno.';
COMMENT ON COLUMN requests.protocol IS 'Número de protocolo do registro de demanda.';
COMMENT ON COLUMN requests.subject IS 'Assunto/título da demanda.';
COMMENT ON COLUMN requests.entity_id IS 'Identificador da entidade';
COMMENT ON COLUMN requests.requester_name IS 'Nome de quem solicitou';
COMMENT ON COLUMN requests.request_date IS 'Data da solicitação';
COMMENT ON COLUMN requests.created_at IS 'Data e hora de criação do registro';
COMMENT ON COLUMN requests.created_by IS 'Nome de usuário de quem critou o registro';
COMMENT ON COLUMN requests.updated_at IS 'Data e hora da última modificação do registro';
COMMENT ON COLUMN requests.updated_by IS 'Nome de usuário de quem fez a última modificação no registro';
COMMENT ON COLUMN requests.canceled_at IS 'Data e hora em que a demanda foi cancelada';
COMMENT ON COLUMN requests.canceled_by IS 'Nome de usuário de quem registrou o cancelamento da demanda';
COMMENT ON COLUMN requests.canceled_reason IS 'Motivo do cancelamento da demanda';
COMMENT ON COLUMN requests.delivery_address_id IS 'Identificador do endereço de entrega';
COMMENT ON COLUMN requests.delivery_method IS 'Método de entrega: D-Delivery, P-Pickup';
COMMENT ON COLUMN requests.responsible_name IS 'Nome do responsável por retirar ou receber a mercadoria';
COMMENT ON COLUMN requests.responsible_phone IS 'Telefone do responsável por retirar ou receber a mercadoria';
COMMENT ON COLUMN requests.pickup_date IS 'Data de retirada da mercadoria';
COMMENT ON COLUMN requests.closed_at IS 'Data e hora em que a demanda foi fechada (arquivada).';
COMMENT ON COLUMN requests.closed_by IS 'Nome de usuário de quem fechou (arquivou) a demanda';
COMMENT ON COLUMN requests.status IS 'Situação: 
T-Temporário
C-Created
A-Approving
E-Ended
X-Canceled
D-Delivered';
COMMENT ON COLUMN requests.current_event_id IS 'Identificador do evento atual associado a demanda';
COMMENT ON COLUMN requests.approval_status IS 'Situação da aprovação:
O-Open
T-Totally Approved
P-Partially Approved
R-Reproved';
COMMENT ON COLUMN requests.notes IS 'Observações da demanda';
COMMENT ON COLUMN requests.supply_progress IS 'Valor de 0 a 100 que indica o percentual de progresso do atendimento da demanda. O percentual é calculado automaticamente na operação de atendimento das demandas. ';
COMMENT ON COLUMN requests.approval_level IS 'Nível hierarquico da entidade que realizou a aprovação (total ou parcial). Quandou houver múltiplas aprovações, mantém sempre o nível mais elevado (menor número)';
COMMENT ON COLUMN requests.approval_at IS 'Data e hora em que a demanda foi aprovada (total ou parcial)';