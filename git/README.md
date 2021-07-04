# Dump commits in CSV.

```
git log --pretty=format:%h,%an,%s --all --since=2020-11-01 --until=2020-11-17 --author=antlord92@gmail.com
```

Details of format are in `git log --help` and find `format:<string>` in the manual page.

# Designate certain SSH identity

```
git config --local core.sshCommand "/usr/bin/ssh -i /home/me/.ssh/id_rsa_foo"
```

```
git clone <address> --config core.sshCommand "/usr/bin/ssh -i /home/me/.ssh/id_rsa_foo"
```
