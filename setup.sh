#!/bin/bash
## Install in linux

# Copy necessary files
cp football_gametime_extension.lua $HOME/.local/share/vlc/lua/extensions/football.lua
cp football_gametime_interface.lua $HOME/.local/share/vlc/lua/intf/football.lua

# Add line to bash_aliases

if [[ ! -f ~/.bash_aliases ]] || [[ -z $(egrep "^alias vlc-football.*football" ~/.bash_aliases) ]]; then
  echo "alias vlc-football='vlc --verbose=1 --extraintf=luaintf --lua-intf=football'" >> ~/.bash_aliases
fi
