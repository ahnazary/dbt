from clickhouse_connect.driver import create_client

client = create_client(
    host = "localhost",
    port = 8123,
    password="",
    username="",
)

data = [(1, 7.234)]
client.insert(table="test", data=data)