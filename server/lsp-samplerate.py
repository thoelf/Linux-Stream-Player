#!/usr/bin/python3
# -*- coding: utf-8 -*-

# /etc/systemd/system/lsp-samplerate.service

# This program extracts the sample rate from SqueezeLite's log messages, 
# through a named pipe. The program updates CamillaDSP with a new configuration 
# file according to the sample rate.

from camilladsp import CamillaConnection

config_file = "/etc/camilladsp_squeeze.yml"
pipe = "/run/squeeze"
port = 1234
samplerate_old = ""

cdsp = CamillaConnection("127.0.0.1", port)

try:
    cdsp.connect()
    conf = cdsp.read_config_file(config_file)
except ConnectionRefusedError as e:
    print("Cannot connect to CamillaDSP. Is it running? Error:", e)
except CamillaError as e:
    print("CamillaDSP replied with error:", e)
except IOError as e:
    print("Not connected to websocket:", e)

# Open the fifo with log messages from SqueezeLite
with open(pipe, 'r') as fifo:
    for line in fifo:
        # Look for the samplerate in the log messages from SqueezeLite
        if "track start sample rate:" in line:
            word_list = line.rstrip().split()
            samplerate = word_list[6]
            if samplerate != samplerate_old:
                samplerate_old = samplerate
                conf['devices']['samplerate'] = int(samplerate)
                # Update CamillaDSP with the new samplerate
                try:
                    cdsp.set_config(conf)
                except ConnectionRefusedError as e:
                    print("Cannot connect to CamillaDSP. Is it running? Error:", e)
                except CamillaError as e:
                    print("CamillaDSP replied with error:", e)
                except IOError as e:
                    print("Not connected to websocket:", e)
