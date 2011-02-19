#!/bin/bash
alias its='sudo aptitude install --visual-preview -R'
alias itc='sudo aptitude install --visual-preview -r'
alias its2='sudo aptitude install -R'
alias itc2='sudo aptitude install -r'
alias a2='aptitude'
alias act='sudo apt-get update'
alias act2='sudo aptitude safe-upgrade --visual-preview'
alias act3='act; act2'
alias bo='sudo aptitude remove --purge --visual-preview'
alias descargapaquetes='sudo apt-get install -dy --install-recommends'
alias descargaaxel3='axel -an3'
alias go='gnome-open'

alias suspende='sudo pm-suspend'

actualizaburg() {
sudo update-burg && sudo sed -i 's/sda3 ro/sda9 ro nomodeset/g' /boot/burg/burg.cfg
}

alias música='gvfs-mount -d /dev/sda6; vlc -Z /media/Archivo/Música\ Instrumental/ &'

alias pcg='ping -c 3 www.ubuntu.com' 

alias aliasedita='sudo gedit ~/.bash_aliases && echo "Ejecutando exec bash" && exec bash'

alias meldcoordinacion='zenity --title "Último comparado" --info --text "La última vez se comparó con $(cat /media/DellDor/último.txt)" && echo "$HOSTNAME" > /media/DellDor/último.txt && meld /media/DellDor/Coordinación /home/dd/Coordinación'

alias rcoo='rednotebook /home/dd/Coordinación/RedNoteBook/ &'
alias rl='rednotebook ~/LogMini/ &'

alias borravacios='find . -empty -exec rm -vri {} \;'

act4() {
act
cd ~/Borrable/paquetes/; sudo apt-get upgrade -y --print-uris | egrep -o -e "(ht|f)tp://[^\']+" |xargs -l1 sudo axel -an 3
sudo mv -vu ~/Borrable/paquetes/*.deb /var/cache/apt/archives/
act2
}

busca () {
find "`pwd`" -iname "*$1*"
}

subusca () {
sudo find "`pwd`" -iname "*$1*"
}

busca2 () {
echo "find \"`pwd`\" -iname \"*$1*\""
}


buscadir () {
find "`pwd`" -type d -iname "*$1*"
}

buscaborra () {
echo "find \"`pwd`\" -type f -iname \"*$1*\" -exec mv -v {} ~/.local/share/Trash/files/ \;"
}

buscaborradir () {
echo "find \"`pwd`\" -type d -iname \"*$1*\" -exec mv -v {} ~/.local/share/Trash/files/ \;"
}


limpialistasrepo() {
#Elimina repositorios que no funcionen. Luego actualiza y completa claves. Servidores posibles=keyserver.ubuntu.com subkeys.pgp.net
sudo apt-get update 2> /tmp/borra | grep obtener |awk  ' { print $4 } ' | awk -F/ ' { print $4 } '> /tmp/borra2
for i in $(cat /tmp/borra2); do
sudo rm -rv $(find /etc/apt/sources.list.d/$i*)
cat /etc/apt/sources.list | grep -v $i > /tmp/a.list
cat /tmp/a.list | sudo tee /etc/apt/sources.list
done

sudo apt-get update 2> /tmp/borra | grep obtener |awk  ' { print $4 } ' | awk -F/ ' { print $4 } '> /tmp/borra2
for i in $(cat /tmp/borra2); do
sudo rm -rv $(find /etc/apt/sources.list.d/$i*); done

cat /tmp/borra | grep "GPG" > /tmp/borra2
cosa=$(cat /tmp/borra2);

if [ "x$cosa" != "x" ]; then
sudo apt-get update 2> /tmp/keymissing
for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); do
echo -e "Procesando clave: $key"; gpg --keyserver keyserver.ubuntu.com --recv $key && gpg --export --armor $key | sudo apt-key add -
done

sudo apt-get update 2> /tmp/keymissing
for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); do
echo -e "Procesando clave: $key"; gpg --keyserver subkeys.pgp.net --recv $key && gpg --export --armor $key | sudo apt-key add -
done
fi
}

apt-fast() {
[ "`whoami`" = root ] || exec sudo :

if echo "$@" | grep -q "upgrade\|install\|dist-upgrade"; then
  echo "Trabajando...";

  # Go into the directory apt-get normally puts downloaded packages
  cd /var/cache/apt/archives/;

  # Have apt-get print the information, including the URI's to the packages
  # Strip out the URI's, and download the packages with Axel for speediness
  # I found this regex elsewhere, showing how to manually strip package URI's you may need...thanks to whoever wrote it
  apt-get install -y --print-uris "$@" | egrep -o -e "(ht|f)tp://[^\']+" |xargs -l1 sudo axel -an 4

  # Perform the user's requested action via apt-get
  aptitude --visual-preview $@;

  echo -e "¡Listo!";

else
   aptitude $@;
fi
}


instalawifi() {
find ~/ -iname "r8101*" -exec cp -vu {} /tmp/ \;
tar -xjvf $(find /tmp -iname "r8101*") -C /tmp
cd $(find /tmp -iname "r8101*" -type d)

sudo -E make clean modules
sudo make install
sudo modprobe r8101
sudo depmod -a
sudo update-initramfs -u
if [ "x" = "x$(cat /etc/modules|grep r8101)" ]; then
echo "r8101" | sudo tee -a /etc/modules
fi
return 0
}

limpiakernel () {
#Instala driver de net en actual y borra anteriores
echo "Este comando completa la instalación de la última versión del kernel,
instalando el driver de la tarjeta de red y elimina los kernels antiguos,
por lo que es necesario que se tenga conexión de internet para ejecutarlo.
Si es así, pulse Enter, sino Ctrl+C

REVISAR SI SE ESTÁ CORRIENDO DESDE EL KERNEL NUEVO PARA ELIMINAR ANTERIORES"
read A

OLDCONF=$(dpkg -l|grep "^rc"|awk '{print $2}')
CURKERNEL=$(uname -r|sed 's/-*[a-z]//g'|sed 's/-386//g')
LINUXPKG="linux-(image|headers|ubuntu-modules|restricted-modules)"
METALINUXPKG="linux-(image|headers|restricted-modules)-(generic|i386|server|common|rt|xen)"
OLDKERNELS=$(dpkg -l|awk '{print $2}'|grep -E $LINUXPKG |grep -vE $METALINUXPKG|grep -v $CURKERNEL)

#Se instala lo requerido para compilar el driver
sudo aptitude keep-all
sudo aptitude install -r --visual-preview linux-backports-modules-wireless-lucid-generic linux-headers-$(uname -r) linux-headers-generic linux-image-generic linux-generic linux-firmware build-essential
sudo aptitude purge --visual-preview $OLDCONF $OLDKERNELS

#TODO: que se elimine los archivos antiguos del kernel. Se puede hacer buscando en /lib/modules/ los archivos que no correspondan a CURKERNEL (con ls -1 y grep -v) y borrarlos con xargs.
echo "Falta por borrar los antiguos en la carpeta /lib/modules/. Pulse Enter para abrirla"
read A
sudo nautilus /lib/modules/
instalawifi
sudo update-burg
cd `disrname $0`
}


descargapaq()
{
#Busca si está el archivo y si no está, lo descarga
#carpeta=/tmp/$(uuidgen)
carpeta=/tmp/$(uname -a| awk ' { print $2$7$8$11 } ')
mkdir -p $carpeta
#partes=$( zenity --title "Elige partes" --scale --text "Elige cantidad de partes en que se quiere descargar" --value "3" --min-value "1" --max-value "7")
partes=`dialog --inputbox "Número de descargas" 10 50 3 --stdout`

archivo=$carpeta/$(uuidgen).txt
archivo2=$carpeta/$(uuidgen).txt


case "$@" in
actualiza)
echo "Se comienza la descargas de paquetes a actualizar"
#sudo apt-get -dy --print-uris upgrade | egrep -o -e "(ht|f)tp://[^\']+" > $archivo
sudo apt-get -dy --print-uris install $(sudo aptitude safe-upgrade -fy --simulate --allow-untrusted| awk '/los siguientes/,/paquetes actualizados/'| grep -v actualizarán|grep -v instalarán| grep -v "sin actualizar"|grep -v eliminarán |grep -v ELIMINARÁN |sed 's/{a}//g'|sed 's/{u}//g'|sed 's/\ \ /*/g'|tr -d '*'|tr '\n' ' ') | egrep -o -e "(ht|f)tp://[^\']+" > $archivo
;;
*)
echo "Se comienza la descarga y movilización de paquetes a instalar"
sudo apt-get -dy --print-uris install $@ | egrep -o -e "(ht|f)tp://[^\']+" > $archivo
;;
esac

cat $archivo|xargs -l1 basename > $archivo2

for i in $(cat $archivo2); do
 if [ "x`ls /var/cache/apt/archives/|grep $i`" = "x" ]; then
  echo "Se descarga el archivo $i"
  axel -an $partes $(cat $archivo|grep $i) -o "$carpeta/" && sudo mv -vu "$carpeta/$i" /var/cache/apt/archives
else
echo "El archivo $i ya se encuentra en /var/cache/apt/archives/
Se continúa con el próximo"
fi
done

if echo "$@" | grep -q "actualiza"; then
sudo aptitude safe-upgrade --visual-preview
echo "Si se actualizó algún elemento de linux, recuerda ejecutar limpiakernel"
else
sudo aptitude install --visual-preview "$@"   
fi


if dialog --yesno "¿Borrar la carpeta temporal dónde se descargaron los archivos?" 0 0 ; then 
sudo rm -r "$carpeta"
fi
}



instalaopenoffice ()
{
#echo "deb http://ve.archive.ubuntu.com/ubuntu/ $(lsb_release -cs)-proposed restricted main multiverse universe" | sudo tee /etc/apt/sources.list.d/propuestos$(lsb_release -cs).list
#sudo aptitude update
#sudo aptitude install --visual-preview -r \
#sudo aptitude install -r \
descargapaq \
openoffice.org-java-common openoffice.org-base  \
openoffice.org-calc openoffice.org-draw openoffice.org-gtk openoffice.org-impress openoffice.org-math \
openoffice.org-writer openoffice.org-common python-uno uno-libs3 ure \
openoffice.org-style-human \
openoffice.org-help-es openoffice.org-l10n-es openoffice.org-hyphenation \
ttf-liberation ttf-dejavu-extra ttf-freefont ttf-opensymbol \
ooo-thumbnailer
#openoffice.org-wiki-publisher openoffice.org-emailmerge
#ttf-symbol-replacement

sudo sed -i 's/deb/#deb/g' /etc/apt/sources.list.d/propuestos$(lsb_release -cs).list; sudo apt-get update

#sudo rm /etc/apt/sources.list.d/propuestos$(lsb_release -cs).list

#sudo grep -v  "proposed" /etc/apt/sources.list > /tmp/a.txt
#cat /tmp/a.txt | sudo tee /etc/apt/sources.list
}

clima()
{
carpeta=/tmp/clima$(date +%H%M)
mkdir -p $carpeta
axel -an 3 http://images.intellicast.com/WxImages/SatelliteLoop/hicbsat_None_anim.gif -o $carpeta
axel -an 3 http://sirocco.accuweather.com/sat_mosaic_640x480_public/ei/isaehatl.gif -o $carpeta
axel -an 3 http://sirocco.accuweather.com/sat_mosaic_400x300_public/IR/isacar.gif -o $carpeta
axel -an 3 http://www.inameh.gob.ve/radares/VenMax.gif -o $carpeta
axel -an 3 http://www.inameh.gob.ve/radares/JerembaMax.gif -o $carpeta

#if dialog --yesno "¿Copiar archivos a ~/Borrable/clima?" 0 0 ; then 
mkdir -p ~/Borrable/clima
cp -vu $carpeta/*.gif ~/Borrable/clima
#fi
eog $carpeta/*.gif
}
