#!/bin/bash

#FORWARD TCP/UDP LAN/WAN

for Port in $(cat $Rutadatos/WANPuertosTCP.txt)
do
   iptables -A FORWARD -i $AdaptadorDMZ -o $AdaptadorWAN -p tcp --dport $Port -j ACCEPT 
done

for Port in $(cat $Rutadatos/WANPuertosUDP.txt)
do
   iptables -A FORWARD -i $AdaptadorDMZ -o $AdaptadorWAN -p udp --dport $Port -j ACCEPT 
done

for IP in R2D1 R2D2
do
    iptables -A FORWARD -i $AdaptadorWAN -d $IP -p tcp --dport 22 -j ACCEPT
done

#PREROUTING
for Port in $(cat $Rutadatos/PuertosR2D2.txt)
do
    iptables -t nat -A PREROUTING -i $AdaptadorWAN -p tcp --dport $Port -j DNAT --to $R2D2
done

for Port in $(cat $Rutadatos/PuertosR2D1.txt)
do
    iptables -t nat -A PREROUTING -i $AdaptadorWAN -p tcp --dport $Port -j DNAT --to $R2D1
done

#PREROUTING SSH
for IP in $R2D2 $R2D1
do
    for Port in 2202 2203
    do
        iptables -t nat -A PREROUTING -p tcp --dport $Port -i $AdaptadorWAN -j DNAT --to $IP:22
    done
done

#Permitir ping 
iptables -A FORWARD -i $AdaptadorDMZ -o $AdaptadorWAN -p icmp -j ACCEPT
