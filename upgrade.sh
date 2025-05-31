#!/bin/sh
if [ $(id -u) -ne 0 ]; then 
    echo "please run as root"
    exit 1
fi

pushd /etc/nixos/ >/dev/null
nix flake update
nixos-rebuild switch --upgrade

# collect garbage
echo "Collecting garbage..."
sudo nix-collect-garbage --quiet

# print out current nix generations for tracking
echo "NixOS Generations:"
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

popd >/dev/null
