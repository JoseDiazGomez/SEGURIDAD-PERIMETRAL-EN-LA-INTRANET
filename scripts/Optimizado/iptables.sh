#!/bin/bash

DirectorioIptables="/home/frodo/script"

## Variables generales
. $DirectorioIptables/variables.sh

## Configuración general de iptables
. $DirectorioIptables/general.sh

## Reglas INPUT
. $DirectorioIptables/input.sh

## Reglas OUTPUT
. $DirectorioIptables/output.sh

## Permisos de acceso a WAN
. $DirectorioIptables/wan.sh

## Permisos tanto de WAN como de LAN
. $DirectorioIptables/lanwan.sh

## Permisos de las redes WAN y DMZ
. $DirectorioIptables/wandmz.sh

## Permisos de las redes DMZ y LAN
. $DirectorioIptables/landmz.sh

