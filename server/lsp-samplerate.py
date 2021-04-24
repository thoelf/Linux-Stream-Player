#!/usr/bin/python3
# -*- coding: utf-8 -*-

# This program extracts the sample rate from SqueezeLite's log messages, 
# through a named pipe. The program updates CamillaDSP with a new configuration 
# file according to the sample rate.

from websocket import create_connection
import json

pipe = "/run/squeeze"
port = "1234"
samplerate_old = ""

with open(pipe, 'r') as fifo:
    for line in fifo:
        if "track start sample rate:" in line:
            word_list = line.rstrip().split()
            samplerate = word_list[6]
            if samplerate != samplerate_old:
                samplerate_old = samplerate
                conf = json.dumps({"SetConfigName": "/etc/camilladsp_" + samplerate + "_squeeze.yml"})
                try:
                    cdsp = create_connection("ws://127.0.0.1:" + port)
                    cdsp.send(conf)
                    cdsp.send(json.dumps("Reload"))
                    cdsp.close()
                except:
                    pass
