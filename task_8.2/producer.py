import psycopg2
import json
import time
from kafka import KafkaProducer

conn = psycopg2.connect(
    host="localhost",
    port=8732,
    database="dbt_course",
    user="postgres_user",
    password="postgres_pass"
)

producer = KafkaProducer(
    bootstrap_servers='localhost:9092',
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

TOPIC = 'user_events'

while True:
    with conn.cursor() as cur:
        # Берем только неотправленные записи
        cur.execute("""
            SELECT id, user_id, event_type, event_time
            FROM user_logins
            WHERE sent_to_kafka = FALSE
            ORDER BY id
        """)
        rows = cur.fetchall()

        for row in rows:
            event = {
                'id': row[0],
                'user_id': row[1],
                'event_type': row[2],
                'event_time': str(row[3])
            }

            # Отправляем в Kafka
            producer.send(TOPIC, value=event)
            producer.flush()

            # Помечаем как отправленное
            cur.execute(
                "UPDATE user_logins SET sent_to_kafka = TRUE WHERE id = %s",
                (row[0],)
            )
            conn.commit()
            print(f"Отправлено: {event}")

    time.sleep(5)