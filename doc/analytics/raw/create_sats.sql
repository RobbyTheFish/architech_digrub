-- Satellites (атрибуты сущностей)
CREATE TABLE dv.sat_client (
  client_hk UUID REFERENCES dv.hub_client(client_hk),
  type VARCHAR(10),
  kyc_status VARCHAR(15),
  is_blocked BOOLEAN,
  effective_from TIMESTAMP NOT NULL DEFAULT NOW(),
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.sat_wallet (
  wallet_hk UUID REFERENCES dv.hub_digital_wallet(wallet_hk),
  balance DECIMAL(20,2),
  offline_limit DECIMAL(20,2),
  status VARCHAR(10),
  effective_from TIMESTAMP NOT NULL DEFAULT NOW(),
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.sat_bank_account (
  account_hk UUID REFERENCES dv.hub_bank_account(account_hk),
  balance DECIMAL(20,2),
  status VARCHAR(10),
  effective_from TIMESTAMP NOT NULL DEFAULT NOW(),
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.sat_instruction (
  instruction_hk UUID REFERENCES dv.hub_instruction(instruction_hk),
  type VARCHAR(15),
  amount DECIMAL(20,2),
  status VARCHAR(15),
  effective_from TIMESTAMP NOT NULL DEFAULT NOW(),
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);

CREATE TABLE dv.sat_transaction (
  tx_hk UUID REFERENCES dv.hub_cbdc_transaction(tx_hk),
  type VARCHAR(10),
  amount DECIMAL(20,2),
  status VARCHAR(10),
  tx_timestamp TIMESTAMP,
  effective_from TIMESTAMP NOT NULL DEFAULT NOW(),
  load_dts TIMESTAMP NOT NULL DEFAULT NOW(),
  rec_src VARCHAR(50)
);
