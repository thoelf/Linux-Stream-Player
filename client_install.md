# Installing LSP on the client
## Install the scripts for LSP
Create a directory for scripts, e.g.:<br/>
```mkdir /home/<user>/bin```

Install the script for selecting play method:<br/>
```install -m 750 lsp-select_player.sh /home/<user>/bin/```

Install the script that sets the nullsink and starts the browser:<br/>
```install -m 750 audio_ff.sh /home/<user>/bin/```

Find the pulse source:<br/>
```pactl list | grep -A2 'Source #' | grep 'Name: ' | cut -d" " -f2 | head -1```

Edit ```audio_ff.sh``` and replace the existing pulse source with the output from the command above. You can also change the browser if you like.

Create the directory for the configuration files:<br/>
```mkdir /home/<user>/.lsp```

Note that the directory is hidden.

Install the configuration file for LSP on the client:<br/>
```install -m 640 lsp.conf /home/<user>/.lsp/```

Edit the file and add the missing data.

The ```.lsp``` direcory will also include an automatically created file named ```selected_player.txt```. The file includes the text "mpd" or "squeeze" depending on the selected play method.

## Install VLC - multimedia player and streamer
Install VLC:<br/>
```sudo apt install vlc```

## Install mpc - command line tool to interface MPD
Install mpc:<br/>
```sudo apt install mpc```

## Change the resampling quality (optional)
Edit ```/etc/pulse/daemon.conf``` to resample with a higher quality, e.g.:<br/>
```resample-method = speex-float-7```

Note that this setting will only effect the sound streamed from the client (or played on the client with other audio players). No resamling is taking place when playing with LMS on the server.

## Start the browser automatically when logging in (optional)
Install the desktop file for autostart:<br/>
```install -m 664 lsp-start_browser.desktop /home/<user>/.config/autostart/```

## Select the latest play mode automatically when logging in (optional)
Install the desktop file for autostart:<br/>
```install -m 664 lsp-select_player.sh.desktop /home/<user>/.config/autostart/```

## Install Cairo-Dock (optional)
Note: I haven't got Cairo-Dock working with Wayland on Ubuntu 21.04, but I think it "should" work.

Install Cairo-Dock:<br/>
```sudo apt install cairo-dock```

Create a directory for icons, e.g.:<br/>
```mkdir /home/<user>/bin/icons```

Install the icons:<br/>
```install -m 650 audio_ff.svg lsp_select_player.svg /home/<user>/bin/icons/```

Configure Cairo-Dock so that:
* The button with ```audio_ff.svg``` as icon runs the ```audio_ff.sh``` script.
* The button with ```lsp_select_player.svg``` as icon runs the ```lsp_select_player.sh``` script with ```toggle``` as parameter.

## Install Conky (optional)
You can use Conky to show which play method that is selected. You are on your own with Conky.

You can install this script to tell Conky which player that is selected:<br/>
```install -m 750 conky_streaming.sh /home/<user>/bin/```
