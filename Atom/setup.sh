#!/bin/sh

# Installing the theme I prefer
apm install bliss-ui
apm install bliss-syntax

# Automatically moving the correct file for you, assuming default installation
cp config.cson ~/.atom/config.cson
cp styles.less ~/.atom/styles.less

if [[ "OSTYPE" == "darwin"* ]]; then
	cp keymap.cson.mac ~/.atom/keymap.cson
else
	cp keymap.cson.windows ~/.atom/keymap.cson
fi
