# Installing LSP on the client
## Install the scripts for LSP
Create a directory for scripts, e.g.:<br/>
```mkdir /home/<user>/bin```

Install the script for selecting play method:<br/>
```install -m 750 lsp-select_player.sh /home/<user>/bin```

Install the script that sets the nullsink and starts the browser:<br/>
```install -m 750 audio_ff.sh /home/<user>/bin```

Find the pulse source:<br/>
```pactl list | grep -A2 'Source #' | grep 'Name: ' | cut -d" " -f2 | head -1```

Edit audio_ff.sh and replace the existing pulse source with the output from the command above. You can also change the browser if you like.

Create the directory for the configuration files:<br/>
```mkdir /home/<user>/.lsp```

Note that the directory is hidden.

Install the configuration file for LSP on the client:<br/>
```install -m 640 lsp.conf /home/<user>/.lsp```

Edit lsp.conf and add the missing data.

The .lsp direcory will also include an automatically created file named selected_player.txt. The file includes "mpd" or "squeeze" depending on the selected play method.

## Install Cairo dock (optional)
Install the Cairo-Dock package from the repositories.

Create a directory for icons, e.g.:<br/>
```mkdir /home/<user>/bin/icons```

Install the icons:<br/>
```install -m 650 audio_ff.svg lsp_select_player.svg /home/<user>/bin/icons```

Configure Cairo dock so that:
* The button with audio_ff.svg as icon runs the audio_ff.sh script.
* The button with lsp_select_player.svg as icon runs the lsp_select_player.sh script.

## Install Conky (optional)
You can use Conky to show which play method that is selected. You are on your own with Conky.

You can install this script to tell Conky which player that is selected:<br/>
```install -m 750 conky_streaming.sh /home/<user>/bin```
