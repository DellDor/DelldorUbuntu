#!/bin/sh
#Ejecuta todos los guiones que se encuentran en la subcarpeta guiones que se ubique dónde esté este mismo archivo. Si sus nombres empiezan con números, se ejecutan en ese estricto orden.
CARPETA=`pwd`
for i in $CARPETA/guiones/*.sh; do
  sudo chmod +x $i
  . $i
done

