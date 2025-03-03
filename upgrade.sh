#!/bin/sh
if [ $(id -u) -ne 0 ]; then 
    echo "please run as root"
    exit 1
fi

pushd /etc/nixos/ >/dev/null
nix flake update >/dev/null
nixos-rebuild switch --upgrade >/dev/null

# Keep only the last 5 generations of the system profile
KEEP_GENERATIONS=5
echo "Deleting generations older than the last $KEEP_GENERATIONS..."
sudo nix-env --delete-generations +${KEEP_GENERATIONS} --profile /nix/var/nix/profiles/system

# Run garbage collection to remove unused files
# Nix GC is reference aware
# we have marked the last 5 generations with the last command so the GC wont clean it.
sudo nix-collect-garbage -d --quiet

# print out current nix generations for tracking
echo "NixOS Generations:"
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

popd >/dev/null
