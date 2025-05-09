#!/bin/bash

# List of binaries
binaries=("rg" "make" "node")
is_continue=true

# Loop through the list
for binary in "${binaries[@]}"
do
    # Check if binary is installed
    if ! which $binary &> /dev/null
    then
        echo "$binary is not installed."
        is_continue=false
    fi
done

if [ "$is_continue" = false ]; then
    echo "please install missing binaries"
    exit 1
fi

echo starting...

dest_dir=~/.local/bin

mkdir -p ~/.config/nvim
cp init.lua ~/.config/nvim
cp cheatsheet.md ~/.config/nvim

chmod u+x lazygit
chmod u+x nvim.appimage

mkdir -p $dest_dir
cp lazygit $dest_dir

if [ ! -d "$dest_dir/squashfs-root" ]; then
	echo extracting squashfs...
	./nvim.appimage --appimage-extract &>/dev/null
	mv squashfs-root $dest_dir
fi

# check if the shell is zsh or bash
if [ $SHELL = "/bin/zsh" ]
then
    rc_file=~/.zshrc
else
    rc_file=~/.bashrc
fi

grep -i $dest_dir $rc_file &>/dev/null
if [ $? -ne 0 ]; then
	echo adding $dest_dir to .bashrc...
	echo "export PATH=\$PATH:$dest_dir" >> $rc_file
fi

grep -i $dest_dir/squashfs-root/usr/bin $rc_file &>/dev/null
if [ $? -ne 0 ]; then
	echo adding squashfs to .bashrc...
	echo "export PATH=\$PATH:$dest_dir/squashfs-root/usr/bin" >> $rc_file
fi

grep nivim $rc_file &>/dev/null
if [ $? -ne 0 ]; then
	echo adding nivim alias to .bashrc...
	echo "alias nivim=nvim" >> $rc_file
fi

pip freeze | grep pyright== &> /dev/null || pip install pyright
pip freeze | grep black== &> /dev/null || pip install black

echo done
