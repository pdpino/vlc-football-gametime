# Manual instructions for Linux

_Tested in Xubuntu 22.04._

**Only use these instructions if the main steps did not work for you.**



## Manual installation

You can choose to make it available for either all users or for the current user only.

### Step 1: copying lua files

Copy both lua files (the extension [`football_gametime_extension.lua`](../football_gametime_extension.lua) and the interface [`football_gametime_interface.lua`](../football_gametime_interface.lua)) to their corresponding folders, following the table below.

| File | For current user only | For all users |
|---|---|---|
| `football_gametime_extension.lua` | `~/.local/share/vlc/lua/extensions/` | `/usr/share/vlc/lua/extensions/` |
| `football_gametime_interface.lua` | `~/.local/share/vlc/lua/intf/` | `/usr/share/vlc/lua/intf/` |

If a folder does not exist, you'll need to create it.

### Step 2: setup desktop shortcut

Setup a shortcut by copying the app entry ([`vlc-football.desktop`](../setup/linux/vlc-football.desktop)) to its corresponding folder:

| File | For current user only | For all users |
|---|---|---|
| `vlc-football.desktop` | `~/.local/share/applications/` | `/usr/share/applications/` |

Then you'll be able to open VLC with the interface enabled from your Apps menu.


### Step 3 (optional): setup CLI shortcut

Add the following line to your `~/.bash_aliases` or `~/.bashrc` file:
```bash
alias vlc-football='vlc --extraintf=luaintf --lua-intf=football_gametime_interface'
```

Then you'll be able to open VLC with the interface enabled from the command line by running `vlc-football`.



## Running VLC from the terminal

Run this command in a terminal:

```bash
vlc --extraintf=luaintf --lua-intf=football_gametime_interface
```

