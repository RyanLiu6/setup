#!/bin/sh

# Automatically moving the correct file for you, assuming default installation
# Assume if not Mac OS X, then Windows (No love for Linux)
if 	[[ "OSTYPE" == "darwin"* ]]; then
	cp settings.json ~/Library/Application Support/Code/User/settings.json
	cp keybindings.json.mac ~/Library/Application Support/Code/User/keybindings.json
#else
#	cp settings.json %APPDATA%/Code/User/settings.json
#	cp keybindings.json.windows %APPDATA%/Code/User/keybindings.json
fi
