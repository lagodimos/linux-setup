#!/usr/bin/env bash

# Common options

# The desktop environment is installed
# by the script. Do not select any
# during the OS installation.
DE="gnome"

set_governor="true"
cpu_governor="powersave"

auto_restore_backup=false
dotconfig_dirs=(    # directories to backup
    gh
)

flatpaks=(  # Requires flatpak to be installed (make sure to include it in your packages list)
    cc.arduino.IDE2
    com.github.tchx84.Flatseal
    com.usebottles.bottles
    com.vscodium.codium
    io.github.shiftey.Desktop
    io.gitlab.librewolf-community
    org.gimp.GIMP
    org.gnome.SimpleScan
    org.keepassxc.KeePassXC
    org.libreoffice.LibreOffice
    org.localsend.localsend_app
    org.qbittorrent.qBittorrent
    #org.texstudio.TeXstudio org.freedesktop.Sdk.Extension.texlive//$latest_freedesktop_sdk_version

    com.discordapp.Discord
)

case $DE in

    "gnome")

        flatpaks+=(
            com.mattjakeman.ExtensionManager
            io.github.celluloid_player.Celluloid
            io.gitlab.news_flash.NewsFlash
            net.nokyan.Resources
            org.gnome.Fractal
            org.gnome.Geary
            org.gnome.Loupe
            org.gnome.Papers
            org.gnome.Snapshot
        )
        ;;

esac

case $distro in

    "arch")

        packages=(
            linux-lts
            usbutils

            android-tools
            bash-completion
            bat
            cpupower
            curl
            distrobox
            exfat-utils
            fastfetch
            ffmpeg
            ffmpegthumbnailer
            flatpak
            fzf
            github-cli
            git
            jpegoptim optipng
            texlive-basic texlive-binextra texlive-latexrecommended texlive-fontsrecommended texlive-langgreek
            less
            lm_sensors
            mingw-w64
            net-tools
            nmap
            nodejs npm
            ollama
            plocate
            podman podman-compose
            python3 pypy3
            qemu-base virt-manager dnsmasq
            rsync
            starship ttf-firacode-nerd noto-fonts-emoji
            smartmontools
            timeshift
            tldr
            trash-cli
            ufw
            wget
            zoxide
        )

        case $DE in

            "gnome")

                packages+=(
                    gdm gnome-shell gnome-backgrounds
                    xdg-desktop-portal-gnome
                    gnome-tweaks gnome-themes-extra

                    gnome-console
                    gnome-control-center
                    gnome-disk-utility
                    gnome-text-editor
                    nautilus gvfs-gphoto2 gvfs-mtp gvfs-nfs gvfs-smb
                )
                ;;

        esac
        ;;

    "debian")

        packages=(
            adb fastboot
            bat
            curl
            distrobox
            ffmpeg
            ffmpegthumbnailer
            flatpak
            fzf
            gh
            git
            jpegoptim optipng
            texlive-latex-base texlive-latex-recommended texlive-fonts-recommended latexmk texlive-lang-greek
            less
            linux-cpupower
            lm-sensors
            mingw-w64
            net-tools
            nmap
            nodejs npm
            plocate
            podman podman-compose fuse-overlayfs
            python3 python3-venv python-is-python3 pypy3
            qemu-system-x86 virt-manager qemu-utils
            rsync
            smartmontools
            timeshift
            tldr
            trash-cli
            ufw
            wget
            wine
            zoxide
        )

        case $DE in

            "gnome")

                packages+=(
                    gdm3 gnome-shell

                    gnome-console
                    gnome-disk-utility
                    gnome-text-editor
                    nautilus
                )
                ;;

        esac
        ;;

esac
