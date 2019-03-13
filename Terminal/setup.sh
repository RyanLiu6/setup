#!/bin/sh

# Automatically moving the correct file for you, assuming default installation
if [[ "OSTYPE" == "darwin"* ]]; then
    sudo brew install bash-completion
	cp .bash ~/.bash_profile
else
	cp .bash ~/.bashrc
fi
