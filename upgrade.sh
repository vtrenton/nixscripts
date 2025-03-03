#!/bin/sh
[ $(id -u) -ne 0 ] && 
    echo "please run as root"
    exit 1

pushd /etc/nixos/
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

popd
