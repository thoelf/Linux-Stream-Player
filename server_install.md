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

List your ALSA devices:<br/>
```aplay -l```

Edit ```/etc/mpd.conf``` and add the device number for the DAC in the ```audio_output``` section.

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
There might be other settings you might want, or have, to do in ```/etc/mpd.conf```.

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

cd into ```.../camilladsp-<version number>/target/release```

## Getting the binary file - Alt 2: Download an already compiled file
Download the compiled program file:<br/>
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Unzip the downloaded file and cd into the unzipped directory.

## Install the binary file
Install the binary file:<br/>
```sudo install -m 750 -g audio camilladsp /usr/local/bin```

## Install the service file
Install the service file:<br/>
```sudo install -m 644 camilladsp.service /etc/systemd/system```

Replace any occurence of ```<user>``` with the user you want to run the services (yourself or a system user).

## Install and edit the configuration files
Install the example files for CamillaDSP:<br/>
```sudo install -m 644 -g audio camilladsp_44100_squeeze.yml camilladsp_44100.yml /etc```

Edit the filter settings to suit your needs. Add more file for the samplerates you want to support.

Create a link to the configuration file you want to be default when playing with MPD, e.g.:
```sudo ln -s /etc/camilladsp_44100.yml /etc/camilladsp.yml```

# Install a loopback interface
The loopback interface is used for CamillaDSP when streaming from the client, i.e. playing with MPD on the server.

Load the loopback kernel module:<br/>
```sudo modprobe snd-aloop```

If ```/etc/modules-load.d/aloop.conf``` is not present, create the file with this content:<br/>
```
# alsa loopback
snd
snd-timer
snd-pcm
snd-aloop
```

# Install and edit asound.conf
Back up your existing ```/etc/asound.conf```:<br/>
```sudo cp /etc/asound.conf /etc/asound.conf_orig```

Install the file ```asound.conf``` for LSP:<br/>
```sudo install -m 644 asound.conf_lsp /etc```

Create a link to the file that you want to be active:<br/>
```sudo ln -s /etc/asound.conf_lsp /etc/asound.conf```

List your ALSA devices:<br/>
```aplay -l```

Edit ```asound.conf``` (or ```asound.conf_lsp```) so that:
* The device number in the ```pcm.camilladsp``` section equals the card number for the Loopback device in the previous step.
* The card number in the ```pcm.sound_out``` and ```ctl.sound_out``` section equals the card number for the DAC in the previous step.

# Installing the files for LSP
## General
Download the files:<br/>
```wget https://github.com/thoelf/Linux-Stream-Player/archive/refs/heads/main.zip```

Unzip the downloaded file and cd into the unzipped directory.

Install the control scripts:<br/>
```sudo install -m 750 -g audio lsp-control.sh lsp-samplerate.py /usr/local/bin```

Install the service definition files:<br/>
```sudo install -m 644 lsp-control.service lsp-samplerate.service squeezelite.service /etc/systemd/system```

Replace any occurence of ```<user>``` with the user you want to run the services (yourself or a system user).

Edit ```squeezelite.service``` so that the sample rate range and IP address matches your system.

Add the sudo rules, for a user other than root to be able to manage the services:<br/>
```install -m 440 lsp-sudo /etc/sudoers.d```

Edit ```lsp-sudo``` using ```visudo``` and replace any occurence of ```<user>``` with the user you want to run the services (yourself or a system user).

Enable the lsp-control service:<br/>
```sudo systemctl enable lsp-control.service```

Install the file that configures the creation of temporary files at boot:<br/>
```sudo install -m 644 lsp.conf /etc/tmpfiles.d/lsp.conf```

Replace any occurence of ```<user>``` with the user you want to run the services (yourself or a system user).

## Make your selected user member of the audio group
Add your user to the audio group:<br/>
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

Edit the udev rule so that the idVendor and idProduct attribute matches your DAC:<br/>
```sudo nano /etc/udev/rules.d/90-dac.rules```
