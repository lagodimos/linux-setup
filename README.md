## Usage

Clone the repo and make the scripts executable:

    git clone https://github.com/giann1s/linux-setup.git &&
    cd ./linux-setup && chmod a+x setup.sh & chmod a+x backup.sh

then launch the script by running:

    bash ./setup.sh

### Backup
To make a backup of your apps (including flatpaks) execute the backup.sh script which stores the data in /config/app-data.

    bash ./backup.sh

To restore/delete the backup pass the `restore` or `delete` argument accordingly to backup.sh.

    bash ./backup.sh restore
    bash ./backup.sh delete

Note: If the `auto_restore_backup` option is enabled in the /config/options.sh file, the data will be automatically restored upon running the setup.sh script.

## My Configuration

### Gnome Extensions
- AppIndicator and KStatusNotifierItem Support
- Bluetooth battery indicator

### VSCodium Extensions

- Live Preview
- clangd
- rust-analyzer
- Vim (https://open-vsx.org/extension/vscodevim/vim)
- Python, Pylint, Mypy Type Checker, isort
- Prettier - Code formatter
- Even Better TOML

- Compare Folders

- LaTeX Workshop

- Code Spell Checker
- Greek - Code Spell Checker

## Arch installation script
- Create the partitions (e.g. using cfdisk)

- Download the script

      curl -O https://raw.githubusercontent.com/lagodimos/linux-setup/refs/heads/master/scripts/install_arch.sh

- Run and pass the partitions with the following order

      . ./install_arch.sh /dev/*boot* /dev/*root* /dev/*home*
