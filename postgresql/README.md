# Postgresql

Some notes on Postgresql

## Useful extension

* TimescaleDB
* Crosstab

## Management queries
Change password for user postgres
```sql
ALTER ROLE postgres WITH PASSWORD 'password';
```

Get indexes in a database
```sql
SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'public'
ORDER BY
    tablename,
    indexname;
```

Get columnts of a table
```sql
SELECT * FROM information_schema.columns WHERE table_schema = 'schema' AND table_name = 'mytable';
```

Get constraints of a table
```sql
SELECT * FROM pg_constraint WHERE conrelid = (SELECT 'schema.mytable'::regclass::oid);
```

Get queries statistic against dbid
```sql
SELECT * FROM pg_stat_statements;
```

Get dbid of a database
```sql
SELECT oid, datname FROM pg_database;
```

Get queries are being processed
```sql
SELECT * FROM pg_stat_activity;
```

Get table grantees for a table
```sql
SELECT grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name='mytable';
```

## Rare basic operations
Substring of field from second symbold to end.
```sql
substring(fieldname, 2, length(fieldname)-1)
```

Type cast to int
```sql
fieldname::int
```

To get the last in a time range entry in some group. The example is getting the order of every user:
```sql
SELECT
    orders.*
FROM (
    SELECT
        user_id, MAX(created_at) AS created_at
    FROM
        orders
    GROUP BY
        user_id
) AS latest_orders
INNER JOIN orders
    ON orders.user_id = latest_orders.user_id
    AND orders.created_at = latest_orders.created_at
```

## Privileges management

Be a super user

```sql
CREATE DATABASE app1
REVOKE ALL ON DATABASE app1 from PUBLIC;
CREATE ROLE app1grp;
GRANT ALL ON DATABASE app1 TO app1grp;
CREATE USER user1;
GRANT ROLE app1grp TO user1;
```

Give access to created tables and sequences;
```sql
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO app1;
GRANT ALL ON ALL TABLES IN SCHEMA public TO app1;
```

Give members of app1grp access to future tables and sequences created by migrator.
```
ALTER DEFAULT PRIVILEGES FOR ROLE migrator IN SCHEMA public GRANT ALL ON TABLES TO app1grp;
ALTER DEFAULT PRIVILEGES FOR ROLE migrator IN SCHEMA public GRANT ALL ON SEQUENCES TO app1grp;
```

**Note:** the tables which are created by migrator should be created with explicit designation of the role.
If migrator is a role rather than user then creating a table should be after `SET ROLE migrator;`.
