#!/bin/bash
temporal=$(uuidgen | awk -F- ' { print $1 } ')
archivo=$(zenity --file-selection --title "Seleccione archivo a enviar")
echo "$temporal
$archivo"
if [ ! "x$archivo" = "x"  ]; then
mkdir -p /tmp/$temporal/
#TODO: si tiene menos de 10 MB no picar

if [ $(ls -l $(dirname "$archivo")|grep "`basename \"$archivo\"`" |awk '{ print $5 }') -gt 70000000 ]; then
echo "grande"
split --verbose -b 10MB "$archivo" /tmp/$temporal/arch
echo "$archivo" > /tmp/$temporal/nombre.txt
basename "$archivo" >> /tmp/$temporal/nombre.txt
##TODO: genera archivo para pegar
##Para pegar luego los archivos: cat HISYSa* >> Hysys.rar
#echo "#!/bin/bash
#cat arch* > \"\$(cat nombre.txt|tail -n1)\"
#" | tee ensambla.sh
##TODO: Borrar archivo de nombre. Se debería generar un uuid para evitar borrar algo que sí se quiera pasar
#mv -v nombre.txt /tmp/

else
echo "pequeño";
fi
bluetooth-sendto --device=00:15:83:15:A3:10 /tmp/$temporal/*
fi
#portatil: 00:15:83:15:A3:10
#Mini:00:22:43:F6:04:8F
