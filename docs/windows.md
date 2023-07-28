# Manual instructions for Windows


**Only use these instructions if the main steps did not work for you.**


## Manual installation

You can choose to make it available for either all users or for the current user only.

### Step 1: copy the Lua files

Copy both lua files (the extension [`football_gametime_extension.lua`](../football_gametime_extension.lua) and the interface [`football_gametime_interface.lua`](../football_gametime_interface.lua)) to their corresponding folders, following the table below.

| File | For current user only | For all users |
|---|---|---|
| `football_gametime_extension.lua` | `%APPDATA%\vlc\lua\extensions\` | `C:\Program Files\VideoLAN\VLC\lua\extensions\` |
| `football_gametime_interface.lua` | `%APPDATA%\vlc\lua\intf\` | `C:\Program Files\VideoLAN\VLC\lua\intf\` |


#### Step 2: setup shortcut

TODO



## Running VLC manually

Open search, type _Run_ and there run this command:
```
vlc --extraintf=luaintf --lua-intf=football_gametime_interface
```
