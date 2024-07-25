#!/bin/bash

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

# Rebuild konfigurasi dan dependencies
echo "Rebuilding configurations and dependencies..."
dpkg --configure -a
apt-get -f install -y

# Reset beberapa pengaturan default (opsional)
echo "Resetting default configurations..."
dpkg-reconfigure --all

echo "System rebuild complete."
