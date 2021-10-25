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
tcpdump -i <interface> -s 65535 -w <some-file>
```

Befores expected rule put

```
iptables <proper options> -j LOG --log-level info
```

than see `/var/log/kern.log`

## Reaching a computer from its neighbour by its external address.

A router has two public IP addresses. Each one dedicated to respective internal
workstation. If workstation 1 sends a package to workstation 2 by its public
address then the package is dropped at their router as the router is an actual
receiver of the package as the address is bound to its network interface.

To prevent the dropping change desitination address of a package at the router
which is the public address by the internal address of the workstation 2. Then
workstation 2 receives a package and sends a package in response. Destination
of the is internal address of workstation 1. The package is sent directly as
the workstations are in the same network so the source of the package is
internal address which was substituded at the router. Workstation 1 drops the
package as it doesn't wait a package from the internal address of workstation 2.

To prevent the dropping workstation 2 should send a package back to the router.
That means that source of the package should be changed as well to the public
address of workstation 1. A package is sent to the router then it is sent to
workstation 1.

Scheme is [here](./inner_by_outer_ip.dot)

NOTE: this is an adhoc solution. Such problem should be resolved with routing
policies (ip rule)

Router iptables:

```
# usual NAT to forward packages from public network to a certain machine
iptables -t nat -A PREROUTING -i eth1 -j DNAT --destination=5.9.5.2 --dport=80 --to-destination=10.32.0.2
iptables -t nat -A PREROUTING -i eth1 -j DNAT --destination=5.9.5.1 --dport=80 --to-destination=10.32.0.1
iptables -t nat -A POSTROUTING -o eth1 -j SNAT --source=10.32.0.1 --to-source=5.9.5.1
iptables -t nat -A POSTROUTING -o eth1 -j SNAT --source=10.32.0.2 --to-source=5.9.5.2

# internal communications
iptables -t nat -A PREROUTING -i eth0 -j DNAT --destination=5.9.5.1 --dport=80 --to-destination=10.32.0.1
iptables -t nat -A PREROUTING -i eth0 -j DNAT --destination=5.9.5.2 --dport=80 --to-destination=10.32.0.2
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --source=10.32.0.1 --to-source=5.9.5.1
iptables -t nat -A POSTROUTING -o eth0 -j SNAT --source=10.32.0.2 --to-source=5.9.5.2
```

## Tools to monitor traffic

- iptraf-ng
- nethogs
- iftop
