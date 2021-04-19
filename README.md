# Linux Stream Player
## Introduction
LSP is a set of scripts, third party programs and configurations that allows you to play music on a headless Linux computer, from now on called the "server". You can control the music from a mobile app or a from web browser on a Linux computer, from now on called the "client".

LSP is tested to work with Ubuntu server 20.04 as OS the server and Ubuntu Desktop 20.10 as OS on the client.

LSP is designed to meet my personal goals for how I want to play music at home. The intention is not to make a solution for all sorts of use cases or to support other platforms and aplications that the ones I use. Nevertheless, with some tweaking you should be able to adopt it to your needs.

## DSP with CamillaDSP
LSP uses CamillaDSP for room EQ. For more information about CamillaDSP, refer to https://github.com/HEnquist/pycamilladsp and https://www.diyaudio.com/forums/pc-based/349818-camilladsp-cross-platform-iir-fir-engine-crossovers-correction-etc.html.

I have got my filter parameters from measurements using a USB microphone and REW, refer to https://www.roomeqwizard.com/.

CamillaDSP is in the audio chain in both use cases described below.

## Playing music locally on the server
LSP uses Logitech Media Server (LMS) with SqueezeLite as the player. Both programs are installed on the server and plays local and streamed music. My source of streamed music is Deezer, but other streaming services are supported and available as plugins to LMS.

To make a base configuration of Logitech Media Server and SqueezeLite, refer to TBD.

SqueezeLite is controlled from a mobile app, for example https://play.google.com/store/apps/details?id=com.angrygoat.android.squeezectrl and from a web browser on the LSP client.

The audio stream to the DAC has the same sample frequency as the source, i.e. no resampling.

## Playing music on the client and streaming it to the server
LSP supports streaming music from the client to the server. I use Firefox to stream music from the Deezer webpage.

If you prefer Spotify, you might be better off with the Spotify application for Linux on your client and spotifyd on the server. This works very well. If you follow that path, LSP might not be of great use for you.

You can of cource use only Logitech Media Server and SqueezeLite for your audio streaming, but then you cannot have the same user interface that for example Deezer provides via its web page. I have come to use Logitech Media Server the most, but it can be good to have the ability to stream direct from the client.

In LSP, Firefox streams to MPD on the server. Then MPD plays the music on the server. The audio stream is filtered by CamillaDSP.

The music that is streamed from the client to the server is silent on the client. I can still play audio on the client from other audio players outside LSP.

I use Firefox for this particular purpose, just to make my preferred browser (Brave) free for all other browsing activities.

The audio stream is resampled to 44.1 kHz on the client.

## Summing up the introduction
LSP lets you:
* Use your mobile phone or Linux computer to let SqueezeLite play music on your Linux server.
* Stream audio from a web browser on your Linux computer to MPD on your Linux Server.

In both cases, the audio stream is processed by CamillaDSP for room EQ.

The audio stream is not resampled when played by Squeezelite.
