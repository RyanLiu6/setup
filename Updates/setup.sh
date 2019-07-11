#!/bin/bash
cp xyz.ryanliu6.update.plist ~/Library/LaunchAgents/
cd ~/Library/LaunchAgents/
launchctl load xyz.ryanliu6.update.plist
