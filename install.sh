#!/bin/sh

if [ ! -d ~/.config/jarvis ]; then
	mkdir ~/.config/jarvis
fi

# copy basic config file to /home/user/.config/jarvis/.config
cp .config ~/.config/jarvis/