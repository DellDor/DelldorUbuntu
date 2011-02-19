#!/bin/bash
#Activa todos los repositorios
sudo sed -i 's/##/#/g' /etc/apt/sources.list
sudo sed -i 's/# #/#/g' /etc/apt/sources.list
sudo sed -i 's/#deb /deb /g' /etc/apt/sources.list
sudo sed -i 's/# deb /deb /g' /etc/apt/sources.list
sudo sed -i 's/# deb/deb/g' /etc/apt/sources.list  #Desactiva las fuentes y cdrom y limpia las inactivas
sudo sed -i 's/deb-src /#deb-src /g' /etc/apt/sources.list
sudo sed -i 's/deb cdrom/#deb cdrom/g' /etc/apt/sources.list
sudo sed -i 's/# #deb/#deb/g' /etc/apt/sources.list
sudo sed -i 's/##deb/#deb/g' /etc/apt/sources.list

#Si no empiezan con ve.archive, se puede cambiar:
prueba=$(cat /etc/apt/sources.list | grep ve.archive)
if [ "x" = "x$prueba" ]; then
sudo sed -i 's/archive.ubuntu.com/ve.archive.ubuntu.com/g' /etc/apt/sources.list
echo "Cambiados los repositorios a Venezuela"
fi

#Elimina backports (para estabilidad) REVISAR QUE ESTA DAÑADO
sudo grep -ve "backports" -ve "proposed" /etc/apt/sources.list > /tmp/a.txt; cat /tmp/a.txt | sudo tee /etc/apt/sources.list  

=== Repositorios añadidos ===
 
#Se puede usar el esquema: apturl apt:kupfer?refresh=yep

sudo add-apt-repository ppa:wrinkliez/ppasearch #Para ppasearch


sudo add-apt-repository ppa:ailurus
sudo add-apt-repository ppa:tualatrix/ppa #Ubuntu-Tweak

sudo add-apt-repository ppa:canonical-dx-team/une #Para Unity, Mutter, etc
#sudo add-apt-repository ppa:am-monkeyd/nautilus-elementary-ppa
#sudo add-apt-repository ppa:globalmenu-team/ppa

sudo add-apt-repository ppa:bean123ch/burg #Burg
#sudo add-apt-repository ppa:iaz/battery-status
sudo add-apt-repository ppa:caffeine-developers/ppa #Caffeine
sudo add-apt-repository ppa:cybolic/ppa #Vineyard
#sudo add-apt-repository ppa:doctormo/ppa #Gdocs-mount-gtk
sudo add-apt-repository ppa:ferramroberto/linuxfreedomlucid #Rednotebook y otros
sudo add-apt-repository ppa:klaus-vormweg/ppa #Zim y actualizaciones de otros programas
sudo add-apt-repository ppa:kupfer-team/ppa #Kupfer
sudo add-apt-repository ppa:nilarimogard/webupd8 #Actualizaciones desde versiones superiores a Lucid y FatRat
sudo add-apt-repository ppa:ferramroberto/pidgin #Última versión de Pidgin
sudo add-apt-repository ppa:vinux/vinux-lucid #Dependencias para otros programas como gnochm
#sudo add-apt-repository ppa:lubuntu-desktop/ppa #Lubuntu
sudo add-apt-repository ppa:mozillateam/firefox-stable #Últimos de Mozilla
sudo add-apt-repository ppa:ubuntu-mozilla-security #Actualizaciones de seguridad de Mozilla
#sudo add-apt-repository ppa:eugenesan/mozilla #Últimas de Thunderbird
sudo add-apt-repository ppa:n-muench/vlc #VLC. otro: sudo add-apt-repository ppa:c-korn/vlc (no funciona)
#sudo add-apt-repository ppa:rvm/smplayer #SMplayer
#sudo add-apt-repository ppa:openoffice-pkgs/ppa
sudo add-apt-repository ppa:libreoffice/ppa #Libreoffice
sudo add-apt-repository ppa:flimm/ooo-thumbnailer #Visor de miniaturas de Openoffice.org
#sudo add-apt-repository ppa:shakaran/ppa #Para Tivion
sudo add-apt-repository ppa:ubuntu-wine/ppa #Wine
sudo add-apt-repository ppa:cybolic/ppa #Vineyard
#sudo add-apt-repository ppa:llyzs/ppa# Remmina para conexión remota con VNC, ssh, etc



#Virtual Box freeware (no OSE)
wget -q http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc -O- | sudo apt-key add -
echo "deb http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib  #VirtualBox freeware" | sudo tee /etc/apt/sources.list.d/virtualbox_freeware.list
 		
#Google
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
sudo add-apt-repository "deb http://dl.google.com/linux/deb/ stable non-free main"  

#Opera
sudo wget -O - http://deb.opera.com/archive.key | sudo apt-key add -
echo "deb http://deb.opera.com/opera stable non-free #Navegador Opera" | sudo tee /etc/apt/sources.list.d/opera.list
#sudo add-apt-repository "deb http://deb.opera.com/opera stable non-free #Navegador Opera"  


#Medibuntu. Se debe ejecutar de último porque busca actualizar las listas para instalar su clave.

sudo wget --output-document=/etc/apt/sources.list.d/medibuntu.list http://www.medibuntu.org/sources.list.d/$(lsb_release -cs).list && sudo apt-get update && sudo apt-get --yes --allow-unauthenticated install medibuntu-keyring && sudo apt-get update

sudo apt-get update 2> /tmp/keymissing for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); do echo -e "Procesando clave: $key"; gpg --keyserver keyserver.ubuntu.com --recv $key && gpg --export --armor $key | sudo apt-key add - done

sudo apt-get update 2> /tmp/keymissing for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); do echo -e "Procesando clave: $key"; gpg --keyserver subkeys.pgp.net --recv $key && gpg --export --armor $key | sudo apt-key add -
