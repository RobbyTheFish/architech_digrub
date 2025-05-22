## Domain Models

### ClientModel

- **Свойства:**

- `clientId`: string (UUID) — Уникальный идентификатор клиента.

- `type`: string — Тип клиента ("PERSON", "ORG", "UNVERIFIED").

- `kycStatus`: string — Статус KYC ("VERIFIED", "UNVERIFIED").

- `isBlocked`: boolean — Признак блокировки клиента.

- **Использование:** Проверка статуса клиента для оффлайн-платежей.

### DigitalWalletModel

- **Свойства:**

- `walletId`: string (UUID) — Идентификатор кошелька.

- `clientId`: string (UUID) — Идентификатор клиента.

- `balance`: number — Текущий баланс.

- `offlineLimit`: number — Лимит для оффлайн-транзакций.

- `status`: string — Статус кошелька ("ACTIVE", "FROZEN").

- **Использование:** Проверка баланса и лимита для оффлайн-платежей.

### OfflineTransactionModel

- **Свойства:**

- `txId`: string (UUID) — Уникальный идентификатор транзакции.

- `type`: string — Тип транзакции ("PAYMENT", "TRANSFER").

- `amount`: number — Сумма транзакции.

- `recipient`: string (UUID) — Идентификатор кошелька получателя.

- `timestamp`: Date — Дата и время (ISO 8601).

- `status`: string — Статус ("PENDING", "SUCCESS", "FAILED").

- `signature`: string — Электронная подпись.

- `fromWalletId`: string (UUID) — Идентификатор кошелька отправителя.

- `clientId`: string (UUID) — Идентификатор клиента.

- **Использование:** Хранение и синхронизация оффлайн-транзакций.

### BankAccountModel

- **Свойства:**

- `accountId`: string (UUID) — Идентификатор счета.

- `clientId`: string (UUID) — Идентификатор клиента.

- `accountNumber`: string — Номер счета.

- `balance`: number — Баланс счета.

- `status`: string — Статус ("ACTIVE", "CLOSED").

- **Использование:** Пополнение кошелька при синхронизации.

### AutoPaymentModel

- **Свойства:**

- `autoPaymentId`: string (UUID) — Идентификатор автоплатежа.

- `clientId`: string (UUID) — Идентификатор клиента.

- `targetWalletId`: string (UUID) — Идентификатор целевого кошелька.

- `amount`: number — Сумма.

- `schedule`: string — График ("ONCE", "DAILY", "MONTHLY").

- **Использование:** Настройка автоматических переводов.

### InstructionModel

- **Свойства:**

- `instructionId`: string (UUID) — Идентификатор инструкции.

- `clientId`: string (UUID) — Идентификатор клиента.

- `type`: string — Тип ("DEPOSIT", "WITHDRAW", "TRANSFER").

- `amount`: number — Сумма.

- `status`: string — Статус ("NEW", "SENT", "CONFIRMED", "ERROR").

- `createdAt`: Date — Дата создания.

- **Использование:** Создание инструкций для транзакций.

### CBDTransactionModel

- **Свойства:**

- `txId`: string (UUID) — Идентификатор транзакции.

- `instructionId`: string (UUID) — Идентификатор инструкции.

- `timestamp`: Date — Дата и время.

- `type`: string — Тип ("MINT", "BURN", "TRANSFER").

- `amount`: number — Сумма.

- `fromWalletId`: string (UUID) | null — Исходный кошелек.

- `toWalletId`: string (UUID) | null — Целевой кошелек.

- `status`: string — Статус ("PENDING", "SUCCESS", "FAILED").

- **Использование:** Отображение истории транзакций.### ClientModel

- **Свойства:**

- `clientId`: string (UUID) — Уникальный идентификатор клиента.

- `type`: string — Тип клиента ("PERSON", "ORG", "UNVERIFIED").

- `kycStatus`: string — Статус KYC ("VERIFIED", "UNVERIFIED").

- `isBlocked`: boolean — Признак блокировки клиента.

- **Использование:** Проверка статуса клиента для оффлайн-платежей.

### DigitalWalletModel

- **Свойства:**

- `walletId`: string (UUID) — Идентификатор кошелька.

- `clientId`: string (UUID) — Идентификатор клиента.

- `balance`: number — Текущий баланс.

- `offlineLimit`: number — Лимит для оффлайн-транзакций.

- `status`: string — Статус кошелька ("ACTIVE", "FROZEN").

- **Использование:** Проверка баланса и лимита для оффлайн-платежей.

### OfflineTransactionModel

- **Свойства:**

- `txId`: string (UUID) — Уникальный идентификатор транзакции.

- `type`: string — Тип транзакции ("PAYMENT", "TRANSFER").

- `amount`: number — Сумма транзакции.

- `recipient`: string (UUID) — Идентификатор кошелька получателя.

- `timestamp`: Date — Дата и время (ISO 8601).

- `status`: string — Статус ("PENDING", "SUCCESS", "FAILED").

- `signature`: string — Электронная подпись.

- `fromWalletId`: string (UUID) — Идентификатор кошелька отправителя.

- `clientId`: string (UUID) — Идентификатор клиента.

- **Технологии**:

  - iOS: Keychain для ключей, Core Data для транзакций.
  - Android: Keystore для ключей, Room для транзакций.
  - Веб: IndexedDB с шифрованием.

- **Шифрование**: ГОСТ 28147-89 для данных, ГОСТ 34.10-2018 для подписей.
- **Структура**:

  - Таблица Wallet: Хранит DigitalWalletModel.
  - Таблица OfflineTransactions: Хранит массив OfflineTransactionModel.

- **Поток данных**:

  1.  Пользователь сканирует QR-код на PaymentScreen.

  2.  PaymentViewModel проверяет DigitalWalletModel.balance и offlineLimit.

  3.  Создается OfflineTransactionModel, подписывается через SecurityService.

  4.  Транзакция сохраняется в LocalStorageService.

  5.  При подключении к интернету транзакции отправляются на бэкенд.

  6.  UI обновляется с результатом (cbdc.777 DCTransferC2CRecipientNotification).

- **Безопасность**:

  - Данные шифруются перед сохранением.

  - Подписи создаются с использованием ПМ БР.

  - Ключи хранятся в безопасном хранилище устройства.

### BankAccountModel

- **Свойства:**

- `accountId`: string (UUID) — Идентификатор счета.

- `clientId`: string (UUID) — Идентификатор клиента.

- `accountNumber`: string — Номер счета.

- `balance`: number — Баланс счета.

- `status`: string — Статус ("ACTIVE", "CLOSED").

- **Использование:** Пополнение кошелька при синхронизации.

### AutoPaymentModel

- **Свойства:**

- `autoPaymentId`: string (UUID) — Идентификатор автоплатежа.

- `clientId`: string (UUID) — Идентификатор клиента.

- `targetWalletId`: string (UUID) — Идентификатор целевого кошелька.

- `amount`: number — Сумма.

- `schedule`: string — График ("ONCE", "DAILY", "MONTHLY").

- **Использование:** Настройка автоматических переводов.

### InstructionModel

- **Свойства:**

- `instructionId`: string (UUID) — Идентификатор инструкции.

- `clientId`: string (UUID) — Идентификатор клиента.

- `type`: string — Тип ("DEPOSIT", "WITHDRAW", "TRANSFER").

- `amount`: number — Сумма.

- `status`: string — Статус ("NEW", "SENT", "CONFIRMED", "ERROR").

- `createdAt`: Date — Дата создания.

- **Использование:** Создание инструкций для транзакций.

### CBDTransactionModel

- **Свойства:**

- `txId`: string (UUID) — Идентификатор транзакции.

- `instructionId`: string (UUID) — Идентификатор инструкции.

- `timestamp`: Date — Дата и время.

- `type`: string — Тип ("MINT", "BURN", "TRANSFER").

- `amount`: number — Сумма.

- `fromWalletId`: string (UUID) | null — Исходный кошелек.

- `toWalletId`: string (UUID) | null — Целевой кошелек.

- `status`: string — Статус ("PENDING", "SUCCESS", "FAILED").

- **Использование:** Отображение истории транзакций.

## ViewModel

### PaymentViewModel

- **Связанные модели**: `DigitalWalletModel`, `OfflineTransactionModel`, `CBDTransactionModel`

- **Функциональность**:

- Проверяет локальный баланс перед оффлайн-платежом.

- Создает и подписывает `OfflineTransactionModel`.

- Сохраняет транзакцию в локальном хранилище.

- Синхронизирует транзакции с бэкендом (`cbdc.003 CustomerDCTransferC2C`).

- Обновляет UI с текущим статусом.

- **Пример методов**:

- `initiateOfflinePayment(amount, recipient)`: Создает оффлайн-платеж.

- `syncOfflineTransactions()`: Синхронизирует транзакции.

- `updateTransactionStatus(txId, status)`: Обновляет статус.

### WalletViewModel

- **Связанные модели**: `DigitalWalletModel`, `CBDTransactionModel`

- **Функциональность**:

- Отображает локальный баланс и историю транзакций.

- Синхронизирует баланс с бэкендом (`cbdc.010 GetCustomerWalletInfo`).

- **Пример методов**:

- `fetchLocalBalance()`: Извлекает локальный баланс.

- `syncWalletData()`: Синхронизирует данные кошелька.

### AuthViewModel

- **Связанные модели**: `ClientModel`

- **Функциональность**:

- Проверяет KYC-статус клиента для оффлайн-операций.

- Управляет аутентификацией (`cbdc.022 XManagementRequest`).

- **Пример методов**:

- `checkKycStatus()`: Проверяет статус KYC.

### TransferViewModel

- **Связанные модели**: `DigitalWalletModel`, `InstructionModel`, `CBDTransactionModel`

- **Функциональность**:

- Управляет переводами C2C (`cbdc.012 C2CPossibilityRequest`).

- Проверяет баланс и инициирует пополнение.

- Обновляет UI с уведомлениями.

- **Пример методов**:

- `initiateTransfer(amount, recipient)`: Инициирует перевод.

- `checkBalance()`: Проверяет баланс.

### AutoPaymentViewModel

- **Связанные модели**: `AutoPaymentModel`, `InstructionModel`

- **Функциональность**:

- Настраивает автоплатежи (`cbdc.100 SETTemplateListRequest`).

- Управляет изменением или отменой автоплатежей.

- Отображает уведомления.

- **Пример методов**:

- `setupAutoPayment(params)`: Настраивает автоплатеж.

- `cancelAutoPayment(id)`: Отменяет автоплатеж.

### TopUpWithdrawViewModel

- **Связанные модели**: `BankAccountModel`, `DigitalWalletModel`, `InstructionModel`

- **Функциональность**:

- Обрабатывает пополнение (`cbdc.002 CustomerDCBuyingOrder`) и вывод средств.

- Обновляет баланс и UI.

- **Пример методов**:

- `topUpWallet(amount, accountId)`: Пополняет кошелек.

- `withdrawFunds(amount, accountId)`: Выводит средства.
