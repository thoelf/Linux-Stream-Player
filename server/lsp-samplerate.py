#!/usr/bin/python3
# -*- coding: utf-8 -*-

# This program extracts the sample rate from SqueezeLite's log messages, 
# through a named pipe. The program updates CamillaDSP with a new configuration 
# file according to the sample rate.

from websocket import create_connection
import json
import yaml

pipe = "/run/squeeze"
port = "1234"
samplerate_old = ""

# Load the template configuration file for CamillaDSP
with open('/etc/camilladsp_squeeze.yml', 'r') as template:
    camilla_conf = yaml.safe_load(template)

# Open the fifo with log message from SqueezeLite
with open(pipe, 'r') as fifo:
    for line in fifo:
        # Look for this string in the log messages from SqueezeLite
        if "track start sample rate:" in line:
            word_list = line.rstrip().split()
            samplerate = word_list[6]
            if samplerate != samplerate_old:
                samplerate_old = samplerate
                camilla_conf['devices']['samplerate'] = int(samplerate)
                # Write the new samplerate to the CamillaDSP config file
                with open('/tmp/camilladsp_squeeze.yml', 'w') as f:
                    yaml.dump(camilla_conf, f)
                # Reload the configuration
                conf = json.dumps({"SetConfigName": "/tmp/camilladsp_squeeze.yml"})
                try:
                    cdsp = create_connection("ws://127.0.0.1:" + port)
                    cdsp.send(conf)
                    cdsp.send(json.dumps("Reload"))
                    cdsp.close()
                except:
                    pass
