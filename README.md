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
