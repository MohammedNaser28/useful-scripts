#!/bin/bash 

sudo pacman -Scc
rm -rf ~/.cache/paru
sudo pacman -Syy
paru -Syy
