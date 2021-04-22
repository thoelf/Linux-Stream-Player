#!/bin/bash

# Read the arguments
ACTION=$1
if ! [[ $# -eq 1 && ($ACTION = mpd || $ACTION = squeeze || $ACTION = toggle) ]]; then
    echo "Usage: $0 <mpd|squeeze|toggle>"
    exit 1
fi

# Source the settings file
. $HOME/.lsp/lsp.conf

# Check if the port for player selection is available
if ! echo > /dev/tcp/$LSP_SERVER/$PLAYER_SELECT_PORT; then
    notify-send --icon=dialog-warning "AUDIO STREAMING" "The port for player selection on the server is not available."
    exit 1
fi

# Get VLC streaming status
ps -ef | grep vlc | grep null.monitor >/dev/null && STREAMING=True || STREAMING=""

# Play with MPD
if [[ $ACTION = mpd || ($ACTION = toggle && ! $STREAMING) ]]; then
    # Start MPD and CamillaDSP on the server
    netcat -q0 $LSP_SERVER $PLAYER_SELECT_PORT echo <<< mpd
    echo mpd > $HOME/.lsp/selected_player.txt
    notify-send "AUDIO STREAMING" "Player: MPD"

    # If the null sink module is not loaded, load it
    pactl list short | grep null.monitor >/dev/null || pactl load-module module-null-sink

    # If not already streaming, start the stream
    if ! [[ $STREAMING ]]; then
        cvlc -q pulse://null.monitor \
        --network-caching=40 \
        --sout "#transcode{\
        	vcodec=none,\
        	acodec=flac,\
        	channels=2}\
        	:standard{\
        	access=http,\
        	name=$STREAM_NAME,\
        	mime=audio/flac,\
        	dst=$LOCAL_IP:$LOCAL_PORT/$STREAM_NAME}" &
        sleep 2
        mpc --host=$MPD_PW@$LSP_SERVER --port=$MPD_PORT clear >/dev/null
        mpc --host=$MPD_PW@$LSP_SERVER --port=$MPD_PORT add http://$LOCAL_IP:$LOCAL_PORT/$STREAM_NAME >/dev/null
        mpc --host=$MPD_PW@$LSP_SERVER --port=$MPD_PORT play >/dev/null
    fi
# Play with Squeeze
elif [[ $ACTION = squeeze || ($ACTION = toggle && $STREAMING) ]]; then
    mpc --host=$MPD_PW@$LSP_SERVER --port=$MPD_PORT stop >/dev/null
    netcat -q0 $LSP_SERVER $PLAYER_SELECT_PORT echo <<< squeeze
    echo squeeze > $HOME/.lsp/selected_player.txt
    notify-send "AUDIO STREAMING" "Player: SqueezeLite"
    [[ $STREAMING ]] && kill $(ps -ef | grep vlc | grep null.monitor | awk '{ print $2 }')
fi
