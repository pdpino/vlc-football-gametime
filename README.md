# Football gametime VLC extension

_Developed by [pdpino](https://github.com/pdpino)_

Show the gametime in a football match in the top left corner of the video.
You need to save the kick off times for each video.

![gametime|100x100](demos/example-black.png)


## Installation

First you need to install both the VLC extension (`football_gametime_extension.lua` file) and VLC interface (`football_gametime_interface.lua` file).
Choose to make it available for either all users or for the current user only.
Copy both files into the corresponding folder for your operating system (if the folder does not exist you need to create it).

For all users:

| | `football_gametime_extension.lua` | `football_gametime_interface.lua` |
|---|---|---|
| Windows | `Program Files\VideoLAN\VLC\lua\extensions\` | `Program Files\VideoLAN\VLC\lua\intf\` |
| Mac OS | `/Applications/VLC.app/Contents/MacOS/share/lua/extensions/` | `/Applications/VLC.app/Contents/MacOS/share/lua/intf/` |
| Linux | `/usr/share/vlc/lua/extensions/` | `/usr/share/vlc/lua/intf/` |



Or for the current user only:

| | `football_gametime_extension.lua` | `football_gametime_interface.lua` |
|---|---|---|
| Windows | `%APPDATA%\vlc\lua\extensions\` | `%APPDATA%\vlc\lua\intf\` |
| Mac OS | `/Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/extensions/` | `/Users/%your_name%/Library/Application Support/org.videolan.vlc/lua/intf/` |
| Linux | `~/.local/share/vlc/lua/extensions/` | `~/.local/share/vlc/lua/intf/` |



## Open VLC

Open VLC by running the following command in a CLI (terminal/cmd):

```
vlc --extraintf=luaintf --lua-intf=football_gametime_interface
```

You can setup a desktop shortcut for easier use.


## Usage

Go to _View_ -> _Football Gametime_ and save the kick off times for first and second halves.
The gametime should be displayed at the top left corner of the video.
You only need to save the kick off times once for each file (unless you change the name of the file).

![popup](demos/example-popup.png)

## Examples

![example-h1](demos/example-h1.png)

![example-h1-46](demos/example-h1-46.png)

![example-h2](demos/example-h2.png)

