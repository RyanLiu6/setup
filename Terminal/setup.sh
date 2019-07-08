#!/bin/sh

# Automatically moving the correct file for you, assuming default installation
if [[ "OSTYPE" == "darwin"* ]]; then
    sudo brew install bash-completion
	cp bash_settings ~/.bash_profile
else
	cp bash_settings ~/.bashrc
fi
