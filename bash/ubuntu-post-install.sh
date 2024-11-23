#!/bin/bash

echo "Installing proprietary media formats..."
sudo apt install ubuntu-restricted-extras

echo "Installing libdvdcss..."
sudo /usr/share/doc/libdvdread4/install-css.sh

echo "Installing VLC..."
sudo apt install vlc

echo "Installing Ubuntu Cleaner..."
sudo apt install software-properties-common
sudo add-apt-repository ppa:gerardpuig/ppa
sudo apt update
sudo apt install ubuntu-cleaner

echo "Removing snap packages..."
snaps=$(snap list --all | awk '{print $1}')
for snap in $snaps; do
    echo -n "Uninstalling '$snap '... "
    sudo snap remove $snap
    echo "Done."
done

echo "Stopping snapd service..."
sudo systemctl stop snapd.service
sudo systemctl stop snapd.socket

echo "Disabling snapd service..."
sudo systemctl disable snapd.service
sudo systemctl disable snapd.socket

echo "Removing snapd package..."
sudo apt-get remove -y snapd

echo "Deleting remaining snap folders..."
rm -rf ~/Snap
sudo rm -rf /var/cache/snapd
