#!/bin/bash


# Para empezar, lo que hace este comando es averiguar si ufw está instalado en el sistema solicitando la exist# encia de su archivo
if [ -e /usr/sbin/ufw ]; then
	cat <<EOF

Bienvenido! 

El firewall está en el sistema!
EOF

else    
	cat << EOF
El firewall no está en el sistema, procediendo a instalarlo
$(sudo apt-get install ufw -y)

#Una vez instalado, procede a decir que la instalación fué un exito.
	[OK] El firewall se instaló con exito
EOF

fi

cat <<EOF

 Habilitando firewall UFW

->  $(sudo ufw enable)

 [OK] Firewall habilitado!
EOF
cat <<EOF

 [INCOMING] Denegando tráfico entrante

-> $(sudo ufw default deny incoming)

 Tráfico entrante bloqueado!
EOF
cat << EOF 

 [ALLOW] Permitiendo tráfico saliente

-> $(sudo ufw default allow outgoing)

 Tráfico saliente permitido!
EOF

### FUNCIONES ###

#Se solicita al usuario que agregue una direccion ip
direccion_ip () {
	echo "Ingrese la Dirección IP: $ip"
        read ip
#En caso de configurar la ip para algun puerto, agregarlo. De no ser asi colocar 0
	echo "Agregar puerto: Presione 0 en el caso de no elegir puerto" $port
        read port
#Entonces, si se colocó algún puerto, saldrá un comando para configurar la IP en dicho puerto, sino solo confugurar la IP
	if [ ! $port == 0 ]; then
           echo "Habilitando Dirección IP"

       	   sudo ufw allow from $ip to any port $port  || sudo ufw allow from $ip
	
	   echo "Dirección IP habilitada"

#En el caso que la IP no sea real, vuelve a ejecutar el comando que corresponda y el mensaje de error lo concatena a un archivo de texto que guardará el error generado hasta el proximo error.
   else 
           echo "La dirección IP: $ip no es valida"

             sudo ufw allow from $ip to any port $port 2> errores_ip.txt || sudo ufw allow from $ip 2> errores_ip.txt 
	     cat <<EOF
Hubo un error en la dirección ip o en el puerto, intente nuevamente
EOF
	     
	     echo "Se ha hecho registro del error en el archivo errores.txt"

	   fi

}

#En el caso del servicio lo mismo. Se ingresa un servicio por su nombre (SSH) o por su puerto (22)
servicio () {
	echo "Ingrese el nombre o numero de puerto del Servicio: $serv"
        read serv
        echo "Habilitando $serv"

#Si el servicio existe, lo habilita
	if [ $serv = true ]; then
        sudo ufw allow $serv 
        echo "$serv habilitado!"

#En caso que asi no sea, concatenará el error dentro de un archivo indicando cual es. De paso se aclara que el pedido no se pudo realizar.
        else 
		echo "El servicio no existe!"
		sudo ufw allow $serv 2> errores_servicio.txt
		cat <<EOF
Hubo un error en el nombre o numero de servicio, intente nuevamente
EOF
		echo "Se ha hecho registro del error en el archivo errores_servicios.txt"

	fi	


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
  1. TCP
  2. UDP
EOF
	read proto

	case $proto in

		1) sudo ufw allow $port:$port2/tcp	
if [[ $port =~ ^[0-9]+$ && $port -ge 0 && $port -le 65535 ]] && [[ $port2 =~ ^[0-9]+$ && $port2 -gt $port ]]; then
		   
       	echo "Puertos habilitaods para TCP"
        else
		   sudo ufw allow $port:$port2/tcp 2> errores_puertos_tcp.txt

		   echo "No existen o no es posible configrar esos puertos!"

cat <<EOF
Hubo un error en uno o ambos puertos ingresados, intente nuevamente
EOF
                echo "Se ha hecho registro del error en el archivo errores_puertos_tcp.txt"

	       fi
		   ;;

  		2) 
		   sudo ufw allow $port:$port2/udp
               if [[ $port =~ ^[0-9]+$ && $port -ge 0 && $port -le 65535 ]] && [[ $port2 =~ ^[0-9]+$ && $port2 -gt $port ]]; then

                   echo "Puertos habilitados para UDP"
           else
                   echo "No existen o no es posible configrar esos puertos!"

                sudo ufw allow $port:$port2/udp 2> errores_puertos_udp.txt

                cat <<EOF
Hubo un error en uno o ambos puertos ingresados, intente nuevamente
EOF
                echo "Se ha hecho registro del error en el archivo errores_puertos_udp.txt"

               fi
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
		echo "Regla eliminada con exito!"
	else

	       echo "No se a encontrado la regla!"
	fi



}

agregar_regla() {
cat << EOF
  ¿Que regla queres agregar?:
  1. Dirección IP
  2. Nombre o puerto del Servicio
  3. Rango de puertos
  4. Salir
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
		4)      exit
			;;

		*)      echo "Elija una opción valida"


	esac
}

reglas_actuales() {
 cat << EOF
  Asi están las reglas actualmente

EOF
	sudo ufw status verbose
}


reglas() {
	echo " "
	echo "Elija la regla para verla por archivo de texto"
	echo " "
	 cat << EOF
	$(sudo ufw status verbose && sudo sudo ufw status verbose > reglas.txt)
EOF
	echo "Tambien podes ver esto en el archivo reglas.txt"

}

while true; do
 cat << EOF
	
  Gestión de reglas
	
  1. Agregar regla
  2. Eliminar regla
  3. Reglas actuales
  4. Lea las reglas en archivo de texto
  5. Salir
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

		4) reglas
		   ;;

		5)
		    echo "Hasta pronto!"
		    exit 0
		    ;;
	
		*)
			echo "Opción no encontrada. Intentelo de nuevo."
			;;
	esac
done


