#!/bin/bash

if [[ $EUID -ne 0 ]]; then
	if command -v sudo >/dev/null 2>&1; then
		echo "Please rerun this script with sudo: sudo $0"
	else
		echo "This script must be run as root."
	fi
	exit 1
fi

read -r -p "This will destroy and reformat disks before reinstalling NixOS. Continue? [y/N]: " confirm

if [[ ! $confirm =~ ^[Yy]$ ]]; then
	echo "Aborted."
	exit 1
fi

curl https://raw.githubusercontent.com/sudosteak/dotfiles/refs/heads/main/nixos/disko-config.nix -o /tmp/disk-config.nix

sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount /tmp/disk-config.nix

nixos-generate-config --no-filesystems --root /mnt

mv /tmp/disk-config.nix /mnt/etc/nixos

