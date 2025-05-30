# Архитектура данных Цифрового рубля
by мисис что-нибудь.
Данный репозиторий содержит артефакты для хакатона ARCHI.Tech, трек Архитектура данных ЦР. В рамках решения данной задачи необходимо было разработать архитектуру данных цифрового рубля для банка-посредника (ВТБ), чтобы упростить процесс интеграции кредитной организации с платформой ЦР.

## Содержание
В данном проекте представлена следующая структура:
```
doc/
├── conceptual/
│   ├── uml_class_diagram.png         # Диаграмма классов UML
│   └── conceptual_model.md           # Текстовое описание всех сущностей
│
├── logical/
│   ├── logical_data_flow.png         # Диаграмма взаимосвязей и потоков
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
├── analytics/
│   ├── data_marts.md                 # Описание витрин и отчётов
│   ├── etl_pipeline.md               # Как переносить данные в DWH
│   └── example_queries.sql           # Примеры BI-запросов
│
├── pdf/
│   └── bank_cbdc_architecture.pdf    # Основной документ PDF
│
└── README.md                         # Краткое описание структуры и как использовать
```
##  Состав команды.
- Озеров Ярослав — architect, analyst,
- Селивёрстов Никита — architect,
- Дулян Арсен — architect, frontend
- Черкащенко Анастасия — PM

## Заключение.
В рамках решения задачи хакатона была сформирована надежная архитектура данных ЦР, удовлертворяющая функциональным требованиям, а также отвечающая требованиям законодательства, в частности ПОД/ФТ.

The MIT License
