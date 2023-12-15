#!/bin/bash

if [ -e /usr/sbin/ufw ]; then
	echo "El firewall está en el sistema"
else 
	echo "El firewall no está en el sistema, procediendo a instalarlo"
       	      sudo apt-get install ufw -y
	echo "[OK] El firewall se instaló con exito"
fi	
