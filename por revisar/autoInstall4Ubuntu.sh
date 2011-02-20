#!/bin/bash
#Auto-install4Ubuntu (ai4u)
#############################################################################################
#############################################################################################
# LICENCIA DE USO
#############################################################################################
#
#          
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see «http://www.gnu.org/licenses/».

function Instalando(){

zenity --title="Auto-install4Ubuntu" --question --text="Se ha terminado de tomar datos.\n¿Desea comenzar a descargar e instalar los programas seleccionados?"
if [ $? != 0 ]; then exit 0; fi

gksu date

#TESTMODE
#echo \###########################; echo $@; exit 0

#REPOSITORIO Medibuntu
if [ $medibuntu = "on" ]; then gksu "wget http://www.medibuntu.org/sources.list.d/$codename.list --output-document=/etc/apt/sources.list.d/medibuntu.list"
gksu aptitude update | tee >(zenity --progress --pulsate --auto-close --text="Se esta añadiendo el repositorio de Medibuntu..." --title="Auto-install4Ubuntu")
gksu "aptitude -y --allow-untrusted install medibuntu-keyring" | tee >(zenity --progress --pulsate --auto-close --text="Se esta añadiendo el repositorio de Medibuntu..." --title="Auto-install4Ubuntu")
fi

#REPOSITORIO Bisigi
if [ $package33 = "on" ] && [ "$karmico" = "on" ]; then gksu add-apt-repository ppa:bisigi | tee >(zenity --progress --pulsate --auto-close --text="Se esta añadiendo el repositorio del proyecto Bisigi..." --title="Auto-install4Ubuntu"); fi

#REPOSITORIO Lemur-search
if [ $package17 = "on" ] && [ "$karmico" = "on" ]; then gksu add-apt-repository ppa:lemur | tee >(zenity --progress --pulsate --auto-close --text="Se esta añadiendo el repositorio del proyecto Lemur-search..." --title="Auto-install4Ubuntu"); fi

#REPOSITORIO Chromium
if [ $package39 = "on" ] && [ "$karmico" = "on" ]; then gksu add-apt-repository ppa:chromium-daily | tee >(zenity --progress --pulsate --auto-close --text="Se esta añadiendo el repositorio de Chromium..." --title="Auto-install4Ubuntu"); fi

#REPOSITORIO VBox 3.0
vboxrep=`cat /etc/apt/sources.list | grep "deb http://download.virtualbox.org/virtualbox/debian $codename non-free"`
if [ "$package42" = "on" ] && [ "x$vboxrep" != "x" ]; then lsb_release -c | awk '{print $2}' > /tmp/codename; gksu cat /tmp/codename; sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian `cat /tmp/codename` non-free" >> /etc/apt/sources.list' && wget http://download.virtualbox.org/virtualbox/debian/sun_vbox.asc -O- | sudo apt-key add - | tee >(zenity --progress --pulsate --auto-close --text="Se esta añadiendo el repositorio de SUN Virtual Box..." --title="Auto-install4Ubuntu"); rm /tmp/codename; fi

#UPDATE
gksu aptitude update | tee >(zenity --progress --pulsate --auto-close --text="Se esta actualizando la lista de paquetes..." --title="Auto-install4Ubuntu")

#INSTALAR Multimedia
if [ "$package1" = "on" ]; then apturl apt://ubuntu-restricted-extras; fi

if [ "$package1" = "on" ] && [ $arch = "x86_64" ]; then wget http://download.macromedia.com/pub/labs/flashplayer10/libflashplayer-10.0.32.18.linux-x86_64.so.tar.gz | tee >(zenity --progress --pulsate --text="Se esta instalando el plugin flash de 64 Bits" --title="Auto-install4Ubuntu")
gksu "aptitude -y purge flashplugin-installer flashplayer-mozilla flashplugin-nonfree" | tee >(zenity --progress --pulsate --text="Se esta instalando el plugin flash de 64 Bits" --title="Auto-install4Ubuntu")
tar -xvf libflashplayer-10.0.32.18.linux-x86_64.so.tar.gz && rm libflashplayer-10.0.32.18.linux-x86_64.so.tar.gz && gksu mv libflashplayer.so /usr/lib/mozilla/plugins/libflashplayer.so
fi

if [ "$package2" = "on" ]; then apturl apt://vlc,mozilla-plugin-vlc; fi
if [ "$package3" = "on" ]; then apturl apt://smplayer; fi
if [ "$package4" = "on" ]; then apturl apt://exaile; fi
if [ "$package5" = "on" ]; then apturl apt://banshee; fi
if [ "$package6" = "on" ]; then apturl apt://cheese; fi
if [ "$package7" = "on" ]; then echo AcetoneISO no disponible por el momento; fi #AcetoneISO
if [ "$package8" = "on" ]; then apturl apt://comix; fi
if [ "$package9" = "on" ]; then apturl apt://moovida; fi
if [ "$package10" = "on" ]; then apturl apt://xfce4-mixer; fi

#INSTALAR Medibuntu
if [ "$package11" = "on" ]; then apturl apt://libdvdcss2; fi
if [ "$package12" = "on" ] && [ $arch = "x86_64" ]; then apturl apt://w64codecs
elif [ "$package12" = "on" ] && [ $arch != "x86_64" ]; then apturl apt://w32codecs; fi
if [ "$package13" = "on" ]; then apturl apt://skype; fi

#INSTALAR Escritorio
if [ "$package14" = "on" ]; then apturl apt://avant-window-navigator; fi
if [ "$package15" = "on" ]; then apturl apt://gnome-do; fi
if [ "$package16" = "on" ]; then apturl apt://screenlets; fi
if [ "$package17" = "on" ] && [ "$karmico" = "on" ]; then apturl apt://lemur-search; fi

#INSTALAR Internet
if [ "$package18" = "on" ]; then echo JDownloader no disponible por el momento; fi #JDownloader
if [ "$package19" = "on" ]; then apturl apt://tucan; fi
if [ "$package20" = "on" ]; then apturl apt://amule; fi
if [ "$package21" = "on" ]; then apturl apt://deluge; fi
if [ "$package22" = "on" ]; then echo Opera no disponible por el momento; fi #Opera
if [ "$package23" = "on" ]; then apturl apt://thunderbird; fi

#INSTALAR Mensajeria
if [ "$package24" = "on" ]; then apturl apt://amsn; fi
if [ "$package25" = "on" ]; then apturl apt://emesene; fi
if [ "$package26" = "on" ]; then apturl apt://pidgin; fi
if [ "$package27" = "on" ]; then apturl apt://xchat; fi

#INSTALAR Compatibilidad
if [ "$package28" = "on" ]; then apturl apt://unrar,rar,p7zip-full,unace,unzip; fi
if [ "$package29" = "on" ]; then apturl apt://sun-java6-fonts,sun-java6-jre,sun-java6-plugin; fi
if [ "$package30" = "on" ]; then apturl apt://wine; fi
if [ "$package31" = "on" ]; then apturl apt://playonlinux; fi

#INSTALAR Apariencia
if [ "$package32" = "on" ]; then apturl apt://compizconfig-settings-manager,emerald,fusion-icon; fi
if [ "$package33" = "on" ] && [ "$karmico" = "on" ]; then apturl apt://zgegblog-themes; fi

#INSTALAR Diseño
if [ "$package34" = "on" ]; then apturl apt://inkscape; fi
if [ "$package35" = "on" ]; then apturl apt://screem; fi
if [ "$package36" = "on" ]; then apturl apt://scribus; fi
if [ "$package37" = "on" ]; then apturl apt://shutter; fi

#INSTALAR Avanzadas
if [ "$package38" = "on" ]; then apturl apt://build-essential; fi
if [ "$package39" = "on" ] && [ "$karmico" = "on" ]; then apturl apt://chromium-browser,chromium-browser-l10n,chromium-codecs-ffmpeg-nonfree,chromium-codecs-ffmpeg; fi
if [ "$package40" = "on" ]; then apturl apt://eclipse; fi
if [ "$package41" = "on" ]; then apturl apt://netbeans; fi

#INSTALAR VBox
if [ "$package42" = "on" ]; then apturl apt://virtualbox-ose; fi
if [ "$package43" = "on" ]; then apturl apt://virtualbox-3.0; fi

#INSTALAR Terminales
if [ "$package44" = "on" ]; then apturl apt://terminator; fi
if [ "$package45" = "on" ]; then apturl apt://tilda; fi
if [ "$package46" = "on" ]; then apturl apt://guake; fi

#UPGRADEAR
zenity --title="Auto-install4Ubuntu" --question --text="Se ha terminado de instalar su selección.\n¿Quiere hacer una actualización completa de los paquetes de su sistema?"
if [ $? != 0 ]; then exit 0; fi
gksu update-manager
}



function terminales(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: VirtualBox" --text="Seleccione si desea instalar algún cliente de terminal extra." --column "" --column "Paquetes a instalar" TRUE "Terminator" FALSE "Tilda" FALSE "Guake"`
if [ $? != 0 ]; then avanzado; exit 0; fi

if (echo "$respuestas" | grep -i "Terminator");	then package44=on; else package44=off; fi #terminator
if (echo "$respuestas" | grep -i "Tilda");	then package45=on; else package45=off; fi #tilda
if (echo "$respuestas" | grep -i "Guake");	then package46=on; else package46=off; fi #guake

Instalando
}




function select_virtualbox(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: VirtualBox" --text="Seleccione la version que desea usar de VirtualBox." --column "" --column "Paquetes a instalar" FALSE "Virtual Box Open Source Edition" TRUE "Virtual Box 3.0 (Edicion cerrada)"`
if [ $? != 0 ]; then avanzado; exit 0; fi

if (echo "$respuestas" | grep -i "Open");	then package42=on; else package42=off; fi #virtualbox-ose
if (echo "$respuestas" | grep -i "cerrada");	then package43=on; else package43=off; fi #virtualbox-3.0

terminales
}




function avanzado(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Avanzado" --text="Seleccione de la lista de abajo que paquetes quiere instalar." --column "" --column "Paquetes a instalar" FALSE "Utilidades basicas de compilación" FALSE "Navegador Web Chromium (Karmic o superior)" FALSE "Entorno de desarrollo-programación Eclipse" FALSE "Entorno de desarrollo-programación Netbeans" TRUE "VirtualBox para usar maquinas virtuales"`
if [ $? != 0 ]; then diseno; exit 0; fi

if (echo "$respuestas" | grep -i "compilacion"); then package38=on; else package38=off; fi #build-essential
if (echo "$respuestas" | grep -i "Chromium");	then package39=on; else package39=off; fi #chromium-browser chromium-browser-l10n chromium-codecs-ffmpeg-nonfree chromium-codecs-ffmpeg
if (echo "$respuestas" | grep -i "Eclipse"); then package40=on; else package40=off; fi #Eclipse
if (echo "$respuestas" | grep -i "Netbeans"); then package41=on; else package41=off; fi #Netbeans
if (echo "$respuestas" | grep -i "VirtualBox");	then virtualbox=on; else virtualbox=off; fi

if [ $virtualbox = on ]; then select_virtualbox; else terminales; fi
}





function diseno(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Diseño" --text="Seleccione los programas que necesite tener instalados de la lista de abajo." --column "" --column "Paquetes a instalar" TRUE "Diseño vectorial Inkscape" FALSE "Programación HTML Screem" FALSE "Diseño y maquetacion de documentos Scribus" FALSE "Capturador de pantalla Shutter"`
if [ $? != 0 ]; then apariencia; exit 0; fi

if (echo "$respuestas" | grep -i "Inkscape");	then package34=on; else package34=off; fi #inkscape
if (echo "$respuestas" | grep -i "Screem");	then package35=on; else package35=off; fi #screem
if (echo "$respuestas" | grep -i "Scribus");	then package36=on; else package36=off; fi #scribus
if (echo "$respuestas" | grep -i "Shutter");	then package37=on; else package37=off; fi #shutter

avanzado
}




function apariencia(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Apariencia" --text="Seleccione los paquetes que desea de la lista de abajo." --column "" --column "Paquetes a instalar" TRUE "Panel de control de Compiz-Fusion" FALSE "Proyecto Bisigi: Temas para Gnome (Karmic o superior)"`
if [ $? != 0 ]; then compatibilidad; exit 0; fi

if (echo "$respuestas" | grep -i "Compiz");	then package32=on; else package32=off; fi #compizconfig-settings-manager emerald fusion-icon
if (echo "$respuestas" | grep -i "Bisigi");	then package33=on; else package33=off; fi #zgegblog-themes

diseno
}




function compatibilidad(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Compatibilidad" --text="Seleccione los programas que desea tener instalados de la lista de abajo." --column "" --column "Paquetes a instalar" TRUE "Compatibilidad con sistemas de compresión: rar, 7z, etc" FALSE "Soporte extendido para aplicaciones java" TRUE "Compatibilidad con programas de Windows Wine" TRUE "Instalador de Juegos para Windows PlayonLinux"`
if [ $? != 0 ]; then mensajeria; exit 0; fi

if (echo "$respuestas" | grep -i "rar");	then package28=on; else package28=off; fi #unrar rar p7zip-full unace unzip
if (echo "$respuestas" | grep -i "java");	then package29=on; else package29=off; fi #sun-java6-fonts sun-java6-jre sun-java6-plugin
if (echo "$respuestas" | grep -i "Wine");	then package30=on; else package30=off; fi #wine
if (echo "$respuestas" | grep -i "PlayonLinux"); then package31=on; else package31=off; fi #playonlinux

apariencia
}




function mensajeria(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Mensajeria" --text="Seleccione los programas de mensajeria o chat que desea\ntener instalados de la lista de abajo." --column "" --column "Paquetes a instalar" FALSE "Cliente de messenger aMSN (soporta webcam)" FALSE "Cliente de messenger Emesene" TRUE "Cliente multi-protocolo Pidgin" TRUE "Cliente de IRC XChat"`
if [ $? != 0 ]; then Internetapps; exit 0; fi

if (echo "$respuestas" | grep -i "MSN");	then package24=on; else package22=off; fi #amsn
if (echo "$respuestas" | grep -i "Emesene");	then package25=on; else package25=off; fi #emesene
if (echo "$respuestas" | grep -i "Pidgin");	then package26=on; else package26=off; fi #pidgin
if (echo "$respuestas" | grep -i "IRC");	then package27=on; else package27=off; fi #xchat

compatibilidad
}




function Internetapps(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Internet" --text="Seleccione los programas de Internet que desea\ntener instalados de la lista de abajo." --column "" --column "Paquetes a instalar" FALSE "Gestor de descargas Tucan Manager" FALSE "Cliente P2P amule" FALSE "Cliente de Torrent Deluge" FALSE "Cliente de correo Thunderbird"`
if [ $? != 0 ]; then escritorio; exit 0; fi

if (echo "$respuestas" | grep -i "Jdownloader"); then package18=on; else package18=off; fi #jdownloader
if (echo "$respuestas" | grep -i "Tucan");	then package19=on; else package19=off; fi #tucan
if (echo "$respuestas" | grep -i "amule");	then package20=on; else package20=off; fi #amule
if (echo "$respuestas" | grep -i "Deluge");	then package21=on; else package21=off; fi #deluge
if (echo "$respuestas" | grep -i "Opera");	then package22=on; else package22=off; fi #opera
if (echo "$respuestas" | grep -i "Thunderbird"); then package23=on; else package23=off; fi #thunderbird

mensajeria
}




function escritorio(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Escritorio" --text="Seleccione los paquetes que desea tener instalados de la lista de abajo." --column "" --column "Paquetes a instalar" TRUE "Dock/Manejador de ventanas Avant" TRUE "Dock/Lanzador de aplicaciones Gnome-Do" TRUE "Screenlets de esctritorio" TRUE "Buscador rápido multifuncional Lemur-search"`
if [ $? != 0 ]; then package11=off; package12=off; package13=off; Multimedia; exit 0; fi

if (echo "$respuestas" | grep -i "Avant");	then package14=on; else package14=off; fi #awn
if (echo "$respuestas" | grep -i "Gnome-Do");	then package15=on; else package15=off; fi #gnome-do
if (echo "$respuestas" | grep -i "Screenlets");	then package16=on; else package16=off; fi #screenlets
if (echo "$respuestas" | grep -i "Lemur");	then package17=on; else package17=off; fi #lemur-search

Internetapps
}





function medibuntu(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Medibuntu" --text="Seleccione los paquetes que desea tener instalados de la lista de abajo." --column "" --column "Paquetes a instalar" FALSE "Soporte de Video-DVD -libdvdcss2-" TRUE "Codecs de Windows -w32codecs/w64codecs-" TRUE "Cliente de VoIP Skype"`
if [ $? != 0 ]; then Multimedia; exit 0; fi

if (echo "$respuestas" | grep -i "DVD");	then package11=on; else package11=off; fi #libdvdcss2
if (echo "$respuestas" | grep -i "Windows");	then package12=on; else package12=off; fi #w32codecs/w64codecs
if (echo "$respuestas" | grep -i "Skype");	then package13=on; else package13=off; fi #skype

escritorio
}



function Multimedia(){

respuestas=`zenity --list --checklist --height=300 --title="Auto-install4Ubuntu: Multimedia" --text="Seleccione los programas que desea tener instalados de la lista de abajo.\nTambien puede seleccionar para instalar el repositorio de Medibuntu\ny disponer de mas programas en el siguiente paso" --column "" --column "Paquetes a instalar" TRUE "Extras restrictivos: mp3, flash, java..." FALSE "Reproducor de medios VideoLan" TRUE "Reproductor de medios SMPlayer" TRUE "Reproductor de musica Exaile" FALSE "Reproductor de misica Banshee" FALSE "Gestor de Webcams Cheese" FALSE "Lector de comics Comix" TRUE "Centro multimedia Moovida" TRUE "Mezclador por pistas xfce4-mixer" TRUE "Añadir el repositorio de Medibuntu con más paquetes multimedia"`
if [ $? != 0 ]; then exit 0; fi

if (echo "$respuestas" | grep -i "restricted");	then package1=on; else package1=off; fi #ubuntu-restricted-extras
if (echo "$respuestas" | grep -i "vlc");	then package2=on; else package2=off; fi #vlc mozilla-plugin-vlc
if (echo "$respuestas" | grep -i "SMPlayer");	then package3=on; else package3=off; fi #smplayer
if (echo "$respuestas" | grep -i "Exaile");	then package4=on; else package4=off; fi #exaile
if (echo "$respuestas" | grep -i "Banshee");	then package5=on; else package5=off; fi #banshee
if (echo "$respuestas" | grep -i "Cheese");	then package6=on; else package6=off; fi #cheese
if (echo "$respuestas" | grep -i "AcetoneISO");	then package7=on; else package7=off; fi #acetoneiso2
if (echo "$respuestas" | grep -i "Comix");	then package8=on; else package8=off; fi #comix
if (echo "$respuestas" | grep -i "Moovida");	then package9=on; else package9=off; fi #moovida
if (echo "$respuestas" | grep -i "xfce4-mixer"); then package10=on; else package10=off; fi #xfce4-mixer
if (echo "$respuestas" | grep -i "Medibuntu");	then medibuntu=on; else medibuntu=off; fi


if [ $medibuntu = on ]; then medibuntu; else escritorio; fi
}


#Aviso root
if [ $USER != root ]; then zenity --title="Auto-install4Ubuntu" --info --text="Debes tener acceso como administrador para ejecutar este programa. Se pedirá la clave de \"sudo\" para modificar el sistema."; fi

#Obtencion de parametros
arch=`uname -a | awk '{print $12}'`
codename=`lsb_release -c | awk '{print $2}'`
release=`lsb_release -r | awk '{print $2}'`
rel_year=${release%.*}
if [ "$release" = "9.10" ] || [ $rel_year > 9 ]; then karmico=on; else karmico=off; fi

zenity --title="Auto-install4Ubuntu" --question --text="Se ha detectado su instalación como Ubuntu $codename $arch.\nSi esto no es correcto no continue por favor."
if [ $? = 0 ]; then Multimedia; fi
