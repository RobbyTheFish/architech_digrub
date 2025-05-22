# Структуры STG-таблиц (слой подготовки данных)

Staging-слой предназначен для временного хранения и очистки сырых данных перед загрузкой в Data Vault.

## Список STG-таблиц:

| STG-таблица                 | Источник данных        | Ключевые поля              |
|-----------------------------|------------------------|----------------------------|
| `stg_clients`               | `client`               | client_id                  |
| `stg_bank_accounts`         | `bank_account`         | account_id                 |
| `stg_wallets`               | `digital_wallet`       | wallet_id                  |
| `stg_instructions`          | `instruction`          | instruction_id             |
| `stg_transactions`          | `cbdc_transaction`     | tx_id                      |
| `stg_auto_payments`         | `auto_payment`         | auto_payment_id            |

## Загрузка данных:

- Частота: ежечасно (инкрементальная загрузка).
- Хранение: 7 дней данных для перепроверок.