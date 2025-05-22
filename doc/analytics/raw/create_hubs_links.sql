-- Hubs
CREATE TABLE dv.hub_client (
  client_hk UUID PRIMARY KEY,
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.hub_digital_wallet (
  wallet_hk UUID PRIMARY KEY,
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.hub_bank_account (
  account_hk UUID PRIMARY KEY,
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.hub_instruction (
  instruction_hk UUID PRIMARY KEY,
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.hub_cbdc_transaction (
  tx_hk UUID PRIMARY KEY,
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

-- Links
CREATE TABLE dv.link_client_wallet (
  link_hk UUID PRIMARY KEY,
  client_hk UUID REFERENCES dv.hub_client(client_hk),
  wallet_hk UUID REFERENCES dv.hub_digital_wallet(wallet_hk),
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.link_client_bank_account (
  link_hk UUID PRIMARY KEY,
  client_hk UUID REFERENCES dv.hub_client(client_hk),
  account_hk UUID REFERENCES dv.hub_bank_account(account_hk),
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.link_instruction_transaction (
  link_hk UUID PRIMARY KEY,
  instruction_hk UUID REFERENCES dv.hub_instruction(instruction_hk),
  tx_hk UUID REFERENCES dv.hub_cbdc_transaction(tx_hk),
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);
