#!/bin/bash

#FORWARD TCP/UDP LAN/WAN
for Port in $(cat $Rutadatos/WANPuertosTCP.txt)
do
   iptables -A FORWARD -i $AdaptadorLAN -o $AdaptadorWAN -p tcp --dport $Port -j ACCEPT 
done
for Port in $(cat $Rutadatos/WANPuertosUDP.txt)
do
   iptables -A FORWARD -i $AdaptadorLAN -o $AdaptadorWAN -p udp --dport $Port -j ACCEPT 
done

#Permitir ping
iptables -A FORWARD -i $AdaptadorLAN -o $AdaptadorWAN -p icmp -j ACCEPT