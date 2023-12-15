#!/bin/bash


### Crea un script de bash que verifique si UFW está instalado en el sistema. Si no lo está, instálalo ###


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

###  Habilita UFW y configúralo para que deniegue todo el tráfico de entrada y permita todo el tráfico de salida. ###

#Habilitando UFW

echo "Habilitando firewall UFW"

sudo ufw enable

echo "[OK] Firewall habilitado"

# Denegando el tráfico entrante
## Estos comandos lo que haces es configurar el archivo de configuracion por default de UFW
# /etc/default/ufw

echo "[INCOMING] Denegando tráfico entrante"

	sudo ufw default deny incoming

echo "Tráfico entrante bloqueado"

echo "[ALLOW] Permitiendo tráfico saliente"
	
 	sudo ufw default allow outgoing

echo "Tráfico saliente permitido"




