CREATE TABLE vehicle_entries_exits
(
    vehicle_entry_exit_id       SERIAL NOT NULL,
    entity_id                   UUID NOT NULL,
    queue_number                INT NOT NULL,
    driver_name                 TEXT,
    driver_phone                TEXT,
    carrier_id                  INT,
    carrier_others              TEXT,
    vehicle_plate               VARCHAR(30),
    vehicle_type_id             INT,
    palletized                  CHAR(1) NOT NULL DEFAULT 'N',
    load                        BOOLEAN NOT NULL DEFAULT FALSE,
    unload                      BOOLEAN NOT NULL DEFAULT FALSE,
    cargo_description           TEXT,
    estimated_weight_kg         NUMERIC(10,2),
    state_id                    INT,
    city_id                     INT,
    city_name                   TEXT,
    has_invoice                 BOOLEAN NOT NULL DEFAULT FALSE,
    offer_id                    UUID,
    request_id                  UUID,
    created_at                  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    created_by                  TEXT,
    authorized_at               TIMESTAMPTZ,
    authorized_by               TEXT,
    inbound_at                  TIMESTAMPTZ,    
    inbound_by                  TEXT,
    started_at                  TIMESTAMPTZ,
    started_by                  TEXT,
    outbound_at                 TIMESTAMPTZ,
    outbound_by                 TEXT,
    canceled_at                 TIMESTAMPTZ,
    canceled_by                 TEXT,
    canceled_reason             TEXT,
    status                      CHAR(1) NOT NULL DEFAULT 'T',
    CONSTRAINT pk_vehicleentriesexits_id PRIMARY KEY (vehicle_entry_exit_id),
    CONSTRAINT fk_vehicleentriesexits_stateid FOREIGN KEY (state_id)
        REFERENCES states(state_id)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehicleentriesexits_cityid FOREIGN KEY (city_id) 
        REFERENCES cities (city_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehicleentriesexits_entityid FOREIGN KEY  (entity_id)
        REFERENCES entities (entity_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehicleentriesexits_typeid FOREIGN KEY (vehicle_type_id) 
        REFERENCES truck_types (truck_type_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehicleentriesexits_offerid FOREIGN KEY (offer_id)
        REFERENCES offers (offer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehicleentriesexits_carrierid FOREIGN KEY (carrier_id)
        REFERENCES carriers (carrier_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_vehicleentriesexits_requestid FOREIGN KEY (request_id)
        REFERENCES requests(request_id) ON DELETE RESTRICT ON UPDATE CASCADE
);
COMMENT ON TABLE vehicle_entries_exits IS 'Registro de entradas e saídas de veículos (controle de portaria)';

COMMENT ON COLUMN vehicle_entries_exits.vehicle_entry_exit_id IS 'Identificador da entrada ou saída de veículo';
COMMENT ON COLUMN vehicle_entries_exits.entity_id IS 'Identificador da entidade para qual a entrada ou saída de veículo foi registrada';
COMMENT ON COLUMN vehicle_entries_exits.queue_number IS 'Número do veículo na fila para entrada';
COMMENT ON COLUMN vehicle_entries_exits.driver_name IS 'Nome do motorista';
COMMENT ON COLUMN vehicle_entries_exits.driver_phone IS 'Número de telefone do motorista';
COMMENT ON COLUMN vehicle_entries_exits.carrier_id IS 'Identificador da transportadora';
COMMENT ON COLUMN vehicle_entries_exits.carrier_others IS 'Nome da transportadora caso não esteja cadastrada';
COMMENT ON COLUMN vehicle_entries_exits.vehicle_plate IS 'Placa do veículo';
COMMENT ON COLUMN vehicle_entries_exits.vehicle_type_id IS 'Identificador do tipo de veículo';
COMMENT ON COLUMN vehicle_entries_exits.palletized IS 'Paletizado: Y-Sim, N-Não, P-Parcial';
COMMENT ON COLUMN vehicle_entries_exits.load IS 'Se true, significa que o veículo vai fazer um carregamento';
COMMENT ON COLUMN vehicle_entries_exits.unload IS 'Se true, significa que o veículo vai descarregar';
COMMENT ON COLUMN vehicle_entries_exits.cargo_description IS 'Descrição da carga transportada';
COMMENT ON COLUMN vehicle_entries_exits.estimated_weight_kg IS 'Peso estimado da carga em KG';
COMMENT ON COLUMN vehicle_entries_exits.state_id IS 'Identificador do estado (UF)';
COMMENT ON COLUMN vehicle_entries_exits.city_id IS 'Identificador da cidade';
COMMENT ON COLUMN vehicle_entries_exits.city_name IS 'Nome da cidade, usado quando a cidade não estiver cadastrada';
COMMENT ON COLUMN vehicle_entries_exits.has_invoice IS 'Se true, indica que o motorista possui nota fiscal da mercadoria. Essa informação é útil para o planejamento da descarga pois é mais fácil registrar a partir de nota fiscal.';
COMMENT ON COLUMN vehicle_entries_exits.offer_id IS 'Identificador da oferta (doação). Se o motorista veio descarregar e tem o protocolo da doação, é possível associar a entrega com o registro da oferta.';
COMMENT ON COLUMN vehicle_entries_exits.request_id IS 'Identificador da demanda. Se o motorista veio coletar e tem o protocolo da demanda, é possível associar a coleta com o registro da demanda.';
COMMENT ON COLUMN vehicle_entries_exits.created_at IS 'Data e hora de criação do registro';
COMMENT ON COLUMN vehicle_entries_exits.created_by IS 'Data e hora da última modificação do registro';
COMMENT ON COLUMN vehicle_entries_exits.authorized_at IS 'Data e hora em que a carga ou descargar foi autorizada';
COMMENT ON COLUMN vehicle_entries_exits.authorized_by IS 'Nome de usuário de quem autorizou a carga ou descarga';
COMMENT ON COLUMN vehicle_entries_exits.started_at IS 'Data e hora em que foi iniciado o carregamento ou descarregamento';
COMMENT ON COLUMN vehicle_entries_exits.started_by IS 'Nome de usuário de quem registrou o início do carregamento ou descarregamento';
COMMENT ON COLUMN vehicle_entries_exits.inbound_at IS 'Data e hora em que ocorreu o carregamento';
COMMENT ON COLUMN vehicle_entries_exits.inbound_by IS 'Nome de usuário de quem registrou o carregamento';
COMMENT ON COLUMN vehicle_entries_exits.outbound_at IS 'Data e hora em que ocorreu o descarregamento';
COMMENT ON COLUMN vehicle_entries_exits.outbound_by IS 'Nome de usuário de quem registrou o descarregamento';
COMMENT ON COLUMN vehicle_entries_exits.canceled_at IS 'Data e hora em que a operação foi cancelada';
COMMENT ON COLUMN vehicle_entries_exits.canceled_by IS 'Nome de usuário de quem registrou o cancelamento';
COMMENT ON COLUMN vehicle_entries_exits.canceled_reason IS 'Motivo do cancelamento';
COMMENT ON COLUMN vehicle_entries_exits.status IS 'Status: T-Temporary, C-Created, A-Authorized, I-Inbound, S-Started, O-Outbound, X-Canceled';