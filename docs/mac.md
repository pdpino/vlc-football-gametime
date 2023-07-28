# Manual instructions for Mac


## Manual installation

You can choose to make it available for either all users or for the current user only.

### Step 1: copy the Lua files

Copy both lua files (the extension [`football_gametime_extension.lua`](../football_gametime_extension.lua) and the interface [`football_gametime_interface.lua`](../football_gametime_interface.lua)) to their corresponding folders, following the table below.

| File | For current user only | For all users |
|---|---|---|
| `football_gametime_extension.lua` | `/Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/extensions/` | `/Applications/VLC.app/Contents/MacOS/share/lua/extensions/` |
| `football_gametime_interface.lua` | `/Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/intf/` | `/Applications/VLC.app/Contents/MacOS/share/lua/intf/` |


#### Step 2: setup shortcut

Create an app shortcut that runs the following command:
```
vlc --extraintf=luaintf --lua-intf=football_gametime_interface
```



## Running VLC manually

Run the following on a terminal:
```
vlc --extraintf=luaintf --lua-intf=football_gametime_interface
```
