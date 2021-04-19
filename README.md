# Linux Stream Player (LSP)
## Introduction
LSP is a set of scripts, third party programs and configurations that allows you to play music on a headless Linux computer, from now on called the "server". You can control the music from a mobile app or a from web browser on a Linux computer, from now on called the "client".

LSP is designed to meet my personal goals for how I want to play music at home. The intention is not to make a solution for all sorts of use cases or to support other platforms and applications that the ones I use. Nevertheless, with some tweaking you should be able to adopt it to your needs.

LSP is tested to work with Ubuntu Server 20.04 on the server and Ubuntu Desktop 20.10 on the client.

## Room EQ with CamillaDSP
LSP uses CamillaDSP for room EQ. For more information about CamillaDSP, refer to [CamillaDSP on GitHub](https://github.com/HEnquist/camilladsp)
and [CamillaDSP on diyAudio](https://github.com/HEnquist/pycamilladsp).

I have got my filter parameters from measurements using a USB microphone and REW, refer to [Room EQ Wizard](https://www.roomeqwizard.com/).

## Playing music locally on the server
LSP uses LMS (Logitech Media Server) with SqueezeLite as the player. Both programs are installed on the server and plays local and streamed music. My source of streamed music is Deezer, but other streaming services are supported and available as plugins to LMS.

SqueezeLite can be controlled from a mobile app, for example [LMS on F-Droid](https://f-droid.org/en/packages/com.craigd.lmsmaterial.app/) and from a web browser on the client.

The audio stream to the DAC has the same sample frequency as the source, i.e. no resampling.

## Playing music on the client and streaming it to the server
LSP supports streaming music from the client to the server. I use Firefox to stream music from the Deezer webpage.

If you prefer Spotify, you might be better off with the Spotify application for Linux on the client and spotifyd on the server. This works very well. If you follow that path, LSP might not be of great use for you.

You can of cource use only LMS and SqueezeLite for your audio streaming, but then you cannot have the same user interface that for example Deezer provides via its web page. I have come to use LMS the most, but it can be good to have the ability to stream direct from the client.

The audio stream is resampled to 44.1 kHz on the client.

## Controlling LSP
When all is set up and working, Firefox is started from Cairo dock.

I select play method by clicking on an icon in Cairo dock.

## Summing up the introduction
* You can use your mobile phone or Linux computer to let LMS/SqueezeLite play music on your Linux server. The audio stream is not resampled.
* You can stream music from a web browser on your Linux computer to MPD on your Linux Server. The audio stream is resampled to 44.1 kHz.
* The audio stream is processed by CamillaDSP for room EQ.

# More details...
## Playing music locally on the server

The LMS app requires you to use MaterialSkin as a plugin to LMS (the server). Material Skin [Material Skin](https://github.com/CDrummond/lms-material) is strongly recommended and is easily installed from the browser when you have installed LMS (the server).

## Playing music on the client and streaming it to the server
When streaming from a browser, the environment for the browser is set up so that the web browser plays to the nullsink. An audio stream is set up from the nullsink using cvlc. The stream goes to MPD on the server, that streams the audio via CamillaDSP to the DAC. 

The audio sent to the nullsink is inaudible on the client. Is is possible to play audio on the client from other audio players while streaming to the nullsink.
I use Firefox as the music playing browser, just to make my preferred browser (Brave) free for all other browsing activities.

## Controlling LSP
The browser is started from the Cairo dock. This is becasue the environment for the browser must be set up, in order for it to stream to the nullsink.

Another button on the dock is the stream selection button, which runs a script that toggles between the two streaming methods.

# The files and their function in LSP
## client
### /home/\<user\>/bin/
audio_ff.sh:
conky_streaming.sh:
lasp-select_player.sh:

## server
### /usr/local/bin/
* camilladsp: The CamillaDSP binary file. Get it from the link above.
* camilladsp_version.txt: The version of CamillaDSP. *** .gitignore
* lasp-dac_added.sh: 
* lasp-samplerate.py: Detect the sample rate from SqueezeLite and select the applicable config file for CamillaDSP.
* squeezelite: The SqueezeLite binary file.
* squeezelite_version.txt: The version of SqueezeLite. *** .gitignore

### /etc/systemd/system/
lasp-control.service:
lasp-restore_state.service:
lasp-samplerate.service:
squeezelite.service: 

### /etc/udev/rules.d/
90-dac.rules:
