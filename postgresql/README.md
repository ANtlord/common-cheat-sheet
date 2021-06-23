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

Get columns of a table

```sql
SELECT * FROM information_schema.columns 
WHERE table_schema = 'schema' AND table_name = 'mytable';
```

Get constraints of a table

```sql
SELECT * FROM pg_constraint
WHERE conrelid = (SELECT 'schema.mytable'::regclass::oid);
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
SELECT grantee, privilege_type
FROM information_schema.role_table_grants WHERE table_name='mytable';
```

Kill a request

```sql
SELECT pg_cancel_backend(<pid of process>);
```

Get a user's groups

```sql
select rolname from pg_user
join pg_auth_members on (pg_user.usesysid=pg_auth_members.member)
join pg_roles on (pg_roles.oid=pg_auth_members.roleid)
where
pg_user.usename='app1user1';
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

Get running amount and difference between current and previous rows. Use windows functions.

```sql
SELECT
    user_id,
    created_at,
    amount,
    sum(amount) OVER (PARTITION BY user_id ORDER BY created_at),
    amount - (lag(amount, 1) OVER (PARTITION BY user_id ORDER BY created_at)
FROM rewards
ORDER BY created_at
```

## Privileges management

Be a super user

```sql
CREATE DATABASE app1
REVOKE ALL ON DATABASE app1 from PUBLIC;
CREATE ROLE app1grp;
GRANT ALL ON DATABASE app1 TO app1grp;
CREATE USER user1;
GRANT app1grp TO user1; # grant role
```

Give access to created tables and sequences;

```sql
GRANT ALL ON ALL SEQUENCES IN SCHEMA public TO app1grp;
GRANT ALL ON ALL TABLES IN SCHEMA public TO app1grp;
```

Give members of app1grp access to future tables and sequences created by migrator.
Run it being connected to the **target** database;

```
ALTER DEFAULT PRIVILEGES FOR ROLE migrator IN SCHEMA public GRANT ALL ON TABLES TO app1grp;
ALTER DEFAULT PRIVILEGES FOR ROLE migrator IN SCHEMA public GRANT ALL ON SEQUENCES TO app1grp;
```

**Note:** the tables which are created by migrator should be created with explicit designation of the role.
If migrator is a role rather than user then creating a table should be after `SET ROLE migrator;`.

**Note:** users of database `app1` have access to all tables of the database
because the tables are created by `migrator` role. That means that `migrator`
must create tables only in one database to prevent undesired access.

**Note:** You can keep one user `migrator` but maintain a role per a database
for the user.