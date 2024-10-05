#!/usr/bin/env bash

latest_freedesktop_sdk_version="23.08"

# Location of script
LOC=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

distro=$(. /etc/os-release; echo $ID)

source $LOC/config/options.sh

# Exit if script is being run as root
if [[ "`whoami`" == "root" ]]; then
    echo -e "Please do NOT run the script as root."
    exit
fi
# Ask for root privileges
sudo true

mkdir -p ~/.bashrc.d

##### Distro-specific configuration #####

# We need this first to ensure that all the required
# packages are installed before further changes.
case $distro in

    "arch")

        sudo pacman -Syu --noconfirm
        sudo pacman -S --needed --noconfirm ${packages[@]}

        sudo systemctl enable --now virtqemud
        sudo systemctl enable gdm

        sudo bash ./modules/configure_ufw.sh

        if [[ "$set_governor" == true ]]; then
            sudo sed -i "/governor=/c governor=\"$cpu_governor\"" /etc/default/cpupower
            sudo systemctl enable --now cpupower.service
        fi
        ;;

    "debian")

        # The bat executable have been renamed from ‘bat’ to ‘batcat’
        # because of a file name clash with another Debian package,
        # so an alias is necessary to use bat with the regular command.
        cp $LOC/res/debian/bat.bashrc ~/.bashrc.d

        sudo apt-get update
        sudo apt-get upgrade -y
        sudo apt-get install -y ${packages[@]}
        sudo apt-get clean

        sudo bash ./modules/configure_ufw.sh

        if [[ "$set_governor" == true ]]; then
            sudo cp $LOC/res/cpupower.service /etc/systemd/system
            sudo sed -i "s/cpu_governor/$cpu_governor/g" /etc/systemd/system/cpupower.service

            sudo systemctl enable --now cpupower.service
        fi
        ;;

    *)
        echo "Unavailable distribution ID: $distro"
        exit
        ;;

esac

##### General configuration #####

# .bashrc files

# Extend .bashrc to execute the rc files in ~/.bashrc.d
cp /etc/skel/.bashrc ~ && echo >> ~/.bashrc && cat $LOC/res/run_rcs.bashrc >> ~/.bashrc

cp -r $LOC/config/bash/.bashrc.d ~/
source ~/.bashrc

# File templates
cp -r $LOC/res/Templates ~/

# Install Rust
sh <(curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs) -y --no-modify-path

# .config files (not from backup)

# Configure Flatpak
if [[ " ${packages[*]} " =~ " flatpak " ]]; then
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install flathub -y ${flatpaks[@]}

    # VSCodium
    cp $LOC/config/vscodium.json ~/.var/app/com.vscodium.codium/config/VSCodium/User/settings.json
    flatpak --user override com.vscodium.codium --env=PATH=/app/bin:/usr/bin:/home/$USER/.cargo/bin
fi

if [[ "$auto_restore_backup" == true ]]; then
    chmod a+x $LOC/backup.sh
    $LOC/backup.sh restore
else
    echo "Do you want to restore the backup now?"
    select yn in "Yes" "No"; do
        case $yn in
            Yes ) $LOC/backup.sh restore; break;;
            No ) break;;
        esac
    done
fi

echo -e 'Setup Completed!\nSome changes may require a reboot.'
