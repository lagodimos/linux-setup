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

mkdir -p ~/.bashrc.d

##### Distro-specific configuration #####

# We need this first to ensure that all the required
# packages are installed before further changes.

privileged_cmd=""

case $distro in

    "arch")

        privileged_cmd+="pacman -Syu --noconfirm;"
        privileged_cmd+="pacman -S --needed --noconfirm ${packages[@]};"

        privileged_cmd+="systemctl enable --now virtqemud;"
        privileged_cmd+="systemctl enable gdm;"

        privileged_cmd+="bash ./modules/configure_ufw.sh;"

        if [[ "$set_governor" == true ]]; then
            sed_script="/governor=/c governor=\"$cpu_governor\""

            privileged_cmd+="sed -i '$sed_script' /etc/default/cpupower;"
            privileged_cmd+="systemctl enable --now cpupower.service;"
        fi
        ;;

    "debian")

        # The bat executable have been renamed from ‘bat’ to ‘batcat’
        # because of a file name clash with another Debian package,
        # so an alias is necessary to use bat with the regular command.
        cp $LOC/res/debian/bat.bashrc ~/.bashrc.d

        privileged_cmd+="apt-get update;"
        privileged_cmd+="apt-get upgrade -y;"
        privileged_cmd+="apt-get install -y ${packages[@]};"
        privileged_cmd+="apt-get clean;"

        privileged_cmd+="bash ./modules/configure_ufw.sh;"

        if [[ "$set_governor" == true ]]; then
            sed_script="s/cpu_governor/$cpu_governor/g"

            privileged_cmd+="cp $LOC/res/cpupower.service /etc/systemd/system;"
            privileged_cmd+="sed -i '$sed_script' /etc/systemd/system/cpupower.service;"

            privileged_cmd+="systemctl enable --now cpupower.service;"
        fi
        ;;

    *)
        echo "Unavailable distribution ID: $distro"
        exit
        ;;

esac

$escalation_tool bash -c "$privileged_cmd"

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
