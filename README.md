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

# MIN/MAX from scratch

How to get min and max of integers

## ubyte

[0 .. 255], 256 cases, number of bits (bn) = 8, 256 = 2 ^ 8

* min = 0
* max = (1 << (bn - 1)) | (1 << (bn - 1) - 1) // 128 (b1000_0000) | 127 (b0111_1111)

## byte

* min = -1 - max(ubyte) / 2
* max = min(byte) + max(ubyte)

# Go randoms

```
rand.Seed(time.Now().UnixNano())
rand.Float64() // [0; 1)
rand.Int31n(n) // [0; n)
```
