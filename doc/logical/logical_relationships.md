## 1. Сущности и связи

| Источник (Parent)      | Поле FK               | Назначение (Child)      | Кардинальность | ON UPDATE / ON DELETE | Описание связи                                     |
|------------------------|-----------------------|-------------------------|---------------|-----------------------|-----------------------------------------------------|
| **Client**             | `clientId`            | **BankAccount**         | 1 → 0..*      | CASCADE / RESTRICT    | Клиент может иметь несколько банковских счетов      |
| **Client**             | `clientId`            | **DigitalWallet**       | 1 → 1         | CASCADE / RESTRICT    | У каждого клиента ровно один цифровой кошелёк       |
| **Client**             | `clientId`            | **AutoPayment**         | 1 → 0..*      | CASCADE / RESTRICT    | Клиент может настроить несколько автоплатежей       |
| **Instruction**        | `clientId`            | **Client**              | 0..* → 1      | RESTRICT / RESTRICT   | Инструкция создаётся конкретным клиентом           |
| **Instruction**        | `instructionId`       | **CBDCTransaction**     | 1 → 0..*      | CASCADE / SET NULL    | Одна инструкция может порождать одну или несколько транзакций |
| **DigitalWallet**      | `walletId`            | **CBDCTransaction.from**| 1 → 0..*      | RESTRICT / RESTRICT   | Исходный кошелёк в транзакции (null для MINT)      |
| **DigitalWallet**      | `walletId`            | **CBDCTransaction.to**  | 1 → 0..*      | RESTRICT / RESTRICT   | Целевой кошелёк в транзакции (null для BURN)       |
| **AutoPayment**        | `clientId`            | **Client**              | 0..* → 1      | RESTRICT / RESTRICT   | Автоплатёж принадлежит конкретному клиенту         |

> **Примечание по ON DELETE/UPDATE.**  
> - Для Client → *: при удалении клиента запрещаем удалять «дочку» — RESTRICT, а при изменении PK клиента — CASCADE.  
> - Для Instruction → CBDCTransaction: при удалении инструкции — каскадно удаляем связанные транзакции; при изменении PK инструкции — устанавливаем NULL в tx.instructionId.

---

## 2. Бизнес-процессы и правила

### 2.1 DEPOSIT (конверсия bank → CBDC)
1. Клиент создаёт `Instruction(type=DEPOSIT)` во Frontend.  
2. `InstructionService` сохраняет запись, статус = `NEW`.  
3. `AccountService` проверяет:
   - счёт активен (`BankAccount.status = 'ACTIVE'`),
   - баланс ≥ суммы (`balance ≥ amount`).
4. Если OK → `UPDATE BankAccount.balance = balance – amount`.
5. `InstructionService` шлёт в ЦБ через `CBAdapter` XML-запрос.
6. При получении ответа:
   - создаётся `CBDCTransaction(type=MINT, status=SUCCESS|FAILED)`,
   - `Instruction.status = CONFIRMED|ERROR`,
   - в случае `SUCCESS` — `DigitalWallet.balance += amount`.

### 2.2 WITHDRAW (конверсия CBDC → bank)
Аналогично DEPOSIT, но:
- `Instruction(type=WITHDRAW)` → в ЦБ `BURN`,
- при успехе: `DigitalWallet.balance –= amount`, затем `BankAccount.balance += amount`.

### 2.3 TRANSFER (между кошельками)
1. Клиент создаёт `Instruction(type=TRANSFER)` с `toWalletId`.  
2. `WalletService` проверяет:
   - кошелёк активен (`status = 'ACTIVE'`),
   - баланс ≥ суммы или (offlineLimit ≥ amount при офлайн).  
3. `InstructionService` → ЦБ `TRANSFER`.  
4. При ответе:
   - создаётся `CBDCTransaction(type=TRANSFER)`,
   - `DigitalWallet.from.balance –= amount`,
   - `DigitalWallet.to.balance += amount`.

### 2.4 AutoPayment
1. По расписанию (`ONCE`|`DAILY`|`MONTHLY`) `AutoPayService` выбирает записи из `AutoPayment`.  
2. Для каждой генерирует `Instruction(type=TRANSFER)` и запускает тот же процесс, что и в §2.3.

### 2.5 Офлайн-режим
- При офлайн-платеже в MobileApp проверяется `DigitalWallet.offlineLimit`.
- Операции ставятся в локальную очередь, синхронизируются при восстановлении связи.

### 2.6 ПОД/ФТ/ФРОМУ
- Все операции логируются в `CBDCTransaction` с полным комплектом атрибутов.
- При `Client.kycStatus = UNVERIFIED` или `Client.isBlocked = true` — запрет на создание любых инструкций (CHECK-констрейнт в сервисе инструкций).

---

## 3. Правила валидации (CHECK-констрейнты)

- `Instruction.amount > 0`
- `CBDCTransaction.amount > 0`
- `BankAccount.balance >= 0`
- `DigitalWallet.balance >= 0`
- `DigitalWallet.offlineLimit >= 0`
- `Instruction.status IN ('NEW','SENT','CONFIRMED','ERROR')`
- `CBDCTransaction.status IN ('PENDING','SUCCESS','FAILED')`
- `Instruction.type IN ('DEPOSIT','WITHDRAW','TRANSFER')`
- `CBDCTransaction.type IN ('MINT','BURN','TRANSFER')`
- `AutoPayment.schedule IN ('ONCE','DAILY','MONTHLY')`

---

## 4. Загрузка в аналитический DW

- **Hubs**: Client, BankAccount, DigitalWallet, Instruction, AutoPayment, CBDCTransaction  
- **Links**: Client→BankAccount, Client→DigitalWallet, Instruction→Client, Instruction→CBDCTransaction, AutoPayment→Client, Transaction→Wallet(from/to)  
- **Satellites**: атрибуты каждого хаба и ссылки с историей изменений (status, balance, kycStatus, isBlocked, timestamps и др.)
