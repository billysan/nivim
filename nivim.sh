#!/bin/bash

echo -n looking for ripgrep... 
which rg &>/dev/null
if [ $? -ne 0 ]; then
  echo
	echo please install ripgrep somehow
  exit 1
fi
echo found it

echo starting...

dest_dir=$HOME/.local/bin

mkdir -p $HOME/.config/nvim
cp init.lua $HOME/.config/nvim

chmod u+x lazygit
chmod u+x lazydocker
chmod u+x nvim.appimage

mkdir -p $dest_dir
cp lazygit $dest_dir
cp lazydocker $dest_dir

if [ ! -d "$dest_dir/squashfs-root" ]; then
	echo extracting squashfs...
	./nvim.appimage --appimage-extract &>/dev/null
	mv squashfs-root $dest_dir
fi

grep -i $dest_dir ~/.bashrc &>/dev/null
if [ $? -ne 0 ]; then
	echo adding $dest_dir to .bashrc...
	echo "export PATH=\$PATH:$dest_dir" >> ~/.bashrc
fi

grep -i $dest_dir/squashfs-root/usr/bin ~/.bashrc &>/dev/null
if [ $? -ne 0 ]; then
	echo adding squashfs to .bashrc...
	echo "export PATH=\$PATH:$dest_dir/squashfs-root/usr/bin" >> ~/.bashrc
fi

pip freeze | grep pyright== &> /dev/null || pip install pyright
pip freeze | grep black== &> /dev/null || pip install black

echo done
