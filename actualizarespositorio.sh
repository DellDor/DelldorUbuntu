#!/bin/bash

#25/2/2010
#Guión que actualiza el listador de paquetes de un repositorio local y crea listado de borrables.
#El repositorio tendrá la forma en línea apt-get: deb file:///media/Datos/repositorio ./ #Repositorio Local
#Este guión se ejecutará en la carpeta base del repositorio

#Permite:
#Se generan todos.txt, para no usar directamente Packages, pues puede haber interferencia con las dependencias al emplear grep. Se genera Packages.
#Se genera ultimos.txt, que contiene los nombre de archivos incluidos en Packages
#Se genera borrables.txt: Se toman 1 a 1 los elementos de todos.txt y se buscan en ultimos.txt. Si no está allí, pasa a borrables.
#Se filtra borrable para dejar los archivos de jaunty, la copia del alternativo de karmic, wine, etc.
#Se mueven los borrables a una carpeta de borrables.

#TODO #Añadir a las partes que trabajan con las listas de repositorios: #cat /etc/apt/sources.list |sort|uniq |tee /etc/apt/sources.list
#TODO: añadir: "gksudo :" antes de un comando que necesite sudo, de forma que salga en la pantalla. Se debería poder elegir entre X o no (ver winetrick para ello)
#TODO: Detectar guiones de descarga. Buscar archivos que ya están descargados y sustituirlos en tales guiones. Crear carpeta correspondiente y descaragr faltantes.
#TODO: eliminar archivos linux- antiguos.
#TODO: Revisar los pendientes de Borraviejos.sh
#TODO: Que revise si está instalado dpkg-scanpackages.Si no está proceder con dpkg-multicd que es el más pequeño que lo contiene
#Modificación:
#13/7/2010 toshi


#TODO: Añadir las opciones de emplear este repositorio local, actualizar listado de repositorio, desactivar repos remotos, etc.
#TODO:Buscar como enviar a la papelera que corresponde: en el pendrive o en el disco local. Se puede buscar en el ejemplo de Arch Linux de papelera para LXDE.
#FIXME: Se debe revisar aquellas condiciones que son en cascada, es decir, que si no está seleccionada una previa, no debería poderse ejecutar la que depende de esta.
#TODO: Poner dentro de ciclo que pida salida, para que sea programa auténtico, con pregunta al final de que sí quiere salir o no.
#FIXME: Se pudiera usar mensajes de espera en lugar de los textos.
#TODO: Como opción final se genere de nuevo Packages que incluye todas las posibles versiones (para inlcuir del alternativo)
#FIXME: Se puede eliminar uso de temporales empleando por ejemplo for i in $(ls -l `pwd`/karmic/viejos/*.deb) y pasarlos por grep
#TODO: Si se requiere más espacio, mover lo contenido en la carpeta Karmic a borrables, pues se puede recuperar rápido desde el cd alternativo.
#Última modificación: 5/7/2010

#TODO:Añadir línea para eliminar Cds del repo.
#TODO:Añadir a las partes que trabajan con las listas de repositorios: cat /etc/apt/sources.list |sort|uniq |tee /etc/apt/sources.list


#TEMPORAL="/tmp/$(date | awk '{ print $2$3$6 }')"
#Con segundos: TEMPORAL="/tmp/$(date +%b%d%Y%S)"
TEMPORAL="/tmp/$(date +%b%d%Y)"
LISTAS=`pwd`/listas



TITULO="Manejador de Repositorio Local"
SUPERIOR="DellDor"
ALTO=30
ANCHO=70
ALTOITEMSMENU=13
TIEMPO="0"

if [ ! -d $LISTAS ]; then
echo "Se creará la carpeta de listas"
sudo mkdir -p $LISTAS
sudo chmod a+rw $LISTAS
fi

##################################PRINCIPAL##################################
COMENTARIO="Marque las labores que desea efectuar. Se ejecutan en la secuencia en que están:"
dialog --title "$TITULO" --backtitle "$SUPERIOR" \
--checklist "$COMENTARIO" "$ALTO" "$ANCHO" "$ALTOITEMSMENU" \
      A "Borra listas anteriores y crear nuevas" on \
      B "Mover antiguos a carpeta borrables" on \
      3 "Mover más archivos a borrables (karmic, etc)" off \
      4 "Enviar a la papelera los archivos en borrables" off \
      5 "Desactivar por el momento todos los repositorios" off \
      6 "Eliminar repositorios locales" off \
      7 "Añadir repositorio local (desde dónde se corre esto)" off \
      8	"Añadir disco en unidad al repositorio" off \
      9 "Actualizar (descargar) listados de paquetes" on \
      10 "Activar todos los repositorios" off \
      11 "Actualizar paquetes" on \
      12 "Copiar descargados" on \
      13 "Instalar localepurge gtkorphan deborphan y dpkg-scanpackages" off \
      2>$TEMPORAL

#if [ -n "$(cat $TEMPORAL | grep N)" ]; 
#then
#fi



#SELECCION=$(cat $TEMPORAL) si se quiere usar variable en lugar del archivo

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################

#Si se selecciona 1:Borra listas anteriores y crear nuevas
if [ -n "$(cat $TEMPORAL | grep A)" ]; then
cat $TEMPORAL
COMENTARIO="Se comenzará a generar el archivo de listado. Introduzca la clave si se le pide"
dialog --backtitle "$SUPERIOR" \
--infobox "$COMENTARIO" "$ALTO" "$ANCHO" ; sleep "$TIEMPO"

sudo cp -v Packages* $LISTAS


        if [ -f `pwd`/listas/borrables.txt ]; then
            rm -v `pwd`/listas/borrables.txt
        fi

        if [ -f `pwd`/listas/borrables2.txt ]; then
            rm -v `pwd`/listas/borrables2.txt
        fi

        if [ -f `pwd`/listas/borrables3.txt ]; then
            rm -v `pwd`/listas/borrables3.txt
        fi

        if [ -f `pwd`/listas/todos.txt ]; then
            rm -v `pwd`/listas/todos.txt
        fi

        if [ -f `pwd`/listas/ultimos.txt ]; then
            rm -v `pwd`/listas/ultimos.txt
        fi

        sudo dpkg-scanpackages ./ /dev/null > Packages
#        sudo dpkg-scanpackages -m ./ /dev/null > Packages
        gzip -9c Packages > Packages.gz

COMENTARIO="Se comenzará a generar los listados de borrables"
dialog --title "$TITULO" --backtitle "$SUPERIOR" \
--infobox "$COMENTARIO" "$ALTO" "$ANCHO" ; sleep "$TIEMPO"

#cat $TEMPORAL 
 
#######################ultimos.txt: Todos en sus últimas versiones
cat Packages |grep Filename|awk '{print $2}' |sort > $LISTAS/ultimos.txt
#######################todos.txt: todos los paquetes
find `pwd` | grep .deb | grep -v /listas/ | sort > $LISTAS/todos.txt

echo "Aguarde un momento."
#######################borrables2.txt todos menos ultimos, obteniendo todos los antiguos.
#Se crea borrables2.txt que es sin filtrar
for i in $(cat $LISTAS/todos.txt); do
 if [ `grep -c $(basename $i) $LISTAS/ultimos.txt` = "0" ]; then
  echo $i >> $LISTAS/borrables2.txt
  echo "Revisando $i"
 fi 
done


#######################borrables.txt: deb de borrables2 menos los que estén en /karmic /intrepid /jaunty /wine /otros
#Se genera el de borrables, sacando los de carpetas de alternativos y otras versiones.
cat $LISTAS/borrables2.txt  | grep '.deb$' | grep -v /karmic/ | grep -v /intrepid/ | grep -v /jaunty/ | grep -v /mint/ | grep -v /wine/ | grep -v /otros/> $LISTAS/borrables.txt


#######################borrables3.txt: todos menos ultimos que están en karmic (son borrables si se necesita el espacio)

#Crea el listado de los que vienen del alternativo
cat $LISTAS/borrables2.txt  | grep /karmic/ > $LISTAS/borrables3.txt

fi

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#2 Si se selecciona mover antiguos

if [ -n "$(cat $TEMPORAL | grep B)" ]; 
then
if [ ! -d `pwd`/borrables ]; then sudo mkdir `pwd`/borrables; fi
for i in $(cat  $LISTAS/borrables.txt); do
 sudo mv -v $i `pwd`/borrables
done

fi

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#3 Si se selecciona mover más archivos

if [ -n "$(cat $TEMPORAL | grep 3)" ]; 
then
if [ ! -d `pwd`/borrables ]; then sudo mkdir `pwd`/borrables; fi
for i in $(cat $LISTAS/borrables3.txt); do
 sudo mv $i `pwd`/borrables
done
fi

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#4 Si se selecciona enviar a papelera los archivos desde borrables

#TODO:implementar con backup o algo así. seguir ejemplo de papelera de arch linux para lxde
if [ -n "$(cat $TEMPORAL | grep 4)" ]; 
then
echo "Todavía no se ha implementado borrar los archivos, hágalo manualmente"
fi

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#5: Desactivar por el momento todos los repositorios
if [ -n "$(cat $TEMPORAL | grep 5)" ]; 
then

for i in $(find /etc/apt/ -name '*list'); do
  sudo sed -i 's/\/deb/XXXX/g' $i
  sudo sed -i 's/# deb/#deb/g' $i
  sudo sed -i 's/deb/#deb/g' $i
  sudo sed -i 's/##deb/#deb/g' $i
  sudo sed -i 's/# #deb/#deb/g' $i
  sudo sed -i 's/#deb file/deb file/g' $i
  sudo sed -i 's/XXXX/\/deb/g' $i
 done

fi
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#6: Eliminar repositorios locales actualmente activos
if [ -n "$(cat $TEMPORAL | grep 6)" ]; 
then

sudo rm -v /etc/apt/sources.list.d/local.list
sudo rm -v /etc/apt/sources.list.d/pendrive.list

fi
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#7:Añadir repositorio local (desde dónde se corre esto)
if [ -n "$(cat $TEMPORAL | grep 7)" ]; 
then
cat $TEMPORAL
echo "deb file://`pwd` ./
" | sudo tee -a /etc/apt/sources.list.d/local.list
#con -a para añadir si existe.

fi

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#8:Añadir disco en unidad al repositorio
if [ -n "$(cat $TEMPORAL | grep 8)" ]; 
then
cat $TEMPORAL
#Añadir CD al repo
sudo apt-cdrom add
fi

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
# 9 Actualizar listado de paquetes, aprovechando de buscar e instalar cualquier llave faltante

if [ -n "$(cat $TEMPORAL | grep 9)" ]; 
then
sudo apt-get update 2> /tmp/keymissing; \
for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); do \
  echo -e "Procesando clave: $key"; /
  gpg --keyserver subkeys.pgp.net --recv $key && gpg --export --armor $key | sudo apt-key add -; \
done
fi

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#10 Activar todos los repositorios
if [ -n "$(cat $TEMPORAL | grep 10)" ]; 
then
#Activar todos los repositorios
cat $TEMPORAL
for i in $(find /etc/apt/ -name '*list'); do
  sudo sed -i 's/# deb/#deb/g' $i
  sudo sed -i 's/##deb/#deb/g' $i
  sudo sed -i 's/# #deb/#deb/g' $i
  sudo sed -i 's/#deb file/deb file/g' $i
  sudo sed -i 's/#deb /deb /g' $i
  sudo sed -i 's/get#deb/getdeb/g' $i
 done
fi


####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#11 Actualizar paquetes
if [ -n "$(cat $TEMPORAL | grep 11)" ]; 
then
 sudo aptitude --visual-preview safe-upgrade
fi

####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
#12 Copia descargados

#TODO: Ejecutar la línea de fslint sólo si está instalado
#TODO: Colocar todos los items con el esquema del for y la lista de nombres
#TODO: Cambiar permiso de todos los archivos copiados a usuario convencional con algo como ##sudo chown $DIRE 666
#TODO: Revisar que los directorios existan antes de copiar allí los archivos
#TODO: Definir a través de expresiones regulares grupos completos de tipos de archivos, por ejemplo (openoffice.org-|ttf|uno-|ure). En http://www.zvon.org/other/PerlTutorial/Output_spa/example10.html hay ejemplos de expresiones regulares


if [ -n "$(cat $TEMPORAL | grep 12)" ]; 
then

gksu :

damefile ()
{
if [ ! -d "$1" ]; then sudo mkdir "$1"; fi
for i in $2; do
sudo mv -v ./nuevos/$i* $1
sudo cp -uv /var/cache/apt/archives/$i* $1
done
}

#Copia los archivos cuyo nombres comienzan como lo señalado en LISTA a sus respectivas carpetas.

#Base, independientes del escritorio
LISTA="sudo linux startupmanager dpkg alien debhelper gdm update-manager ifupdown intltool-debian mysql-common nfs ssh system-config html2text libpam libc6 yelp"
DIRE=base
damefile "$DIRE" "$LISTA"

#Biblioteca (distintos paquetes dependen de ellos)
DIRE=biblioteca
LISTA="libgss libgupnp libk tcl8 libsnmp libc6 libpng"
damefile "$DIRE" "$LISTA"

#BKChem: para hacer estructuras químicas exportables a OOo (SVG)
LISTA="bkchem python-pmw python-imaging blt"
DIRE=bkchem
damefile "$DIRE" "$LISTA"


#Burg
LISTA="burg"
DIRE=burg
damefile "$DIRE" "$LISTA"

#Chromium
LISTA="chromium"
DIRE=chromium
damefile "$DIRE" "$LISTA"

#Escaner y OCR
LISTA="sane xsane simple-scan unpaper tesseract ocropus gscan2pdf"
DIRE=escaner
damefile "$DIRE" "$LISTA"

#Evolution
LISTA="evolution python-evolution"
DIRE=evolution
damefile "$DIRE" "$LISTA"

#Fuentes y letras
LISTA="ttf"
DIRE=letras
damefile "$DIRE" "$LISTA"

#Furiusisomount
DIRE=furiusisomount
LISTA="furiusisomount fuseiso"
damefile "$DIRE" "$LISTA"

#Gnome
LISTA="humanity- compiz gcalc human- ubuntu-artwork ubuntu-mono adium-theme light-theme gnome-screensaver gnome-themes python-metacity ubuntu-wallpapers shared-mime"
DIRE=gnome
damefile "$DIRE" "$LISTA"

#Impresoras
LISTA="foomatic openprinting cups hplip libcup hpj"
DIRE=impresoras
damefile "$DIRE" "$LISTA"

#Java
LISTA="openjdk sun-java6 tzdata-java icedtea"
DIRE=java
damefile "$DIRE" "$LISTA"

#Juegos
LISTA="3dchess gnome-games"
DIRE=java
damefile "$DIRE" "$LISTA"

#Ligeros, de LXDE, etc
LISTA="mc pcmanfm"
DIRE=ligeros
damefile "$DIRE" "$LISTA"

#Lenguajes
LISTA="language-pack"
DIRE=lenguajes
damefile "$DIRE" "$LISTA"

#Mensajería y microblogging
DIRE=mensajeria
LISTA="amsn pidgin telepathy libgstfarsight libpurple python-papyon python-farsight python-telepathy turpial finch gwibber"
damefile "$DIRE" "$LISTA"

#Multimedia
DIRE=multimedia
LISTA="gstreamer vlc libnice libvlc ffmpeg mplayer libgstreamer liborc"
damefile "$DIRE" "$LISTA"

#Mozilla
LISTA="firefox thunderbird mozilla adobe-flashplugin adblock flashblock mozget xul mozgest prism ubufox"
DIRE=mozilla
damefile "$DIRE" "$LISTA"

#Openoffice
LISTA="openoffice.org uno- ure libcommons-codec-java libcommons-httpclient-java libcommons-lang-java libcommons-logging-java python-uno"
DIRE=openoffice
damefile "$DIRE" "$LISTA"

#P2P
LISTA="bittornado libtorrent deluge "
DIRE=p2p
damefile "$DIRE" "$LISTA"


#Seamonkey
LISTA="seamonkey"
DIRE=seamonkey
damefile "$DIRE" "$LISTA"

#Tor
LISTA="tor vidalia"
DIRE=tor
damefile "$DIRE" "$LISTA"

#Ubuntu Netbook Remix o Ubuntu Netbook Edition
LISTA="go-home-applet maximus ubuntu-netbook-remix window-picker netbook-launcher libclutk libclutter-gtk libfakekey liblauncher libnetbook-launcher"
DIRE=netbook
damefile "$DIRE" "$LISTA"

#Utilidades
DIRE=utilidades
LISTA="ubuntu-tweak caffeine tucan ailurus grandr kupfer zsync terminator powertop meiga albumshaper"
damefile "$DIRE" "$LISTA"

#Utilidades borrables (no importantes)
DIRE=utilidadesborrables
LISTA="memaker ekiga gears planner netspeed tivion focuswriter"
damefile "$DIRE" "$LISTA"


#Virtualización
DIRE=virtualizacion
LISTA="qemu kqemu aqemu"
damefile "$DIRE" "$LISTA"

#workrave (stop trabajórico)
DIRE=workrave
LISTA="libgdome2-0 libgnet2 libgnome-vfsmm-2 libgnomecanvasmm-2 libgnomemm-2 libgnomeuimm-2 workrave-data workrave"
damefile "$DIRE" "$LISTA"

#Wine
LISTA="wine winbind"
DIRE=wine
damefile "$DIRE" "$LISTA"

#Xorg
LISTA="xserver"
DIRE=xorg
damefile "$DIRE" "$LISTA"

sudo meld ./nuevos/ /var/cache/apt/archives/
#sudo nautilus /var/cache/apt/archives/
#sudo nautilus ./nuevos

#######################################################
#Compara los directorios para posibilitar borrar repetidos
gksudo fslint-gui ./ /var/cache/apt/archives/

#Otra forma que se dejó de usar:
#Virtualización
#if [ ! -d "$DIRE" ]; then sudo mkdir "$DIRE"; fi 
#sudo cp -uv /var/cache/apt/archives/qemu* virtualizacion
#sudo cp -uv /var/cache/apt/archives/kqemu* virtualizacion

fi
####################################################################################################################################
####################################################################################################################################
####################################################################################################################################
COMENTARIO="Realizadas las instrucciones. Pulse Enter para cerrar"
dialog --title "$TITULO" --backtitle "$SUPERIOR" \
--msgbox "$COMENTARIO" "$ALTO" "$ANCHO"
