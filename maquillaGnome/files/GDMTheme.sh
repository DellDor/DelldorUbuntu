#!/bin/sh
# Run as root
cp /tmp/XP_Ubuntu.tar.gz /usr/share/gdm/themes
cd /usr/share/gdm/themes
tar -xf XP_Ubuntu.tar.gz
rm XP_Ubuntu.tar.gz

zenity --info --title "XpGnome" --text "After clicking 'OK', select the 'Local' tab in the next window, then select the 'XP_Ubuntu' theme. Note: This will only work in GNOME 2.26 or less"
gdmsetup
