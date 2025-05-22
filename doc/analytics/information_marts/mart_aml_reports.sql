-- AML витрина
CREATE TABLE marts.mart_aml_reports AS
SELECT 
  c.client_hk,
  c.kyc_status,
  t.tx_hk,
  t.amount,
  t.type,
  t.tx_timestamp,
  CASE WHEN t.amount >= 600000 THEN 'HIGH_RISK' ELSE 'NORMAL' END AS risk_level
FROM dv.hub_cbdc_transaction t
JOIN dv.link_instruction_transaction lit ON lit.tx_hk = t.tx_hk
JOIN dv.hub_instruction i ON i.instruction_hk = lit.instruction_hk
JOIN dv.link_client_instruction lci ON lci.instruction_hk = i.instruction_hk
JOIN dv.hub_client c ON c.client_hk = lci.client_hk
WHERE c.kyc_status = 'UNVERIFIED' OR t.amount >= 600000;
