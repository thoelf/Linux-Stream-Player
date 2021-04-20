# Introduction to the Linux Stream Player (LSP)
LSP is a set of scripts, third party programs and configurations that allows you to play music on a headless Linux computer, from now on called the "server". You can control the music from a mobile app or a from web browser on a Linux computer, from now on called the "client".

LSP is designed to meet my personal goals for how I want to play music at home. The intention is not to make a solution for all sorts of use cases or to support other platforms and applications that the ones I use. Nevertheless, with some tweaking you should be able to adopt it to your needs.

LSP is tested to work with Ubuntu Server 20.04 on the server and Ubuntu Desktop 20.10 on the client.

# Playing music locally on the server
LSP uses LMS (Logitech Media Server) with SqueezeLite as the player. Both programs are installed on the server and plays local and streamed music. My source of streamed music is Deezer, but other streaming services are supported and available as plugins to LMS.

Personally, I prefer to run LMS in a Docker container. LMS can also be installed as a .deb file.

SqueezeLite can be controlled from a web browser on the client or from a mobile app, for example the LMS app. The LMS app requires you to use Material Skin as a plugin to LMS (the server). Material Skin is strongly recommended, because its beautiful, and is easily installed from the browser when you have installed LMS (the server).

The audio stream is piped from SqueezeLite via CamillaDSP (for room EQ) to the DAC, with the same sample frequency as the source, i.e. without resampling.

# Playing music on the client and streaming it to the server
LSP supports streaming music from the client to the server. I use Firefox to stream music from the Deezer webpage.

If you prefer Spotify, you might be better off with the Spotify application for Linux on the client and spotifyd on the server. This works very well. If you follow that path, LSP might not be of great use for you.

You can of cource use only LMS and SqueezeLite for your audio streaming, but then you cannot use the user interface that for example Deezer provides via its web page. I have come to use LMS the most, but it can be good to have the ability to stream direct from the client.

When streaming from a browser, the environment for the browser is set up so that the browser plays to the nullsink. The audio sent to the nullsink is inaudible on the client. An audio stream is set up from the nullsink using cvlc. The stream goes to MPD on the server, that streams the audio via CamillaDSP (for room EQ) to the DAC.

I use Firefox as the music playing browser, just to make my preferred browser (Brave) free for all other browsing activities. While streaming to the nullsink on the client, is is possible to play audio on the client from other audio players.

The audio stream is resampled to 44.1 kHz on the client. You should be able to change the sample rate to another static value if you like. If you have any suggestions to stream with a variable sample frequency (i.e. matching the source), please let me know. In my case with Deezer, the source is always 44.1 kHz, so its not a concern for me.

# Controlling LSP
When all is set up and working, the browser is started from Cairo dock. Clicking on the icon in the dock runs a script that sets the nullsink for the browser and then starts the browser.

Another button on the dock is the stream selection button, which runs a script that toggles between the two streaming methods.

# Room EQ with CamillaDSP
LSP uses CamillaDSP for room EQ. I have got my filter parameters from measurements using a USB microphone and REW. When starting out, you can start with no filters and then add filters in the future.

# Links
* [LMS on Docker hub](https://hub.docker.com/r/lmscommunity/logitechmediaserver)
* [LMS as a .deb file](https://www.mysqueezebox.com/download)
* [The LMS app on F-Droid](https://f-droid.org/en/packages/com.craigd.lmsmaterial.app/)
* [Material Skin for LMS](https://github.com/CDrummond/lms-material)
* [SqueezeLite on GitHub](https://github.com/ralph-irving/squeezelite)
* [SqueezeLite (executable) on Sourceforge](https://sourceforge.net/projects/lmsclients/files/squeezelite/linux/)
* [CamillaDSP on GitHub](https://github.com/HEnquist/camilladsp)
* [CamillaDSP on diyAudio](https://www.diyaudio.com/forums/pc-based/349818-camilladsp-cross-platform-iir-fir-engine-crossovers-correction-etc.html)
* [Room EQ Wizard, REW](https://www.roomeqwizard.com/)

# A note about the software used or referenced
The software in LSP and all software used by LSP, is free and open source software. The REW software, which is not strictly needed, is closed source software that is free of cost, i.e. freeware.

# To be continued ...
Files and an installation procedure will be added in the near future.
