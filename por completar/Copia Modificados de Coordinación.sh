#!/bin/bash
#13 de septiembre de 2010
#Este guión copia los archivos modificados de la última semana de la subcarpeta Coordinación a una carpeta que se especifique en destino, creándola si no existe. Si se quiere cambiar a directorios completos o con direcciones absolutas, cambiar la opción de tipo de f a d y añadir una barra / luego del $2 del awk

#TODO: Seleccionar en función de en qué carpeta se está ejecutando (desde pendrive presentará "media") el destino correspondiente

#Se puede usar `pwd` por la carpeta.
origen=`pwd`
destino=$(zenity --file-selection --directory --title="Seleccione el destino" --text ~/Coordinación)
antiguedad=-8

if [ ! -d "$destino" ]; then mkdir -vp "$destino"; fi

#
origen=~/Coordinación
cd $origen
find "$origen" `pwd` -type f -mtime $antiguedad |awk -FCoordinación ' { print "."$2 } '|  grep -v "#$"|grep -v "~$"|grep -v "\./$"|sort | uniq|sed 's/ /\\ /g'|xargs cp -vur -t /tmp/Coordinación


#Si se quiere copiar con ruta absoluta, usar la siguiente línea
#find `pwd` -type f -mtime -8 |grep "/Coordinación/"|  grep -v "#$"|grep -v "~$"|grep -v "\./$"|sort | uniq|sed 's/ /\\ /g'|xargs cp -vur -t $destino

#Forma simplificada que funcionaría dónde sea, copiando sin ruta:
#find ./ -mtime -7 -type f -exec cp -vur {} -t $destino/ \;

#No usado:
#Obtiene el número de líneas
#n=$(nl /tmp/lista.txt|tail -n 1|awk ' { print $1 } ')
#echo "$n"
#sed '3d' $archivo| xargs -l1 echo

#Antiguo:
#ls -lcR |grep $(date +%Y-%m-%d)|grep -v ^d |  awk ' { print $8 " " $9 " " $10 " "  $11 " " $12 " " $13 " " $14 " " $15 " " $16 " "} '> /tmp/last.txt
