
for IP in $R2D2 $R2D1
do
    for Port in $(cat $Rutadatos/DMZPuertosTCP.txt)
    do
        iptables -A FORWARD -i $AdaptadorLAN -o $AdaptadorDMZ -d $IP -p tcp --dport $Port -j ACCEPT
    done
done

