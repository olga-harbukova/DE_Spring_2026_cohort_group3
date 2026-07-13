from datetime import datetime, timedelta
from pymongo import MongoClient

# Подключение к MongoDB
client = MongoClient('mongodb://localhost:27017/')
db = client['your_database']
users = db['users']
archive = db['users_archive']

# Находим старых пользователей
today = datetime.now()
old_date = today - timedelta(days=30)
no_activity = today - timedelta(days=14)

old_users = users.find({
    "user_info.registration_date": {"$lt": old_date},
    "event_time": {"$lt": no_activity}
})

old_users_list = list(old_users)
count = len(old_users_list)

print("Старые пользователи:", count)

if count > 0:
    archive.insert_many(old_users_list)
    print("Скопировано в архив:", count)

    users.delete_many({
        "user_info.registration_date": {"$lt": old_date},
        "event_time": {"$lt": no_activity}
    })
