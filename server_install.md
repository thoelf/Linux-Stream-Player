# LMS
If you want to run LMS in a Docker container, you can use this image:
https://hub.docker.com/r/lmscommunity/logitechmediaserver

Alternatively, download LMS from the link below and then install it:
https://www.mysqueezebox.com/

When you have LMS up and running, browse to http://<IP address>:9000. Install the plugins that you want to use and do any configuration you find suitable. I recommend the plugin for Material Skin.

# MPD
Install MPD from the built-in repositories or from a source of your choice.

There are some configuration to do with MPD, for example:

```audio_output {
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
Download the zipped files from with this command:

```wget https://github.com/ralph-irving/squeezelite/archive/refs/heads/master.zip```

Unzip and cd into the unzipped directory.

Compile SquuezeLite with this command:
```make```

You might not have the necessary packages to run make. Install any missing package and try again.

## Getting the binary file - Alt 2: Download an already compiled file
Download the already compiled program with his command:
```wget https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/<the release of your choice>```

Unzip and cd into the unzipped directory.

## Install the binary file
Install the binary file:
```sudo install -m 750 -g audio /usr/local/bin```

# CamillaDSP
## Compiling from source - alt 1
Download the source code file with this command:
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Read the instructions on https://github.com/HEnquist/camilladsp to know what is required to compile from source.

Unzip the file and cd into the unzipped directory.

Compile CamillaDSP with for example this command:
```RUSTFLAGS='-C target-cpu=native' cargo build --release --no-default-features --features alsa-backend --features websocket```

cd into .../camilladsp-<version number>/target/release

## Downloading the binary file - alt 2
Download the compiled program file with this command:
```wget https://github.com/HEnquist/camilladsp/releases/<the release of your choice>```

Unzip the file and cd into the unzipped directory.

## Install the binary file
```sudo install -m 750 -g audio camilladsp /usr/local/bin```

# Installing the files for LSP
Download the files from this page (https://github.com/thoelf/Linux-Stream-Player) with this command:
```wget https://github.com/thoelf/Linux-Stream-Player/archive/refs/heads/main.zip```

Unzip the file and cd into the unzipped directory.

Install the control scripts with this command:
```install -m 750 -g audio lasp-control.sh lasp-dac_added.sh lasp-samplerate.py /usr/local/bin```

Install the service definition files with this command:
```install -m 644 lasp-control.service lasp-restore_state.service lasp-samplerate.service```
