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

# Extend disk

Extend a partition

* open cfdisk
* choose the last partition (resizing a partition in the middle is not straighforward)
* resize as much as possible and write

Extend an ext4 filesystem
```
e2fsck -f /dev/sdb1
resize2fs /dev/sdb1
```

# LVM

## Create a partition and a filesystem.

* make a partition an LVM partition (can be done in cfdisk)

```
pvcreate /dev/sdb1
vgcreate app1data /dev/sdb1
lvcreate --name app1data_lv1 --size 1G app1data
mkfs.ext4 /dev/app1data/app1data_lv1
```

## Extend the filesystem with another disk.

* make a partition an LVM partition (can be done in cfdisk)

```
pvcreate /dev/sdb1
vgextend app1data /dev/sdc1
lvextend -L1.5G /dev/app1data/app1data_lv1
resize2fs /dev/app1data/app1data_lv1
```

# Git

## Dump commits in CSV.

```
git log --pretty=format:%h,%an,%s --all --since=2020-11-01 --until=2020-11-17 --author=antlord92@gmail.com
```

Details of format are in `git log --help` and find `format:<string>` in the manual page.

## Designate certain SSH identity

```
git config --local core.sshCommand "/usr/bin/ssh -i /home/me/.ssh/id_rsa_foo"
```

```
git clone <address> --config core.sshCommand "/usr/bin/ssh -i /home/me/.ssh/id_rsa_foo"
```



# Regular expressions (regex)

Problem: build regular expression for a binary number multiple of 3.
(https://stackoverflow.com/a/867576)[Here] is a solution with an explanation.
The idea of the problem is drawing the automata and eliminating middle states. 

# Salt
Clean up old minions: `salt-run manage.down removekeys=True`
Run a script `salt '<host>' cmd.script salt://scripts/runme.sh`
Set grain: `salt '<host>' grains.setval '<key>' '<val>'`
Set roles: `salt '<host>' grains.setval roles "['certain-role']"`

# Graphite
To send data to graphite from bash `echo 'path.to.metric:value|g' > /dev/udb/localhost/port`

# Syscalls
Possible subjects: NASM, Linux, Assembly, Syscalls
How to get a list of syscalls:
- `man 2 syscalls` there should be a path to file where they are defined (currently: /usr/include/asm/unistd.h)
- The file is split into two parts: 64bit (/usr/include/asm/unistd_64.h) and 32bit: (/usr/include/asm/unistd_32.h)

# Systemd unit
```
[Unit]
Description=Src daemon
After=network.target

[Service]
Restart=always
ExecStart=/path/to/exe

[Install]
WantedBy=multi-user.target
Alias=src.service
```

# Bash 

## Invoking an ssh command stored in a variable

```bash
local SSH=(ssh root@$TARGET -o ProxyCommand="ssh -W %h:%p -q root@$PROXY" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null)
"${SSH[@]}" "cat /etc/hostname"
```

## Compute how many space some files take

```bash
du -ks $(find -name 'pattern') | awk '{sum+=$1} END {print sum}'
```

# Add a user

```
useradd -m -G  users -s /bin/bash antlord
```


# Add sudo

```
echo 'antlord ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/90-antlord
```

# TAR

## unpack a designated file without parent directories

In this case foo folder is removed so bar.csv is unpacked to the current folder

```
tar xf ./archive.tar --xform='s,foo/bar.csv,bar.csv,' ./foo/bar.csv
```

In this case all parent folders are removed so only bar.csv is unpacked to the current folder

```
tar xf ./archive.tar --xform='s,.*/,,' ./project/data/products.csv
```
