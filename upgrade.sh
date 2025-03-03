#!/bin/sh

nix-store --query --requisites /run/current-system | cut -d '-' -f2- > /tmp/pre
pushd /etc/nixos/
nix flake update >/dev/null
nixos-rebuild switch --upgrade >/dev/null
# Number of generations to keep
KEEP_GENERATIONS=5

# Get list of all generations
generations=$(nix-env --list-generations --profile /nix/var/nix/profiles/system | awk '{print $1}')

# Count generations and delete older ones
count=0
for gen in $generations; do
  count=$((count + 1))
  if [[ $count -gt $KEEP_GENERATIONS ]]; then
    echo "Deleting generation $gen"
    sudo nix-env --delete-generations $gen --profile /nix/var/nix/profiles/system
  fi
done

# Run garbage collection to clear deleted generations
sudo nix-collect-garbage -d --quiet
popd
#nix-store --query --requisites /run/current-system | cut -d '-' -f2- > /tmp/post
#echo "CHANGES"
#diff --color='auto' -uw /tmp/pre /tmp/post
#rm /tmp/pre
#rm /tmp/post
