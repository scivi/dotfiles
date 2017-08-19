#!/bin/bash

# Install dotfiles into $HOME.
INSTALL_DIR=$(dirname $0)
[ -z "$INSTALL_DIR" -o "$INSTALL_DIR" -eq "/" ] && exit 1

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

# Link bash config
echo "Installing Bash config:"
mkdir -p ~/.config/{lib,bash}
ln -svf $OPWD/$INSTALL_DIR/config/bash/feature ~/.config/bash
ln -svf $OPWD/$INSTALL_DIR/config/bash/private ~/.config/bash
ln -svf $OPWD/$INSTALL_DIR/config/bash/initialize.sh ~/.config/bash
ln -svf $OPWD/$INSTALL_DIR/config/bash/load_features.sh ~/.config/bash
ln -svf $OPWD/$INSTALL_DIR/config/lib/lessfilter ~/.config/lib
ln -svf $OPWD/$INSTALL_DIR/config/git_templates ~/.config/git_templates


# Add to ~/.bashrc
if grep ' ~/.config/bash/initialize.sh' ~/.bashrc; then
  :
else
  mv ~/.bashrc ~/.bashrc.old
  echo -e "source ~/.config/bash/initialize.sh" > ~/.bashrc
  echo -e "source ~/.config/bash/private/*.sh\n" >> ~/.bashrc
  cat ~/.bashrc.old >> ~/.bashrc
  rm ~/.bashrc.old
fi

cd $OPWD
