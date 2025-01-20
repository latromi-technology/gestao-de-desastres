-- Sequencia usada no número da oferta
CREATE SEQUENCE offers_number_seq OWNED BY offers.offer_number;
COMMENT ON SEQUENCE offers_number_seq IS ' Sequencia usada no número da oferta';

-- Sequencia usado no número da demanda
CREATE SEQUENCE requests_number_seq OWNED BY requests.request_number;
COMMENT ON SEQUENCE requests_number_seq IS 'Sequencia usado no número da demanda';

-- Sequencia usada para a geração de protocolos
CREATE SEQUENCE protocol_seq MAXVALUE 9999 CYCLE;
COMMENT ON SEQUENCE protocol_seq IS 'Sequence usada na composição do número do protocolo';