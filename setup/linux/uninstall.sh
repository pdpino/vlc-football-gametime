#!/bin/bash
## Uninstall from linux system

# Remove extension and interface files
rm -f $HOME/.local/share/vlc/lua/extensions/football_gametime_extension.lua
rm -f $HOME/.local/share/vlc/lua/intf/football_gametime_interface.lua

# Remove line from bash_aliases
if [[ -f ~/.bash_aliases ]]; then
  sed -i -e "s/alias vlc-football.*//g" ~/.bash_aliases
fi

# Remove app entry
rm -f $HOME/.local/share/applications/vlc-football.desktop
