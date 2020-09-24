Aplicando Reglas de Firewall
nft flush table ip filter
nft delete chain ip filter (null)
nft nft flush table ip nat
nft delete chain ip nat (null)
nft nft nft nft nft add rule ip filter INPUT ct state related,established  counter accept
nft add rule ip filter OUTPUT ct state related,established  counter accept
nft add rule ip filter FORWARD ct state related,established  counter accept
nft add rule ip filter INPUT iifname lo counter accept
nft add rule ip filter OUTPUT oifname lo counter accept
nft add rule ip filter INPUT ip protocol icmp counter accept
nft add rule ip filter OUTPUT ip protocol icmp counter accept
nft add rule ip filter FORWARD iifname ens38 oifname ens33 ip protocol icmp counter accept
nft add rule ip filter FORWARD iifname ens39 oifname ens33 ip protocol icmp counter accept
nft add rule ip filter INPUT iifname ens33 tcp dport 22 counter accept
nft add rule ip filter FORWARD iifname ens33 ip daddr 192.168.0.2 tcp dport 22 counter accept
nft add rule ip filter FORWARD iifname ens33 ip daddr 192.168.0.3 tcp dport 22 counter accept
nft add rule ip filter INPUT iifname ens38 ip protocol udp udp dport { 67,68} counter accept
nft add rule ip filter INPUT iifname ens39 ip protocol udp udp dport { 67,68} counter accept
nft add rule ip filter INPUT iifname ens33 udp dport 53 counter accept
nft add rule ip filter OUTPUT oifname ens33 udp dport 53 counter accept
nft add rule ip filter INPUT iifname ens38 ip protocol tcp tcp dport { 20,21} counter accept
nft add rule ip filter INPUT iifname ens33 ip protocol tcp tcp dport { 80,443} counter accept
nft add rule ip filter OUTPUT oifname ens33 ip protocol tcp tcp dport { 80,443} counter accept
nft add rule ip nat POSTROUTING oifname ens33 ip saddr 192.168.0.0 counter snat to 192.168.15.19
nft add rule ip nat POSTROUTING oifname ens33 ip saddr 192.168.1.0 counter snat to 192.168.15.19
nft add rule ip filter FORWARD iifname ens38 oifname ens33 ip protocol tcp tcp dport { 22,53,80,443,5222,7777,9090,9091} counter accept
nft add rule ip filter FORWARD iifname ens38 oifname ens33 ip protocol udp udp dport { 53,33434-33524} counter accept
nft add rule ip filter FORWARD iifname ens33 oifname ens38 ip protocol tcp tcp dport { 20,21,22,53,80,443,40000-40100,5222,7777,9090,9091} counter accept
nft add rule ip filter FORWARD iifname ens39 oifname ens33 ip protocol tcp tcp dport { 20,21,22,53,80,443,3306} counter accept
nft add rule ip filter FORWARD iifname ens39 oifname ens33 ip protocol udp udp dport { 53,123,3306} counter accept
nft add rule ip filter FORWARD iifname ens39 oifname ens38 ip protocol tcp ip daddr 192.168.0.3 tcp dport { 20,21,22,25,80,443,3306,5222,7777,9090,9091} counter accept
nft add rule ip filter FORWARD iifname ens39 oifname ens38 ip protocol tcp ip daddr 192.168.0.2 tcp dport { 20,21,22,25,80,443,3306,5222,7777,9090,9091} counter accept
nft add rule ip nat PREROUTING iifname ens33 ip protocol tcp tcp dport { 80,443,9090,9091,5552,7777} counter dnat to 192.168.0.3
nft add rule ip nat PREROUTING iifname ens33 ip protocol tcp tcp dport { 20,21} counter dnat to 192.168.0.2
nft add rule ip nat PREROUTING tcp dport 40000-40100 counter dnat to 192.168.0.2:40000-40100
nft add rule ip nat PREROUTING iifname ens33 tcp dport 2202 counter dnat to 192.168.0.2:22
nft add rule ip nat PREROUTING iifname ens33 tcp dport 2203 counter dnat to 192.168.0.3:22
OK. Verifique la configuración de iptables-translate con IPTABLES -L -n
