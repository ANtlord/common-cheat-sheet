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

# GDB

Show assembly against source code
```
disassemble /m
```

Set assembly syntax

* Intel `set disassembly-flavor intel`
* AT&T `set disassembly-flavor att`

Show code and assembly TUI
```
split layout
```
