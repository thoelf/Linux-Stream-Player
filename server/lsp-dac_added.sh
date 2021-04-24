#!/usr/bin/bash

# Relates to:
# /etc/udev/rules.d/90-dac.rules
# /etc/systemd/system/lsp-restore_state.service

/usr/bin/sleep 2
/usr/local/bin/lasp-control.sh stop
/usr/bin/sleep 2
/usr/local/bin/lasp-control.sh $(head -1 /var/tmp/lasp-player)
