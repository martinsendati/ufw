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

#Este comando se traduce como "denegar todo el tráfico entrante por default"
	sudo ufw default deny incoming

echo "Tráfico entrante bloqueado"

echo "[ALLOW] Permitiendo tráfico saliente"

#Este comando se traduce como "permitir el egreso de tráfico por default"
 	sudo ufw default allow outgoing

echo "Tráfico saliente permitido"



### Implementa funciones que permitan al usuario agregar y eliminar reglas en UFW. ###


direccion_ip () {
	echo "Ingrese la Dirección IP: $ip"
        read ip
	echo "Seleccione para que puerto: $puerto"
        echo "Si no es asi presione 0"
        read puerto
        if [ ! $puerto == 0 ]; then
           echo "Permitiendo direccion $ip para puerto $puerto"

       	   sudo ufw allow from $ip to any port $puerto
	
	   echo "Dirección IP permitida"
        else
           echo "Permitiendo direccion $ip"
         
	   sudo ufw allow from $ip
        fi
}

servicio () {
	echo "Ingrese el nombre o numero de puerto del Servicio: $serv"
        read serv
        echo "Habilitando $serv"
        sudo ufw allow $serv
        echo "$serv habilitado!" 
}

puertos () {
cat <<EOF
  Introduzca el rango de puertos a habilitar:
  Desde el puerto: $port
EOF
        read port
	echo "Hasta el puerto: "$port2	
        read port2
cat <<EOF
  Elija para que protocolo:"
  echo "1. TCP"
  echo "2. UDP"
EOF
	read proto

	case $proto in

		1) sudo ufw allow $port:$port2/tcp	
	          
		   echo "Puertos habilitaods para TCP"
		   ;;

  		2) sudo ufw allow $port:$port2/udp
		   
		   echo "Puertos habilitados para UDP"
		   ;;
	esac
}       

eliminar_regla () {
	echo "  Elija la regla a eliminar:"
	sudo ufw status numbered
	echo "  Introducir regla: $regla"
	read regla 

	echo "  Eliminando regla $regla"
	sudo ufw delete $regla

	if [ $regla = true ]; then
		echo "  Regla eliminada con exito!"
	else

	       echo   "  No se a encontrado la regla!"
	fi



}

agregar_regla() {
cat << EOF
  ¿Que regla queres agregar?:
  1. Dirección IP
  2. Nombre o puerto del Servicio
  3. Rango de puertos
EOF
	read opciones

	case $opciones in
		1) 
			direccion_ip
	                ;;
		2)      
			servicio
			;;
		3)
			puertos
			;;
	esac
}

reglas_actuales() {
 cat << EOF
  Asi están las reglas actualmente

EOF
	sudo ufw status verbose
}



while true; do
 cat << EOF
	
  Gestión de reglas
	
  1. Agregar regla
  2. Eliminar regla
  3. Reglas actuales
  4. Salir
EOF
	read opcion

	case $opcion in
	        1)
		    agregar_regla
		    ;;
		2)	
		    eliminar_regla
		    ;;

		3)  reglas_actuales
		    ;;

		4)
		    echo "Hasta pronto!"
		    exit 0
		    ;;
	
		*)
			echo "Opción no encontrada. Intentelo de nuevo."
			;;
	esac
done


