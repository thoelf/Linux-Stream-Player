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
Download the zipped files:<br/>
```wget https://github.com/ralph-irving/squeezelite/archive/refs/heads/master.zip```

Unzip the downloaded file and cd into the unzipped directory.

Compile SquuezeLite:<br/>
```make```

You might not have the necessary packages to run make. Install any missing package and try again.

## Getting the binary file - Alt 2: Download an already compiled file
Download the already compiled program:<br/>
```wget https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/<the release of your choice>```

Unzip the downloaded file and cd into the unzipped directory.

## Install the binary file
Install the binary file:<br/>
```sudo install -m 750 -g audio squeezelite /usr/local/bin```

# CamillaDSP
## Getting the binary file - Alt 1: Compile from source
Download the source code file:<br/>
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Read the instructions on https://github.com/HEnquist/camilladsp to know what is required to compile from source.

Unzip the downloaded file and cd into the unzipped directory.

Compile CamillaDSP with for example this command:<br/>
```RUSTFLAGS='-C target-cpu=native' cargo build --release --no-default-features --features alsa-backend --features websocket```

cd into .../camilladsp-\<version number\>/target/release

## Getting the binary file - Alt 2: Download an already compiled file
Download the compiled program file:<br/>
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Unzip the downloaded file and cd into the unzipped directory.

## Install the binary file
Install the binary file:<br/>
```sudo install -m 750 -g audio camilladsp /usr/local/bin```

## Install the configuration files
TBD

# Install and edit asound.conf
Back up your existing /etc/asound.conf:<br/>
```sudo cp /etc/asound.conf /etc/asound.conf_orig```

Install the asound.conf for LSP:<br/>
```sudo install -m 644 asound.conf_lsp /etc```

Create a link to the file that you want to be active:<br/>
```sudo ln -s /etc/asound.conf_lsp /etc/asound.conf```

Edit asound.conf ... TBD

# Installing the files for LSP
## General
Download the files:<br/>
```wget https://github.com/thoelf/Linux-Stream-Player/archive/refs/heads/main.zip```

Unzip the downloaded file and cd into the unzipped directory.

Install the control scripts:<br/>
```sudo install -m 750 -g audio lasp-control.sh lasp-dac_added.sh lasp-samplerate.py /usr/local/bin```

Install the service definition files:<br/>
```sudo install -m 644 lasp-control.service lasp-samplerate.service squeezelite.service /etc/systemd/system```

Disable the two services that should not autostart:<br/>
```sudo systemctl disable lasp-samplerate.service```<br/>
```sudo systemctl disable squeezelite.service```

Install the file that configures the creation of temporary files at boot:<br/>
```sudo install -m 644 lasp.conf /etc/tmpfiles.d/lasp.conf```

Edit the file and replace "thomas" with your own user name.

## Installation if you are using a USB DAC (not necessary)
Follow this procedure if you want LSP to select the latest play mode after a reboot.

Install the control script:<br/>
```sudo install -m 750 -g audio lasp-dac_added.sh /usr/local/bin```

Install the service definition file:<br/>
```sudo install -m 644 lasp-restore_state.service /etc/systemd/system```

Enable the service:<br/>
```sudo systemctl enable lasp-restore_state.service```

Install the udev rule for the DAC:<br/>
```sudo install -m 644 90-dac.rules /etc/udev/rules.d```

Connect the DAC and power it on, then list your USB devices:<br/>
```lsusb```

Edit the udev rule so that the idVendor and idProduct attribute matches your DAC:<br/>
```sudo nano /etc/udev/rules.d/90-dac.rules```
