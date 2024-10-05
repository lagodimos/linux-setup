upgrade () {
    upgrade_cmd=""

    if pacman --version &> /dev/null; then
        upgrade_cmd+="pacman -Syu --noconfirm;"

        if [[ $(pacman -Qqdt | head -c1 | wc -c) -ne 0 ]]; then
            upgrade_cmd+="pacman -R $(pacman -Qdtq) --noconfirm;"
        fi
    fi

    if apt-get --version &> /dev/null; then
        upgrade_cmd+="apt-get update;"
        upgrade_cmd+="apt-get upgrade --assume-yes;"
        upgrade_cmd+="apt-get autoremove --purge --assume-yes;"
    fi

    run0 bash -c "$upgrade_cmd" && \

    if flatpak --version &> /dev/null; then
        flatpak upgrade --assumeyes
    fi
}
