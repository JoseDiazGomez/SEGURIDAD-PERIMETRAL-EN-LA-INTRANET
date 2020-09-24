#!/bin/bash

# Enmascarar salida hacia WAN
for Network in $NetworkLAN $NetworkDMZ
do
    iptables -t nat -A POSTROUTING -s $Network -o $AdaptadorWAN -j SNAT --to $Public
done
