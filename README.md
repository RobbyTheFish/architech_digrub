# architech_digrub
bank_cbdc_data_architecture/
├── conceptual/
│   ├── uml_class_diagram.png         # Диаграмма классов UML
│   └── conceptual_model.md           # Текстовое описание всех сущностей
│
├── logical/
│   ├── ![alt text](image.png).png         # Диаграмма взаимосвязей и потоков
│   └── logical_relationships.md      # Таблица связей, бизнес-процессов, правил
│
├── physical/
│   ├── ddl_schema.sql                # SQL-создание таблиц
│   ├── physical_storage.md           # Табличное описание хранения
│   ├── instruction_request.xml       # XML-пример исходящего запроса
│   ├── transaction_result.xml        # XML-пример ответа от ЦБ
│
├── frontend/
│   └── frontend_models.md            # ViewModel'и, формы, поля, безопасное хранилище
│
├── backend/
│   ├── backend_services.md           # Сервисы, сущности, обработка поручений
│   └── backend_sequence_flow.png     # Диаграмма последовательности вызовов (если нужно)
│
├── integration/
│   ├── message_exchange.md           # Описание взаимодействия по XML API
│   └── validation_rules.md           # Проверки до передачи в ЦБ (KYC, лимиты и т.д.)
│
├──analytics/
│   staging_tables.md           # структуры stg-таблиц
│   raw_vault/
│   ├── hubs_links_sats.dm      # схема DV (Mermaid/PlantUML)
│   ├── create_hubs_links.sql   # DDL для hubs+links
│   └── create_sats.sql         # DDL для satellites
│   information_marts/
│   ├── mart_transactions.sql   # DDL витрины транзакций
│   └── mart_aml_reports.sql    # DDL AML-витрины
│
├── pdf/
│   └── bank_cbdc_architecture.pdf    # Основной документ PDF
│
└── README.md                         # Краткое описание структуры и как использовать
