#!/bin/bash
# This service is controlled by /etc/systemd/system/lsp-control.service
# The script receives commands from lsp_select_player.sh on the client through port 40002

if [[ $# -eq 0 ]]; then
    args=""
elif [[ $# -eq 1 && ($1 = mpd || $1 = squeeze || $1 = stop ) ]]; then
    action=$1
    args=True
else
    echo "Usage: $0 <mpd|squeeze|stop>"
    exit 1
fi

while :; do
    if ! [[ $args ]]; then
        read action < <(netcat -l 40002)
    fi

    if [[ $action = mpd ]]; then
	echo mpd > /var/tmp/lsp-player
	sudo /usr/bin/systemctl stop squeezelite.service
        sudo /usr/bin/systemctl stop lsp-samplerate.service
        sudo /usr/bin/systemctl restart mpd.service
    elif [[ $action = squeeze ]]; then
	echo squeeze > /var/tmp/lsp-player
	sudo /usr/bin/systemctl stop mpd.service
	sudo /usr/bin/systemctl restart squeezelite.service
	sudo /usr/bin/systemctl restart lsp-samplerate.service
    elif [[ $action = stop ]]; then
	echo stop > /var/tmp/lasp-player
        sudo /usr/bin/systemctl stop mpd.service
	sudo /usr/bin/systemctl stop squeezelite.service
        sudo /usr/bin/systemctl stop lsp-samplerate.service
    fi
    [[ $args ]] && break
done
