#!/bin/bash
# Install dotfiles into $HOME.
INSTALL_DIR=$(dirname $0)
INSTALL_FILES=$INSTALL_DIR/etc/*
OPWD=$PWD
cd $HOME

echo "Installing $OPWD/$INSTALL_FILES:"
for f in $OPWD/$INSTALL_DIR/etc/*
do
	df=.$(basename $f)
	[ -f $df ] && mv $df $df-$(date +%y%m%d-%H%M) && echo "Made backup of $df."
	ln -svf $f $df
done

sublime_library=~/Library/Application\ Support/Sublime\ Text\ 2/Packages/User
if [ -d "$sublime_library" ]; then
  ln -vs $INSTALL_DIR/Sublime\ Edit\ 2/* "$sublime_library"
  echo "Please edit your Sublime Edit config to use the Flatland theme and My Hallow's Flat color scheme."
fi

if [ -n "$EDITOR" ]; then
	$EDITOR $HOME/.gitconfig
else
	echo 'Please edit $HOME/.gitconfig now and change your name and email.'
fi
cd $OPWD
