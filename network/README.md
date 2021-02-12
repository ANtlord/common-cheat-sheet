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
iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 12345 -j DNAT --to-destination 10.0.0.2 # substitude destination
iptables -t nat -A POSTROUTING -o eth1 -p tcp --dport 12345 -d 10.0.0.2 -j SNAT --to-source 10.0.0.1 # substitude source
```

NOTE: ping doesn't work in the case of traffic passes only for tcp. To ping enable icmp protocol.

If the port forwarding is used to have a computer works as a router then use

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
iptables -t nat -A POSTROUTING -o eth1 -j MASQUERADE
```

Another way to response without substition of source address is

ip r add target via gateway
ip r add 10.31.0.0/16 via 10.33.0.14

## Traffic forwaring


```
----------------      ---------------------------      ----------------
| LAN computer | ---> |           router        | ---> | WAN computer |
----------------      ---------------------------      ----------------
                      |   enp0s8    ->  enp0s9  |
                      | 192.168.0.1    10.0.2.3 |
                      ---------------------------                      
```

```
iptables -t nat -A POSTROUTING --out-interface enp0s9 -j MASQUERADE
iptables -A FORWARD --in-interface enp0s8 -j ACCEPT
```

## Debug traffic

```
tcpdump -n -i enp0s3 port 1234
```
