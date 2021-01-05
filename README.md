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

# IPTABLES

Open 123 port for a local network machine to have a TCP connection

```
iptables -t filter -A INPUT -s 192.168.1.0/24 -p tcp --dport 123 -j ACCEPT
```

Port forwarding consists of substitions destination and source. Destination is changed
to redirect a package.  Source is changed in order to prevent the computer behind the firewall send a package
directly to the original source as the original source doesn't know about the computer behind firewall.

```
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 12345 -j DNAT --to-destination 10.0.0.2 # substitude destination
iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 12345 -d 10.0.0.2 -j SNAT --to-source 10.0.0.1 # substitude source
```

NOTE: ping doesn't work in the case of traffic passes only for tcp. To ping enable icmp protocol.

If the port forwarding is used to have a computer work as a router then use

```
----------------      ---------------------------      ----------------
| LAN computer | ---> |           router        | ---> | WAN computer |
----------------      ---------------------------      ----------------
                      |     eth1    ->   eth0   |
                      | 192.168.0.1    10.0.2.3 |
                      ---------------------------                      


iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source <10.0.2.3> # substitude source
```

NOTE: in order to route traffic you need to have properly configure `ip route`

If an IP address of the node the traffic pass through is dynamic then use
```
iptables -t nat -A POSTROUTING -o eth1 MASQUERADE
```

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

# Regular expressions (regex)

Problem: build regular expression for a binary number multiple of 3.
(https://stackoverflow.com/a/867576)[Here] is a solution with an explanation.
The idea of the problem is drawing the automata and eliminating middle states. 
