-- Витрина транзакций (Mart Transactions)
CREATE TABLE marts.mart_transactions AS
SELECT 
  c.client_hk,
  t.tx_hk,
  w.wallet_hk,
  t.type,
  t.amount,
  t.status,
  t.tx_timestamp
FROM dv.hub_cbdc_transaction t
JOIN dv.link_instruction_transaction lit ON lit.tx_hk = t.tx_hk
JOIN dv.hub_instruction i ON i.instruction_hk = lit.instruction_hk
JOIN dv.link_client_instruction lci ON lci.instruction_hk = i.instruction_hk
JOIN dv.hub_client c ON c.client_hk = lci.client_hk
JOIN dv.link_client_wallet lcw ON lcw.client_hk = c.client_hk
JOIN dv.hub_digital_wallet w ON w.wallet_hk = lcw.wallet_hk;
