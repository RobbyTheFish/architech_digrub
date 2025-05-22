-- Клиенты
CREATE TABLE clients (
    client_id UUID PRIMARY KEY,
    type VARCHAR(10) CHECK (type IN ('individual', 'legal')),
    full_name TEXT,
    company_name TEXT,
    created_at TIMESTAMP DEFAULT now()
);

-- Цифровой кошелёк
CREATE TABLE digital_wallets (
    wallet_id UUID PRIMARY KEY,
    client_id UUID REFERENCES clients(client_id),
    balance NUMERIC(20, 2) NOT NULL DEFAULT 0,
    status VARCHAR(20) CHECK (status IN ('active', 'blocked')),
    created_at TIMESTAMP DEFAULT now()
);

-- Банковский счёт
CREATE TABLE bank_accounts (
    account_id UUID PRIMARY KEY,
    client_id UUID REFERENCES clients(client_id),
    account_number TEXT UNIQUE,
    balance NUMERIC(20, 2),
    bank_name TEXT,
    created_at TIMESTAMP DEFAULT now()
);

-- Карта
CREATE TABLE cards (
    card_id UUID PRIMARY KEY,
    client_id UUID REFERENCES clients(client_id),
    card_number TEXT UNIQUE,
    expiration_date DATE,
    linked_account UUID REFERENCES bank_accounts(account_id),
    created_at TIMESTAMP DEFAULT now()
);

/*******************************************************************
 *  ПОРУЧЕНИЯ КЛИЕНТА (PaymentInstruction)
 *******************************************************************/
CREATE TABLE payment_instructions (
    instruction_id     UUID PRIMARY KEY,
    client_id          UUID NOT NULL REFERENCES clients(client_id),
    instruction_type   VARCHAR(20)                  -- 'payment' | 'transfer'
                      CHECK (instruction_type IN ('payment','transfer')),
    amount             NUMERIC(20,2)  NOT NULL,
    currency           CHAR(3)        NOT NULL DEFAULT 'RUB',
    source_wallet      UUID           NOT NULL REFERENCES digital_wallets(wallet_id),
    destination_wallet UUID               REFERENCES digital_wallets(wallet_id),
    destination_account UUID              REFERENCES bank_accounts(account_id),
    destination_card   UUID               REFERENCES cards(card_id),
    description        TEXT,
    status             VARCHAR(20)      -- 'pending' | 'processing' | 'completed' | 'failed' | 'cancelled'
                      CHECK (status IN ('pending','processing','completed','failed','cancelled'))
                      DEFAULT 'pending',
    scheduled_at       TIMESTAMP,       -- для разовых/отложенных поручений
    created_at         TIMESTAMP        NOT NULL DEFAULT now()
);

CREATE INDEX idx_payment_instr_client_status
        ON payment_instructions (client_id, status);
CREATE INDEX idx_payment_instr_scheduled
        ON payment_instructions (scheduled_at);

/*******************************************************************
 *  ТРАНЗАКЦИИ (Transaction)
 *******************************************************************/
CREATE TABLE transactions (
    transaction_id   UUID PRIMARY KEY,
    instruction_id   UUID        NOT NULL REFERENCES payment_instructions(instruction_id),
    tx_type          VARCHAR(20)              -- 'debit' | 'credit' | 'reversal'
                   CHECK (tx_type IN ('debit','credit','reversal')),
    amount           NUMERIC(20,2) NOT NULL,
    currency         CHAR(3)       NOT NULL DEFAULT 'RUB',
    wallet_id        UUID              REFERENCES digital_wallets(wallet_id),
    account_id       UUID              REFERENCES bank_accounts(account_id),
    balance_before   NUMERIC(20,2),
    balance_after    NUMERIC(20,2),
    result_code      VARCHAR(10),           -- код ответа платформы ЦБ
    processed_at     TIMESTAMP    NOT NULL DEFAULT now()
);

CREATE INDEX idx_tx_wallet_time  ON transactions (wallet_id, processed_at DESC);
CREATE INDEX idx_tx_instr        ON transactions (instruction_id);

/*******************************************************************
 *  РАСПИСАНИЯ АВТО-ПЕРЕВОДОВ (TransferSchedule)
 *******************************************************************/
CREATE TABLE transfer_schedules (
    schedule_id        UUID PRIMARY KEY,
    client_id          UUID NOT NULL REFERENCES clients(client_id),
    source_wallet      UUID NOT NULL REFERENCES digital_wallets(wallet_id),
    destination_wallet UUID     REFERENCES digital_wallets(wallet_id),
    destination_account UUID    REFERENCES bank_accounts(account_id),
    amount             NUMERIC(20,2) NOT NULL,
    cron_expression    VARCHAR(120)  NOT NULL,   -- unix-cron формата
    next_run           TIMESTAMP     NOT NULL,
    status             VARCHAR(20)                -- 'active' | 'paused' | 'cancelled'
                     CHECK (status IN ('active','paused','cancelled'))
                     DEFAULT 'active',
    created_at         TIMESTAMP      NOT NULL DEFAULT now()
);

CREATE INDEX idx_schedule_next_run ON transfer_schedules (status, next_run);

/*******************************************************************
 *  AML / ПОД/ФТ ПРОВЕРКИ (AMLCheck)
 *******************************************************************/
CREATE TABLE aml_checks (
    check_id       UUID PRIMARY KEY,
    instruction_id UUID    NOT NULL REFERENCES payment_instructions(instruction_id),
    risk_score     NUMERIC(5,2),       -- 0 – 100
    result         VARCHAR(20)         -- 'pass' | 'review' | 'block'
                  CHECK (result IN ('pass','review','block')),
    details        JSONB,              -- структура отчёта / найденных списков
    checked_at     TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_aml_instr ON aml_checks (instruction_id);

/*******************************************************************
 *  ЖУРНАЛ ОПЕРАЦИЙ (OperationLog) — универсальный аудиторский лог
 *******************************************************************/
CREATE TABLE operation_logs (
    log_id       BIGSERIAL PRIMARY KEY,
    entity_type  VARCHAR(30),          -- 'client' | 'wallet' | 'instruction' | ...
    entity_id    UUID,
    action       VARCHAR(30),          -- 'create' | 'update' | 'status_change' | ...
    details      JSONB,
    created_at   TIMESTAMP NOT NULL DEFAULT now()
);

CREATE INDEX idx_oplog_entity ON operation_logs (entity_type, entity_id);
