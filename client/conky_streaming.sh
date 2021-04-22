#!/bin/bash

[[ $(ps -ef | grep vlc | grep "null.monitor" | awk '{ print $2 }') ]] && echo MPD || echo Squeeze
