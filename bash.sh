#!/bin/bash

# Fungsi untuk menghapus layanan yang tidak sistem
remove_unnecessary_services() {
    echo "Removing unnecessary services..."
    for service in $(systemctl list-units --type=service --state=running | grep -vE 'systemd|dbus|networkd|udevd' | awk '{print $1}'); do
        echo "Stopping and disabling service: $service"
        systemctl stop "$service"
        systemctl disable "$service"
    done
}

# Update dan upgrade sistem
echo "Updating and upgrading system..."
apt-get update -y
apt-get upgrade -y
apt-get dist-upgrade -y

# Hapus paket yang tidak diperlukan
echo "Removing unnecessary packages..."
apt-get autoremove -y
apt-get autoclean -y

# Hapus file yang mungkin tersisa
echo "Cleaning up residual files..."
rm -rf /var/log/*
rm -rf /var/tmp/*
rm -rf /tmp/*

# Hapus cache APT
echo "Cleaning APT cache..."
rm -rf /var/lib/apt/lists/*

# Reset beberapa pengaturan default (opsional)
echo "Resetting default configurations..."
dpkg-reconfigure --all

# Daftar file biner penting di /usr/bin/
SAFE_FILES=(
    bash
    ls
    cat
    grep
    awk
    sed
    chmod
    chown
    ps
    top
    kill
    tar
    gunzip
    gzip
    bzip2
    unzip
    curl
    wget
    nano
    vi
    less
    mkdir
    rm
    cp
    mv
    df
    du
    find
    which
    uname
    date
    whoami
    su
    sudo
    systemctl
    journalctl
)

# Membersihkan file yang tidak penting di /usr/bin/
echo "Cleaning unnecessary files in /usr/bin/..."
cd /usr/bin/ || exit

for file in *; do
    if [[ ! " ${SAFE_FILES[@]} " =~ " ${file} " ]] && [ -f "$file" ]; then
        echo "Removing: $file"
        rm -f "$file"
    fi
done

# Menghapus layanan yang tidak sistem
remove_unnecessary_services

echo "System rebuild complete."
