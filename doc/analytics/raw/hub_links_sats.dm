erDiagram

%% HUBS
Hub_Client {
    UUID client_hk PK
}

Hub_DigitalWallet {
    UUID wallet_hk PK
}

Hub_BankAccount {
    UUID account_hk PK
}

Hub_Instruction {
    UUID instruction_hk PK
}

Hub_CBDCTransaction {
    UUID tx_hk PK
}

Hub_AutoPayment {
    UUID auto_payment_hk PK
}

%% LINKS
Link_Client_Wallet {
    UUID link_hk PK
    UUID client_hk FK
    UUID wallet_hk FK
}

Link_Client_BankAccount {
    UUID link_hk PK
    UUID client_hk FK
    UUID account_hk FK
}

Link_Client_Instruction {
    UUID link_hk PK
    UUID client_hk FK
    UUID instruction_hk FK
}

Link_Instruction_Transaction {
    UUID link_hk PK
    UUID instruction_hk FK
    UUID tx_hk FK
}

Link_Client_AutoPayment {
    UUID link_hk PK
    UUID client_hk FK
    UUID auto_payment_hk FK
}

%% SATELLITES
Sat_Client {
    UUID client_hk FK
    VARCHAR type
    VARCHAR kyc_status
    BOOLEAN is_blocked
    TIMESTAMP effective_from
}

Sat_Wallet {
    UUID wallet_hk FK
    DECIMAL balance
    DECIMAL offline_limit
    VARCHAR status
    TIMESTAMP effective_from
}

Sat_BankAccount {
    UUID account_hk FK
    DECIMAL balance
    VARCHAR account_number
    VARCHAR status
    TIMESTAMP effective_from
}

Sat_Instruction {
    UUID instruction_hk FK
    VARCHAR type
    DECIMAL amount
    VARCHAR status
    TIMESTAMP created_at
    TIMESTAMP effective_from
}

Sat_Transaction {
    UUID tx_hk FK
    VARCHAR type
    DECIMAL amount
    VARCHAR status
    TIMESTAMP tx_timestamp
    TIMESTAMP effective_from
}

Sat_AutoPayment {
    UUID auto_payment_hk FK
    DECIMAL amount
    VARCHAR schedule
    TIMESTAMP next_payment
    TIMESTAMP effective_from
}

%% RELATIONSHIPS

Hub_Client ||--o{ Link_Client_Wallet : "1 → N"
Hub_DigitalWallet ||--o{ Link_Client_Wallet : "1 → 1"

Hub_Client ||--o{ Link_Client_BankAccount : "1 → N"
Hub_BankAccount ||--o{ Link_Client_BankAccount : "1 → 1"

Hub_Client ||--o{ Link_Client_Instruction : "1 → N"
Hub_Instruction ||--o{ Link_Client_Instruction : "1 → 1"

Hub_Instruction ||--o{ Link_Instruction_Transaction : "1 → N"
Hub_CBDCTransaction ||--o{ Link_Instruction_Transaction : "1 → 1"

Hub_Client ||--o{ Link_Client_AutoPayment : "1 → N"
Hub_AutoPayment ||--o{ Link_Client_AutoPayment : "1 → 1"

%% HUB - SAT Relationships

Hub_Client ||--|| Sat_Client : "1 → 1"
Hub_DigitalWallet ||--|| Sat_Wallet : "1 → 1"
Hub_BankAccount ||--|| Sat_BankAccount : "1 → 1"
Hub_Instruction ||--|| Sat_Instruction : "1 → 1"
Hub_CBDCTransaction ||--|| Sat_Transaction : "1 → 1"
Hub_AutoPayment ||--|| Sat_AutoPayment : "1 → 1"