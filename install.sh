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

mkdir -p ~/.config/nvim
cp init.lua ~/.config/nvim
cp cheatsheet.md ~/.config/nvim

chmod u+x lazygit
chmod u+x nvim

# check if the shell is zsh or bash
if [ $SHELL = "/bin/zsh" ]
then
    rc_file=~/.zshrc
else
    rc_file=~/.bashrc
fi

grep -i $PWD $rc_file &>/dev/null
if [ $? -ne 0 ]; then
	echo adding $PWD to .bashrc/.zshhrc file...
	echo "export PATH=\$PATH:$PWD" >> $rc_file
fi

grep nivim $rc_file &>/dev/null
if [ $? -ne 0 ]; then
	echo adding nivim alias to .bashrc/.zshrc...
	echo "alias nivim=nvim" >> $rc_file
fi

pip freeze | grep basedpyright== &> /dev/null || pip install basedpyright

echo done
