# Миграция данных из PostgreSQL в ClickHouse через Kafka

## Описание
Пайплайн для миграции данных с защитой от дубликатов.

## Архитектура
PostgreSQL → Producer → Kafka → Consumer → ClickHouse

## Защита от дубликатов
Поле `sent_to_kafka` в PostgreSQL предотвращает повторную отправку.

## Запуск
```bash
docker-compose up -d
pip install -r requirements.txt
python add_test_data.py
python consumer.py  # Терминал 1
python producer.py  # Терминал 2