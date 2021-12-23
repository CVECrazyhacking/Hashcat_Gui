#!/bin/bash



clear

trap SIGHUP SIGINT SIGTERM

VERSION="MRX"
NAME="Hashcat Gui:"

# Colores
CIERRE=${CIERRE:-"[0m"}
ROJO=${ROJO:-"[1;31m"}
VERDE=${VERDE:-"[1;32m"}
CYAN=${CYAN:-"[1;36m"}
AMARILLO=${AMARILLO:-"[1;33m"}
BLANCO=${BLANCO:-"[1;37m"}
ROSA=${ROSA:-"[1;35m"}


# Variables Drivers
TEST_DRIVER_NVIDIA=$(lsmod | grep -m1 nvidia | cut -d " " -f1)

##############
# Acerca de: #
##############
INFORMACION(){
echo "$AMARILLO"
echo "MRX"
echo "$BLANCO"
sleep 3
echo "Requisitos minimos:"
echo ""
sleep 2
echo "1: Tener instalado hashcat"
sleep 2
echo "2: Solo se da soporte a graficas NVIDIA"
sleep 2
echo "3: Si tienes dudas escribeme a writehat.es@gmail.com"
echo ""
sleep 3
exit 0
}


############################
# Convierte .cap a .hccapx #
############################
CONVERSOR(){
if ! hash cap2hccapx 2>/dev/null ; then
echo "$ROJO"
echo "No tienes instaladas las hashcat-utils"
echo "$CERRAR"
sleep 3
exit 0
fi
echo "$CYAN"
echo "Escribe la ruta del fichero .cap a convertir y pulsa enter"
echo ""
read FICHEROCAPENTRADA
FICHEROCAP=$(echo "$FICHEROCAPENTRADA" | sed "s/'//g")
if [ "$(echo "$FICHEROCAP"|rev|cut -d . -f-1|rev)" != "cap" ]; then
echo "$ROJO"
echo "ERROR: No has introducido un fichero *.cap"
echo "$CERRAR"
exit 0
fi
cap2hccapx "$FICHEROCAP" "$FICHEROCAP.hccapx"
echo "$VERDE"
echo "Coversion finalizada"
echo "$CERRAR"
sleep 3
exit 0
}


# Si hashcat no esta instalado cerramos
HASHCAT_TEST(){
if ! hash hashcat 2>/dev/null ; then
echo "$ROJO"
echo "Hashcat no esta instalado en el sistema ..."
echo "$CERRAR"
exit 0
fi
}

# Preguntamos por fichero hccapx y diccionario
VARIABLES(){
echo "$AMARILLO"
echo "Introduce la ruta o arrastra el fichero *.hccapx"
echo "$BLANCO"
read FICHEROENTRADA
FICHERO=$(echo "$FICHEROENTRADA"|sed "s/'//g")

if [ "$(echo "$FICHERO"|rev|cut -d . -f-1|rev)" != "hccapx" ]; then
echo "$ROJO"
echo "ERROR: No has introducido un fichero *.hccapx"
echo "$CERRAR"
exit 0
fi
clear

echo "$AMARILLO"
echo "Introduce la ruta o arrastra el fichero de DICCIONARIO"
echo "$BLANCO"
read DICCIONARIOENTRADA
DICCIONARIO=$(echo "$DICCIONARIOENTRADA"|sed "s/'//g")
clear
}

##################
# Ataque hashcat #
##################
HASHCAT(){

# Comprobamos que hashcat esta instalado
HASHCAT_TEST

# Si el driver no esta cargado no se puede lanzar hashcat
if [ -z "$TEST_DRIVER_NVIDIA" ]; then
echo "$ROJO"
echo "No esta instalado el driver NVIDIA ..."
echo "Se lanzara de todas formas ...."
echo "$CERRAR"
sleep 3
fi

VARIABLES
OPTIONS="--force --status -m 2500 -w 4 --logfile-disable --potfile-disable --outfile-format=2 -o /root/Desktop/Cracked_"$(echo "$FICHERO"|sed 's/ /_/g'|rev|cut -d / -f1|rev)".txt"
hashcat $OPTIONS "$FICHERO" "$DICCIONARIO"
}

if [ -z $1 ]; then
  clear
  echo $ROSA
  echo "$NAME $VERSION"
  echo $VERDE
  echo "Se ha ejecutado el script sin parametros"
  echo ""
  echo "Las opciones posibles son: HASHCAT / CONVERSOR / INFORMACION"
  echo $AMARILLO
  echo "Ejemplo:$GREEN "$0" INFORMACION"
  echo $CIERRE
  exit 1
fi

echo  $ROSA
echo "$NAME $VERSION"
echo  $CIERRE

"$@"
