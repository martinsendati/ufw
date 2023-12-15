#!/bin/bash


# En principio lo que se quiere lograr con estos condicionales es 
# averiguar si existe un archivo, que corresponde a la presencia del servicio ufw dentro del sistema
# En caso de que ese archivo exista, lanzar un mensaje afirmando su existencia
if [ -e /usr/sbin/ufw ]; then
	echo "El firewall está en el sistema"

#En el caso de que no exista, avisar que se procederá a instalar y a continuación proceder a instalar
else 
	echo "El firewall no está en el sistema, procediendo a instalarlo"
       	      sudo apt-get install ufw -y
#Una vez instalado, procede a decir que la instalación fué un exito.
	echo "[OK] El firewall se instaló con exito"
fi
