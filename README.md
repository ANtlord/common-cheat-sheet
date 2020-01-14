# SQLAlchemy
Show sql with arguments
```python
print(query.statement.compile(compile_kwargs={"literal_binds": True}))
```

# Grep
Find word in py files excluding some directories.
```bash
grep -rnHw 'TokenIdType' ./ --include=\*.py --exclude-dir=var --exclude-dir=web --exclude-dir=.venv
```

# Postgresql
Change password for user postgres
```sql
ALTER ROLE postgres WITH PASSWORD 'password';
```
Substring of field from second symbold to end.
```sql
substring(fieldname, 2, length(fieldname)-1)
```
Type cast to int
```sql
fieldname::int
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
Get queries statistic against dbid
```sql
SELECT * FROM pg_stat_statements;
```
Get dbid of a table
```sql
SELECT oid, database_name FROM pg_database;
```
Get queries are being processed
```sql
SELECT * FROM pg_stat_activity;
```

Get table grantees for a table
```sql
SELECT grantee, privilege_type FROM information_schema.role_table_grants WHERE table_name='mytable';
```
