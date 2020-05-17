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

Add source code of Rust standart library
```
directory ~/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/
```

Somehow gdb tries to get the magic path. Replace it:
```
set substitute-path /rustc/4fb7144ed159f94491249e86d5bbd033b5d60550/src /src
```
