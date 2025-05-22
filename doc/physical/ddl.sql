-- Схема хранения данных цифрового рубля (PostgreSQL)
CREATE SCHEMA IF NOT EXISTS cbdc;

-- Клиенты
CREATE TABLE cbdc.client (
    client_id UUID PRIMARY KEY,
    type VARCHAR(10) CHECK (type IN ('PERSON', 'ORG')) NOT NULL,
    kyc_status VARCHAR(15) CHECK (kyc_status IN ('VERIFIED', 'UNVERIFIED')) NOT NULL,
    is_blocked BOOLEAN DEFAULT FALSE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Банковские счета
CREATE TABLE cbdc.bank_account (
    account_id UUID PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES cbdc.client(client_id) ON DELETE RESTRICT,
    account_number VARCHAR(20) UNIQUE NOT NULL,
    balance DECIMAL(20,2) NOT NULL DEFAULT 0,
    status VARCHAR(10) CHECK (status IN ('ACTIVE', 'CLOSED')) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
CREATE INDEX idx_bank_account_client_id ON cbdc.bank_account(client_id);

-- Цифровые кошельки
CREATE TABLE cbdc.digital_wallet (
    wallet_id UUID PRIMARY KEY,
    client_id UUID UNIQUE NOT NULL REFERENCES cbdc.client(client_id) ON DELETE RESTRICT,
    balance DECIMAL(20,2) NOT NULL DEFAULT 0,
    offline_limit DECIMAL(20,2) NOT NULL DEFAULT 0,
    status VARCHAR(10) CHECK (status IN ('ACTIVE', 'FROZEN')) NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Инструкции
CREATE TABLE cbdc.instruction (
    instruction_id UUID PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES cbdc.client(client_id) ON DELETE RESTRICT,
    type VARCHAR(15) CHECK (type IN ('DEPOSIT', 'WITHDRAW', 'TRANSFER')) NOT NULL,
    amount DECIMAL(20,2) NOT NULL CHECK(amount > 0),
    status VARCHAR(15) CHECK (status IN ('NEW', 'SENT', 'CONFIRMED', 'ERROR')) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
CREATE INDEX idx_instruction_client_id ON cbdc.instruction(client_id);

-- Транзакции цифрового рубля (ЦБ)
CREATE TABLE cbdc.cbdc_transaction (
    tx_id UUID PRIMARY KEY,
    instruction_id UUID NOT NULL REFERENCES cbdc.instruction(instruction_id) ON DELETE RESTRICT,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    type VARCHAR(10) CHECK (type IN ('MINT', 'BURN', 'TRANSFER')) NOT NULL,
    amount DECIMAL(20,2) NOT NULL CHECK(amount > 0),
    from_wallet_id UUID REFERENCES cbdc.digital_wallet(wallet_id),
    to_wallet_id UUID REFERENCES cbdc.digital_wallet(wallet_id),
    status VARCHAR(10) CHECK (status IN ('PENDING', 'SUCCESS', 'FAILED')) NOT NULL
);
CREATE INDEX idx_tx_instruction_id ON cbdc.cbdc_transaction(instruction_id);
CREATE INDEX idx_tx_wallets ON cbdc.cbdc_transaction(from_wallet_id, to_wallet_id);

-- Автоплатежи
CREATE TABLE cbdc.auto_payment (
    auto_payment_id UUID PRIMARY KEY,
    client_id UUID NOT NULL REFERENCES cbdc.client(client_id) ON DELETE RESTRICT,
    target_wallet_id UUID NOT NULL REFERENCES cbdc.digital_wallet(wallet_id),
    amount DECIMAL(20,2) NOT NULL CHECK(amount > 0),
    schedule VARCHAR(10) CHECK (schedule IN ('ONCE', 'DAILY', 'MONTHLY')) NOT NULL,
    next_payment TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
CREATE INDEX idx_auto_payment_client_id ON cbdc.auto_payment(client_id);
