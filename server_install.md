# LMS
If you want to run LMS in a Docker container, you can use this image:<br/>
https://hub.docker.com/r/lmscommunity/logitechmediaserver

Alternatively, download LMS from the link below and then install it:<br/>
https://www.mysqueezebox.com/

I prefer to run LMS in Docker. It gives a clean install and the image is updated regulary.

When you have LMS up and running, browse to ```http://<IP address>:9000```. Install the plugins that you want to use and do any configuration you find suitable. I recommend the plugin for Material Skin.

# MPD
Install MPD:<br/>
```sudo apt install mpd```

Edit ```/etc/mpd.conf``` to pipe the stream to CamillaDSP.

```
audio_output {
	type		"pipe"
	name            "mpd_pipe"
	format		"*:32:2"
	command         "/usr/local/bin/camilladsp -p 1234 /etc/camilladsp.yml"
        ...
}
```
There might be other settings you might want to do in this file.

# SqueezeLite
## Getting the binary file - Alt 1: Compile from source
Download the zipped files:<br/>
```wget https://github.com/ralph-irving/squeezelite/archive/refs/heads/master.zip```

Extract the downloaded file and cd into the extracted directory.

Compile SquuezeLite:<br/>
```make```

You might not have the necessary packages to run make. Install any missing package and try again.

## Getting the binary file - Alt 2: Download an already compiled file
Download the already compiled program:<br/>
```wget https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/<the release of your choice>```

Extract the downloaded file and cd into the extracted directory.

## Install the binary file
Install the binary file:<br/>
```sudo install -m 750 -g audio squeezelite /usr/local/bin```

# CamillaDSP
## Getting the binary file - Alt 1: Compile from source
Download the source code file:<br/>
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Read the instructions on https://github.com/HEnquist/camilladsp to know what is required to compile from source.

Extract the downloaded file and cd into the extracted directory.

Compile CamillaDSP with for example this command:<br/>
```RUSTFLAGS='-C target-cpu=native' cargo build --release --no-default-features --features alsa-backend --features websocket```

cd into ```.../camilladsp-<version number>/target/release```

## Getting the binary file - Alt 2: Download the already compiled program
Download the compiled program file:<br/>
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Extract the downloaded file and cd into the extracted directory.

## Install the binary file
Install the binary file:<br/>
```sudo install -m 750 -g audio camilladsp /usr/local/bin```

## Install and edit the configuration file
Install the example file:<br/>
```sudo install -m 644 -g audio camilladsp.yml /etc```

The samplerate in the file is the default samplerate. When playing with LMS/SqueezeLite, CamillaDSP will be updated with new a samplerate when the samplerate of the source changes. When streaming from the client, the samplerate is static, as defined in the file.

Edit the number in the ```device``` parameter, so that it matches the ouput of this command:<br/>
```cat /proc/asound/cards```

Edit the filter settings and add more filters to suit your needs.

# Install the pyCamillaDSP library and the python3-websocket module
This installation is made to let ```lsp-samplerate.py``` update CamillaDSP with the samplerate, when playing from LMS/SqueezeLite.

Download pyCamillaDSP:<br/>
```wget https://github.com/HEnquist/pycamilladsp/releases/<the release of your choice>```

Extract the downloaded file and cd into the extracted directory.

Install pyCamillaDSP (for all users):<br/>
```sudo pip3 install .```

Install the python3-websocket package:<br/>
```sudo apt install python3-websocket```

# Editing asound.conf
Edit the contents of asound.conf, so that the card number matches the ```device``` parameter in ```/etc/camilladsp.yml```:

```
pcm.!default {
        type hw
        card <number>
}

ctl.!default {
        type hw           
        card <number>
}
```
Depending on your configuration and knowledge, the file might look different.

# Installing the files for LSP
## General
Download the files:<br/>
```wget https://github.com/thoelf/Linux-Stream-Player/archive/refs/heads/main.zip```

Extract the downloaded file and cd into the extracted directory.

Install the control scripts:<br/>
```sudo install -m 750 -g audio lsp-control.sh lsp-samplerate.py /usr/local/bin```

Install the service definition files:<br/>
```sudo install -m 644 lsp-control.service lsp-samplerate.service squeezelite.service /etc/systemd/system```

Replace any occurence of ```<user>``` with the user you want to run the services (yourself or a system user).

Edit ```squeezelite.service``` so that the samplerate range and IP address matches your system.

Install the file with sudo rules, so that a user other than root can manage the services:<br/>
```install -m 440 lsp-sudo /etc/sudoers.d```

Edit ```lsp-sudo``` using ```visudo``` and replace any occurence of ```<user>``` with the user you want to manage the services. The user must be the same user that runs ```lsp-control.sh``` according to ```lsp-control.service```.

Enable the lsp-control service:<br/>
```sudo systemctl enable lsp-control.service```

Install the file that configures the creation of temporary files at boot:<br/>
```sudo install -m 644 lsp.conf /etc/tmpfiles.d/lsp.conf```

Replace any occurence of ```<user>``` with the user you want to run the services (yourself or a system user).

## Make your selected user member of the audio group
Add your user to the ```audio``` group:<br/>
```sudo usermod -aG audio <user>```

## Installation if you are using a USB DAC (optional)
Follow this procedure if you want LSP to select the latest play mode after a reboot.

Install the control script:<br/>
```sudo install -m 750 -g audio lsp-dac_added.sh /usr/local/bin```

Install the service definition file:<br/>
```sudo install -m 644 lsp-restore_state.service /etc/systemd/system```

Enable the service:<br/>
```sudo systemctl enable lsp-restore_state.service```

Install the udev rule for the DAC:<br/>
```sudo install -m 644 90-dac.rules /etc/udev/rules.d```

Connect the DAC and power it on, then list your USB devices:<br/>
```lsusb```

Edit the udev rule so that the ```idVendor``` and ```idProduct``` attribute matches your DAC:<br/>
```sudo nano /etc/udev/rules.d/90-dac.rules```
