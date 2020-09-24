#!/bin/bash

#Permitiendo las conexiones OUTPUT de DHCP por los puerto ens38 y 39
for Interface in $AdaptadorDMZ $AdaptadorLAN
do
    for Port in 67 68
    do
        iptables -A INPUT -i $Interface -p udp --dport $Port -j ACCEPT
    done 
done

for Port in 21 20
do
    iptables -A INPUT -i $AdaptadorDMZ -p tcp --dport $Port -j ACCEPT
done

for Port in 80 443 22
do
    iptables -A INPUT -i $AdaptadorWAN -p tcp --dport $Port -j ACCEPT
done

#Permitir DNS
iptables -A INPUT -i $AdaptadorWAN -p udp --dport 53 -j ACCEPT

#Permitir ping
iptables -A INPUT -p icmp -j ACCEPT

#Permitir localhost
iptables -A INPUT -i lo -j ACCEPT