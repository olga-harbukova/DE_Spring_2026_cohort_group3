import json
from kafka import KafkaConsumer
import clickhouse_connect
from datetime import datetime

# Подключение к ClickHouse
client = clickhouse_connect.get_client(
    host='localhost',
    port=8123,
    username='user',
    password='strongpassword'
)

# Создаем таблицу в ClickHouse
client.command("""
    CREATE TABLE IF NOT EXISTS user_logins (
        id Int32,
        user_id Int32,
        event_type String,
        event_time DateTime
    ) ENGINE = MergeTree()
    ORDER BY event_time
""")

# Подключение к Kafka
consumer = KafkaConsumer(
    'user_events',
    bootstrap_servers='localhost:9092',
    auto_offset_reset='earliest',
    enable_auto_commit=True,
    group_id='clickhouse_loader',
    value_deserializer=lambda v: json.loads(v.decode('utf-8'))
)

print("Consumer запущен")

for message in consumer:
    event = message.value
    print(f"Получено: {event}")

    # Преобразуем строку времени в datetime
    if isinstance(event['event_time'], str):
        event_time = datetime.fromisoformat(event['event_time'].replace(' ', 'T'))
    else:
        event_time = event['event_time']

    # Вставляем в ClickHouse
    client.insert(
        'user_logins',
        [[event['id'], event['user_id'], event['event_type'], event_time]],
        column_names=['id', 'user_id', 'event_type', 'event_time']
    )
    print(f"Записано в ClickHouse: {event}")