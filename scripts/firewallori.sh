#!/bin/bash
echo "Aplicando Reglas de Firewall"

#Hacer de nuestra máquina un router
echo "1" > /proc/sys/net/ipv4/ip_forward

#Limpieza
iptables -F
iptables -X
iptables -Z
iptables -t nat -F
iptables -t nat -X
iptables -t nat -Z

#Establecer politicas por defecto.
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Respuestas para las conexiones establecidas
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

#Permitiendo via localhost hacer cualquier cosa.
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

#Permitiendo paquetes icmp por todas las tarjetas tanto de entrada como de salida.
iptables -A INPUT -p icmp -j ACCEPT
iptables -A OUTPUT -p icmp -j ACCEPT
iptables -A FORWARD -i ens38 -o ens33 -p icmp -j ACCEPT
iptables -A FORWARD -i ens39 -o ens33 -p icmp -j ACCEPT
#iptables -A FORWARD -i ens39 -o ens38 -p icmp -j ACCEPT

iptables -A INPUT -p tcp --dport 3128 -j ACCEPT
iptables -A OUTPUT -p tcp --dport 3128 -j ACCEPT

#Permitiendo las conexiones por ssh
iptables -A INPUT -i ens33 -p tcp --dport 22 -j ACCEPT

iptables -A FORWARD -i ens33 -d 192.168.0.2 -p tcp --dport 22 -j ACCEPT
iptables -A FORWARD -i ens33 -d 192.168.0.3 -p tcp --dport 22 -j ACCEPT

#iptables -A OUTPUT -o ens38 -p tcp --dport 22 -j ACCEPT
#iptables -A OUTPUT -o ens39 -p tcp --dport 22 -j ACCEPT

#Permitiendo las conexiones DHCP por puerto ens38
iptables -A INPUT -i ens38 -p udp -m multiport --dport 67,68 -j ACCEPT
iptables -A OUTPUT -o ens38 -p udp -m multiport --dport 67,68 -j ACCEPT

#Permitiendo las conexiones DHCP por puerto ens39
iptables -A INPUT -i ens39 -p udp -m multiport --dport 67,68 -j ACCEPT
iptables -A OUTPUT -o ens39 -p udp -m multiport --dport 67,68 -j ACCEPT

#Permitiendo UDP
iptables -A INPUT -i ens33 -p udp -m multiport --dport 53,1812 -j ACCEPT
iptables -A OUTPUT -o ens33 -p udp -m multiport --dport 53,33434:33524,1812 -j ACCEPT

iptables -A INPUT -i ens38 -p tcp -m multiport --dport 20,21 -j ACCEPT
iptables -A OUTPUT -o ens38 -p tcp -m multiport --dport 20,21 -j ACCEPT

#Permitiendo TCP
#iptables -A INPUT -i ens33 -p tcp -m multiport --dport 80,443 -j ACCEPT
iptables -A OUTPUT -o ens33 -p tcp -m multiport --dport 80,443 -j ACCEPT


#Enmascarar salida hacia la WAN
iptables -t nat -A POSTROUTING -s 192.168.0.0/24 -o ens33 -j SNAT --to 192.168.3.2
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o ens33 -j SNAT --to 192.168.3.2
#FORWARD de DMZ/WAN. PROTOCOLO TCP/UPD
iptables -A FORWARD -i ens38 -o ens33 -p tcp -m multiport --dport 22,53,80,443,5222,7777,9090,9091 -j ACCEPT
iptables -A FORWARD -i ens38 -o ens33 -p udp -m multiport --dport 53,33434:33524 -j ACCEPT
iptables -A FORWARD -i ens33 -o ens38 -p tcp -m multiport --dport 20,21,22,53,80,443,40000:40100,5222,7777,9090,9091 -j ACCEPT

#FORWARD TCP LAN/WAN
iptables -A FORWARD -i ens39 -o ens33 -p tcp -m multiport --dport 20,21,22,53,80,443,3306 -j ACCEPT

#FORWARD UDP LAN/WAN
iptables -A FORWARD -i ens39 -o ens33 -p udp -m multiport --dport 53,123,3306 -j ACCEPT

#FORWARD LAN/DMZ
iptables -A FORWARD -i ens39 -o ens38 -d 192.168.0.3 -p tcp -m multiport --dport 20,21,22,25,80,443,3306,5222,7777,9090,9091 -j ACCEPT
iptables -A FORWARD -i ens39 -o ens38 -d 192.168.0.2 -p tcp -m multiport --dport 20,21,22,25,80,443,3306,5222,7777,9090,9091 -j ACCEPT

#PREROUTING
iptables -t nat -A PREROUTING -i ens33 -p tcp -m multiport --dport 80,443,9090,9091,5552,7777 -j DNAT --to 192.168.0.3
iptables -t nat -A PREROUTING -i ens33 -p tcp -m multiport --dport 20,21 -j DNAT --to 192.168.0.2
iptables -t nat -A PREROUTING -p tcp --dport 40000:40100 -j DNAT --to 192.168.0.2:40000-40100

#PREROUTING SSH
iptables -t nat -A PREROUTING -p tcp --dport 2202 -i ens33 -j DNAT --to 192.168.0.2:22
iptables -t nat -A PREROUTING -p tcp --dport 2203 -i ens33 -j DNAT --to 192.168.0.3:22


echo "OK. Verifique la configuración de iptables con IPTABLES -L -n"
