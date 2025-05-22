# Backend-сервисы

## Основные сервисы backend

### InstructionService (Сервис инструкций)

- **Ответственность:**  
  Создание, обработка и отправка инструкций на платформу ЦР.

- **Методы:**  
  - `createInstruction(type, clientId, amount, targetWalletId?)`
  - `validateInstruction(instructionId)`
  - `sendInstructionToCB(instructionId)`
  - `updateInstructionStatus(instructionId, status)`
  
- **Используемые сущности:**  
  - Instruction
  - CBDCTransaction
  - Client

---

### AccountService (Сервис банковских счетов)

- **Ответственность:**  
  Управление состоянием и балансом банковских счетов клиентов.

- **Методы:**  
  - `checkAndReserveBalance(accountId, amount)`
  - `confirmBalanceDeduction(accountId, amount)`
  - `revertBalance(accountId, amount)`

- **Используемые сущности:**  
  - BankAccount
  - Client

---

### WalletService (Сервис цифровых кошельков)

- **Ответственность:**  
  Обслуживание операций и управление балансом цифровых кошельков.

- **Методы:**  
  - `checkWalletBalance(walletId, amount)`
  - `updateWalletBalance(walletId, amount, operation)`
  - `freezeWallet(walletId)`
  - `unfreezeWallet(walletId)`

- **Используемые сущности:**  
  - DigitalWallet
  - Client

---

### AutoPaymentService (Сервис автоплатежей)

- **Ответственность:**  
  Создание и управление регулярными переводами.

- **Методы:**  
  - `scheduleAutoPayments()`
  - `createAutoPayment(clientId, amount, schedule, targetWalletId)`
  - `cancelAutoPayment(autoPaymentId)`

- **Используемые сущности:**  
  - AutoPayment
  - Instruction

---

### AMLCFTService (Сервис AML/CFT контроля)

- **Ответственность:**  
  Проверки и мониторинг транзакций на соответствие AML/CFT.

- **Методы:**  
  - `checkTransaction(clientId, amount)`
  - `logAMLCFTEvent(clientId, reason)`
  - `blockClientOperations(clientId)`

- **Используемые сущности:**  
  - Client (kyc_status, is_blocked)
  - CBDCTransaction

---

### NotificationService (Сервис уведомлений)

- **Ответственность:**  
  Отправка уведомлений клиентам после операций.

- **Методы:**  
  - `notifyClient(clientId, notificationType, message)`
  - `generateNotificationXML(notificationType, transactionId)`

- **Используемые сущности:**  
  - Client
  - CBDCTransaction

---

## Взаимодействие сервисов (workflow)

Обработка инструкции клиента происходит следующим образом:

1. **Создание инструкции (Frontend → InstructionService).**
2. **Проверка лимитов и статусов (AccountService, WalletService, AMLCFTService).**
3. **Резервирование средств (при необходимости, AccountService).**
4. **Отправка инструкции в ЦР (InstructionService → интеграционный слой).**
5. **Получение ответа от ЦР (InstructionService).**
6. **Обновление состояния кошельков и счетов (WalletService, AccountService).**
7. **Фиксация результата транзакции (CBDCTransaction).**
8. **Отправка уведомлений клиентам (NotificationService).**

---

## Основные сущности backend:

- **Client** (ФЛ, ЮЛ)
- **DigitalWallet**
- **BankAccount**
- **Instruction**
- **CBDCTransaction**
- **AutoPayment**
