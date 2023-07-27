#!/bin/bash
## Install in linux

# Copy necessary files
mkdir -p $HOME/.local/share/vlc/lua/extensions
mkdir -p $HOME/.local/share/vlc/lua/intf
cp football_gametime_extension.lua $HOME/.local/share/vlc/lua/extensions/football_gametime_extension.lua
cp football_gametime_interface.lua $HOME/.local/share/vlc/lua/intf/football_gametime_interface.lua

# Add line to bash_aliases
if [[ ! -f ~/.bash_aliases ]] || [[ -z $(egrep "^alias vlc-football.*football" ~/.bash_aliases) ]]; then
  echo "alias vlc-football='vlc --verbose=1 --extraintf=luaintf --lua-intf=football_gametime_interface'" >> ~/.bash_aliases
fi

# Add app entry
cp setup/linux/vlc-football.desktop $HOME/.local/share/applications
