#!/bin/bash
#Basado en varios recogidos en la web

OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')
CURKERNEL=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
OLDKERNELS=$(dpkg -l|awk '{print $2}'|grep -E $LINUXPKG |grep -vE $METALINUXPKG|grep -v $CURKERNEL)
YELLOW="\033[1;33m"
RED="\033[0;31m"
ENDCOLOR="\033[0m"

#if [ $USER != root ]; then
#  echo -e $RED"Error: tiene que ser root"
#  echo -e $YELLOW"Saliendo..."$ENDCOLOR
#  exit 0
#fi

#echo -e $YELLOW"Cleaning apt cache..."$ENDCOLOR
#aptitude clean

echo -e $YELLOW"Removing old config files..."$ENDCOLOR
sudo aptitude purge --visual-preview $OLDCONF

echo -e $YELLOW"Removing old kernels..."$ENDCOLOR
sudo aptitude purge --visual-preview $OLDKERNELS

#echo -e $YELLOW"Emptying every trashes..."$ENDCOLOR
#rm -rf /home/*/.local/share/Trash/*/** &> /dev/null
#rm -rf /root/.local/share/Trash/*/** &> /dev/null

echo -e $YELLOW"Guión finalizado"$ENDCOLOR

gksudo gtkorphan &
aptitude
