# IPTABLES

Open 123 port for a local network machine to have a TCP connection

```
iptables -t filter -A INPUT -s 192.168.1.0/24 -p tcp --dport 123 -j ACCEPT
```

## Port forwarding

Port forwarding consists of substitions destination and source. Destination is changed
to redirect a package.  Source is changed in order to prevent the computer behind the firewall send a package
directly to the original source as the original source doesn't know about the computer behind firewall.

```
iptables -t nat -A PREROUTING -i enp0s8 -p tcp --dport 1234 -j DNAT --to-destination 192.168.56.1
iptables -t nat -A POSTROUTING -o enp0s3 -p tcp --dport 1234 -d 192.168.56.1 -j SNAT --to-source 192.168.56.101
```

NOTE: ping doesn't work in the case of traffic passes only for tcp. To ping enable icmp protocol.
NOTE: every network in the example has mask 255.255.255.0

If the port forwarding is used to have a computer works as a router then use

```
----------------      ---------------------------------      ----------------
| LAN computer | ---> |           router              | ---> | WAN computer |
----------------      ---------------------------------      ----------------
                      |   enp0s8    ->     enp0s3     |      | 192.168.56.1 |
                      | 192.168.0.1    192.168.56.101 |      ----------------
                      ---------------------------------


iptables -t nat -A POSTROUTING -o eth0 -j SNAT --to-source <10.0.2.3> # substitude source
```

NOTE: in order to route traffic you need to have properly configure `ip route`

If an IP address of the node the traffic pass through is dynamic then use
```
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
```

Another way to response without substition of source address is

ip r add target via gateway
ip r add 10.31.0.0/16 via 10.33.0.14

Result: you are able do `telnet 192.168.0.1 1234` on the LAN computer

## Traffic forwaring


```
----------------      ---------------------------------      ----------------
| LAN computer | ---> |           router              | ---> | WAN computer |
----------------      ---------------------------------      ----------------
                      |   enp0s8    ->     enp0s3     |      | 192.168.56.1 |
                      | 192.168.0.1    192.168.56.101 |      ----------------
                      ---------------------------------
```

```
iptables -t nat -A POSTROUTING -o enp0s3 -j MASQUERADE
iptables -A FORWARD --in-interface enp0s8 -j ACCEPT
```

Result: you are able do `telnet 192.168.56.1 1234` on the LAN computer

## Debug traffic

```
tcpdump -n -i enp0s3 port 1234
```
