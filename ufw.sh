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

agregar_regla() {
	echo "Ingrese una regla en UFW: "
	read regla
	sudo ufw allow $regla
	echo "Regla nueva en UFW: $regla"
}	
eliminar_regla() {
	echo "Ingrese la regla a eliminar"
	read regla
	sudo ufw delete allow $regla	
	echo "Regla eliminada en UFW: $regla"

}

# # # # # # # # # #                                                                                            # # # # # # # # # #
# Lo que se hizo hasta el momento fue crear las funciones para crear y eliminar reglas de UFW                                    #
# Estas funciones se invocaran dentro de un bucle while arraigadas a una serie de opciones, según lo que quiera hacer el usuario #
# # # # # # # # # #                                                                                            # # # # # # # # # #





# Con la condición while se puede generar un menú para decidir que opción se quiere realizar. 
# Al meterse dentro del bucle, se elije la opción, que va a derivar en una función, que ejecutará el comando de permitir o denegar. La unica manera de salir del bucle es pidiendolo
# con la opción 3

while true; do
	echo "¿Que desea hacer en UFW?"
	echo "1. Agregar una regla"
	echo "2. Eliminar una regla"
	echo "3. Salir"
	echo "Elija una opción: $opcion"
	read opcion

	case $opcion in
		1)
			agregar_regla
			;;
		2)	
			eliminar_regla
			;;
		3)
			echo "Hasta pronto!"
			exit 0
			;;
		*)
			echo "Opción no encontrada. Intentelo de nuevo."
	esac
done


