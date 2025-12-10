#!pip install Faker mysql-connector-python

from faker import Faker
from getpass import getpass
from mysql.connector import connect, Error
import random

fake = Faker()

def gen_random_prefix():
    res = ""
    for _ in range(8):
        num = random.randint(0, 15)
        res += hex(num)[-1]
    return res

def execute_sql_file(path, cursor):
    with open(path, 'r') as f:
        script = f.read()
    
    commands = script.split(';')

    for command in commands:
        if command.strip():
            try:
                cursor.execute(command)
            except Error as e:
                raise e

try:
    with connect(
        host="localhost",
        user=input("username: "),
        password=getpass("password: "),
        database=input("database: ")
    ) as connection:
        with connection.cursor() as cursor:
            print("Setting up database...")
            execute_sql_file("sql/setup_db_structure.sql", cursor)
            print("Done!")

            print("Creating indexes...")
            execute_sql_file("sql/create_indexes.sql", cursor)
            print("Done!")

            print("Filling up category table...")
            for _ in range(1000):
                name = fake.word() + gen_random_prefix()
                cursor.execute("INSERT INTO category (name) VALUES (%s)", [name])
            print("Done!")

            print("Filling up pizza table...")
            for _ in range(10_000):
                name = fake.word() + gen_random_prefix()
                category = random.randint(1, 1000)
                cursor.execute("INSERT INTO pizza (name, category_id) VALUES (%s, %s)", [name, category])
            print("Done!")

            print("Filling up item table...")
            sizes = ["small", "medium", "large"]
            for i in range(0, 30_000):
                price = round(random.uniform(5, 20), 2)
                size = sizes[i % 3]
                pizza = i // 3 + 1
                cursor.execute("INSERT INTO item (pizza_id, size, price) VALUES (%s, %s, %s)", [pizza, size, price])
            print("Done!")

            print("Filling up ingredient table...")
            for _ in range(1000):
                name = fake.word() + gen_random_prefix()
                cursor.execute("INSERT INTO ingredient (name) VALUES (%s)", [name])
            print("Done!")

            ingredients = []
            print("Filling up pizza_ingredient table...")
            for i in range(80_000):
                if i % 8 == 0:
                    ingredients = [i + 1 for i in range(1000)]
                pizza = i // 8 + 1
                ingredient = random.choice(ingredients)
                ingredients.remove(ingredient)
                cursor.execute("INSERT INTO pizza_ingredient (pizza_id, ingredient_id) VALUES (%s, %s)", [pizza, ingredient])
            print("Done!")

            print("Filling up ord and ord_item table...")
            channels = ["phone", "offline", "application"]
            for i in range(10_000):
                timestamp = fake.date_time_between_dates(datetime_start="-10y", datetime_end="+10y")
                channel = random.choice(channels)
                cursor.execute("INSERT INTO ord (order_time, channel) VALUES (%s, %s)", [timestamp, channel])
                items = [i + 1 for i in range(30_000)]
                for _ in range(random.randint(1, 5)):
                    item = random.choice(items)
                    items.remove(item)
                    qtt = random.randint(1, 5)
                    cursor.execute("INSERT INTO ord_item (ord_id, item_id, quantity) VALUES (%s, %s, %s)", [i + 1, item, qtt])
            print("Done!")

            print("Commiting transaction...")
            connection.commit()
            print("Done!")
except Error as e:
    print(f"Error: {e}")
    if connection:
        connection.rollback()
        print("Transaction rolled back")