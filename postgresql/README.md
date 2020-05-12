# Postgresql

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

