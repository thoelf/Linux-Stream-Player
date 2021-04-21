# LMS
If you want to run LMS in a Docker container, you can use this image:<br/>
https://hub.docker.com/r/lmscommunity/logitechmediaserver

Alternatively, download LMS from the link below and then install it:<br/>
https://www.mysqueezebox.com/

When you have LMS up and running, browse to http://\<IP address\>:9000. Install the plugins that you want to use and do any configuration you find suitable. I recommend the plugin for Material Skin.

# MPD
Install MPD from the built-in repositories or from a source of your choice.

There are some configuration to do in /etc/mpd.conf, for example:<br/>
```
audio_output {
	type		"alsa"
	device          "hw:CARD=Loopback,DEV=1"
        format		"*:*:2"
        auto_format	"no"
        auto_resample	"no"
        ...
}
```

How to get the device is TBD.

# SqueezeLite
## Getting the binary file - Alt 1: Compile from source
Download the zipped files with this command:<br/>
```wget https://github.com/ralph-irving/squeezelite/archive/refs/heads/master.zip```

Unzip the downloaded file and cd into the unzipped directory.

Compile SquuezeLite with this command:<br/>
```make```

You might not have the necessary packages to run make. Install any missing package and try again.

## Getting the binary file - Alt 2: Download an already compiled file
Download the already compiled program with his command:<br/>
```wget https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/<the release of your choice>```

Unzip the downloaded file and cd into the unzipped directory.

## Install the binary file
Install the binary file:<br/>
```sudo install -m 750 -g audio squeezelite /usr/local/bin```

# CamillaDSP
## Getting the binary file - Alt 1: Compile from source
Download the source code file with this command:<br/>
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Read the instructions on https://github.com/HEnquist/camilladsp to know what is required to compile from source.

Unzip the downloaded file and cd into the unzipped directory.

Compile CamillaDSP with for example this command:<br/>
```RUSTFLAGS='-C target-cpu=native' cargo build --release --no-default-features --features alsa-backend --features websocket```

cd into .../camilladsp-\<version number\>/target/release

## Getting the binary file - Alt 2: Download an already compiled file
Download the compiled program file with this command:<br/>
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Unzip the downloaded file and cd into the unzipped directory.

## Install the binary file
Install the binary file with this command:<br/>
```sudo install -m 750 -g audio camilladsp /usr/local/bin```

## Install the configuration files
TBD

# Installing the files for LSP
## General
Download the files from this page with this command:<br/>
```wget https://github.com/thoelf/Linux-Stream-Player/archive/refs/heads/main.zip```

Unzip the downloaded file and cd into the unzipped directory.

Install the control scripts with this command:<br/>
```install -m 750 -g audio lasp-control.sh lasp-dac_added.sh lasp-samplerate.py /usr/local/bin```

Install the service definition files with this command:<br/>
```install -m 644 lasp-control.service lasp-samplerate.service squeezelite.service /etc/systemd/system```

## Installation if you are using a USB DAC (not necessary)
If follow this procedure, LSP will select the latest play mode after a reboot.

Install the control script with this command:<br/>
```install -m 750 -g audio lasp-dac_added.sh /usr/local/bin```

Install the service definition file with this command:<br/>
```install -m 644 lasp-restore_state.service /etc/systemd/system```

List your USB devices with this command:<br/>
```lsusb```

Edit the file [90-dac.rules](./90-dac.rules) so that the idVendor and idProduct attribute matches your DAC.

Install the udev rule with this command:<br/>
```install -m 644 90-dac.rules /etc/udev/rules.d```
