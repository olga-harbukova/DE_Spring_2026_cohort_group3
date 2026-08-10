import psycopg2

conn = psycopg2.connect(
    host="localhost",
    port=8732,
    database="dbt_course",
    user="postgres_user",
    password="postgres_pass"
)

with conn.cursor() as cur:
    # Добавляем данные - user_id это числа
    cur.execute("""
        INSERT INTO user_logins (user_id, event_type, event_time) VALUES
        (1, 'login', NOW()),
        (2, 'login', NOW()),
        (3, 'register', NOW())
    """)
    conn.commit()
    print("Добавлены тестовые данные")

    # Проверяем
    cur.execute("SELECT * FROM user_logins")
    rows = cur.fetchall()
    for row in rows:
        print(f"ID: {row[0]}, User: {row[1]}, Event: {row[2]}, Time: {row[3]}, Sent: {row[4]}")

conn.close()