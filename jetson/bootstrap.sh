#!/bin/bash
mkdir -p ~/.local/bin
dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)" # dotfiles directory
[[ ! -f "$dir/jetson-gpu-top.sh" ]] || ln -fns "$dir/jetson-gpu-top.sh" ~/.local/bin/jetson-gpu-top.sh
ln -fns "$dir/export" ~/.export.jetson

