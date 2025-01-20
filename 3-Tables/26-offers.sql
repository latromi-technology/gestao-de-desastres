CREATE TABLE offers
(
    offer_id             	UUID NOT NULL DEFAULT gen_random_uuid(),
    offer_number        	INT,
    entity_id           	UUID,
    protocol            	VARCHAR(20) NOT NULL,
    created_at            	TIMESTAMPTZ,
    created_on            	INTERVAL,
    doc_type             	VARCHAR(5) NOT NULL,
    organization_id        	INT,
    person_id            	INT,
    giver_name            	TEXT,
    availability_date    	DATE,
    pickup_date            	DATE,
    delivery_date         	DATE,
    state_id            	INT,
    city_id                	INT,
    city_name            	TEXT,
    cep                    	VARCHAR(8),
    district            	TEXT,
    address                	TEXT,
    address_number        	INT,
    address_complement    	TEXT,    
    coordinates            	point,
    operator_username    	TEXT,
    operator_notes        	TEXT,
    contact_name        	TEXT,
    contact_phone        	TEXT,
    contact_email        	TEXT,
    transport_type        	INT,
    shipping_available      BOOLEAN,
    shipping_modal          SMALLINT,
    shipping_truck_type     SMALLINT,
    shipping_truck_type_id  INT,
    updated_at              TIMESTAMPTZ,
    updated_by              TEXT,
    canceled_at             TIMESTAMPTZ,
    canceled_by             TEXT,
    status                  CHAR(1) NOT NULL DEFAULT 'T',
    target_hub_id           INT,
    current_event_id        INT,
    estimated_weight_kg     DECIMAL(10,2),
    callcenter              BOOLEAN NOT NULL DEFAULT FALSE,
    vehicle_plate           VARCHAR(20),
    driver_phone            TEXT,
    driver_name             TEXT,
    expected_truck_inbound_date TIMESTAMP,
    CONSTRAINT pk_offers_id PRIMARY KEY (offer_id),
    CONSTRAINT uk_offers_protocol UNIQUE (protocol),
    CONSTRAINT fk_offers_organizationid FOREIGN KEY (organization_id) REFERENCES organizations(organization_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_offers_personid FOREIGN KEY (person_id) REFERENCES persons(person_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_offers_cities FOREIGN KEY (city_id) REFERENCES cities(city_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_offers_stateid FOREIGN KEY (state_id) REFERENCES states(state_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_offers_targethubid FOREIGN KEY (target_hub_id) REFERENCES hubs (hub_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_offers_trucktypeid FOREIGN KEY (shipping_truck_type_id) REFERENCES truck_types(truck_type_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT fk_offers_entityid FOREIGN KEY (entity_id)
        REFERENCES entities (entity_id) 
        ON DELETE RESTRICT ON UPDATE CASCADE
);
-- Sequencia usada no número da oferta
COMMENT ON TABLE offers IS 'Registro de ofertas (doações)';
COMMENT ON COLUMN offers.offer_id IS 'Identificador da oferta';
COMMENT ON COLUMN offers.offer_number IS 'Número da oferta. É um identificador alternativo para a doação, de fácil leitura humana. O número é gerado através da SEQUENCE "offers_number_seq".';
COMMENT ON COLUMN offers.entity_id IS 'Identificador da entidade que está registrando a oferta';
COMMENT ON COLUMN offers.protocol IS 'Número do protocolo da oferta. O protocolo é um identificar único gerado após o registro da oferta, e compartilhado com o doador.';
COMMENT ON COLUMN offers.created_at IS 'Data e Hora de criação do registro. Precisa ser "NULLABLE" por uma estratégia usada na tela de atendimento da doação.';
COMMENT ON COLUMN offers.created_on IS 'Tempo gasto pelo operador para registrar a doação';
COMMENT ON COLUMN offers.doc_type IS 'Tipo de documento ("CNPJ" ou "CPF")';
COMMENT ON COLUMN offers.organization_id IS 'Identificação da organização que está realizando a doação (somente no caso de empresas/CNPJ).';
COMMENT ON COLUMN offers.person_id IS 'Identificador da pessoa que está realizando a doação (somente no caso de pessoas/CPF)';
COMMENT ON COLUMN offers.giver_name IS 'Nome do doador';
COMMENT ON COLUMN offers.availability_date IS 'Data em que os donativos estão disponíveis';
COMMENT ON COLUMN offers.pickup_date IS 'Data de previsão em que os donativos serão coletados';
COMMENT ON COLUMN offers.delivery_date IS 'Data de previsão em que os donativos serão entregues';
COMMENT ON COLUMN offers.state_id IS 'Identificador do estado de origem da doação.';
COMMENT ON COLUMN offers.city_id IS 'Identificador da cidade de origem da doação';
COMMENT ON COLUMN offers.city_name IS 'Nome da cidade de origem da doação (em alguns casos, "CITY_ID" pode ser NULL, e o nome da cidade é preenchido pelo operador.';
COMMENT ON COLUMN offers.cep IS 'Código postal de origem da doação';
COMMENT ON COLUMN offers.district IS 'Bairro de origem da doação';
COMMENT ON COLUMN offers.address IS 'Nome da rua/avenidade de origem da doação';
COMMENT ON COLUMN offers.address_number IS 'Número do endereço de origem da doação';
COMMENT ON COLUMN offers.address_complement IS 'Complemento de endereço da origem da doação';
COMMENT ON COLUMN offers.coordinates IS 'Coordenadas (latitude, longitude) da origem da doação';
COMMENT ON COLUMN offers.operator_username IS 'Nome de usuário do operador que registrou a doação';
COMMENT ON COLUMN offers.operator_notes IS 'Observações do operador que registrou a doação';
COMMENT ON COLUMN offers.contact_name IS 'Nome de contato do doador';
COMMENT ON COLUMN offers.contact_phone IS 'Telefone de contato do doador';
COMMENT ON COLUMN offers.contact_email IS 'E-mail de contato do doador';
COMMENT ON COLUMN offers.transport_type IS '[Obsoleto: Nunca foi usado] Tipo de transporte';
COMMENT ON COLUMN offers.shipping_available IS 'Se true, siginifica que o doador possui transporte proprio disponível';
COMMENT ON COLUMN offers.shipping_modal IS 'Modal de Transporte: 1-Terrestre, 2-Areo, 3-Maritimo';
COMMENT ON COLUMN offers.shipping_truck_type IS '[Obsoleto: Foi substituído por "shipping_truck_type_id"] Tipo de Caminhão:
1-Caminhão Toco
2-Caminhão Truck
3-Carreta
4-Rodotrem';
COMMENT ON COLUMN offers.shipping_truck_type_id IS 'Identificador do tipo de veículo';
COMMENT ON COLUMN offers.updated_at IS 'Data e hora da última vez em que o registro foi atualizado';
COMMENT ON COLUMN offers.updated_by IS 'Nome de usuário de quem atualizou o registro pela última vez';
COMMENT ON COLUMN offers.canceled_at IS 'Data e hora em que a oferta foi cancelada pelo doador';
COMMENT ON COLUMN offers.canceled_by IS 'Nome de usuário de quem registrou o cancelamento da oferta';
COMMENT ON COLUMN offers.status IS 'Situação: T-Temporário, C-Created, X-Canceleado';
COMMENT ON COLUMN offers.target_hub_id IS 'Identificador da base logística (Hub) para onde os donativos serão enviados';
COMMENT ON COLUMN offers.current_event_id IS 'Identificador do último evento ocorrido na oferta';
COMMENT ON COLUMN offers.estimated_weight_kg IS 'Total estimado em KG, quando o doador não souber informar os pesos dos donativos';
COMMENT ON COLUMN offers.callcenter IS 'Se true, significa que a oferta foi regitrada por um operador de callcenter';
COMMENT ON COLUMN offers.vehicle_plate IS 'Placa do veículo que vai transportar os donativos';
COMMENT ON COLUMN offers.driver_name IS 'Nome do motorista que vai transportar os donativos';
COMMENT ON COLUMN offers.driver_phone IS 'Número de telefone do motortista que vai transportar os donativos';
COMMENT ON COLUMN offers.expected_truck_inbound_date IS 'Data estimada de chegada do veículo na base logística';

-- Indices para acelarar as pequisas por número de protocolo e data de registro da doação.
CREATE INDEX ix_offers_protocol ON  offers (protocol);
CREATE INDEX ix_offers_createdat ON  offers (created_at);

