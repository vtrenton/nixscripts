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
nix-collect-garbage --quiet

# use nvd to give us a nice diff
nvd diff /run/booted-system /run/current-system

# print out current nix generations for tracking
echo "NixOS Generations:"
nixos-rebuild list-generations

popd >/dev/null
