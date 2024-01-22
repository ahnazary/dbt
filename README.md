
# DBT

## Setup

### Install 

1. Install proper dbt package for your database. This repos as of now only supports postgresql.

```
pip install dbt-postgres
```

2. Create profiles.yml file in ~/.dbt folder to configure database connection. 

```
finance:
  outputs:
    dev:
      dbname: <DB_NAME>
      host: <HOST>
      pass: <PASSWORD>
      port: <PORT>
      schema: <SCHEMA>
      threads: 1
      type: postgres
      user: <USER>
  target: dev
```

3. test connection

```
dbt debug
```

4. Create models in `finance/models` folder.

5. Run dbt commands

```
dbt run
```