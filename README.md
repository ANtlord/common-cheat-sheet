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
# SSH

Tunnel to a certain point

```
ssh -L <localport>:<desired host>:<desired port> <user>@<host that has access to desired host and port>
```
