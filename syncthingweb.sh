#!/bin/bash

# Arch
arch="arm"
[[ "$(arch)" == *"arm"* && "$(arch)" == *"64"* ]] && arch="arm64"
syncthing_excutable="syncthing-linux-${arch}"

# Start syncthing if not already running
pgrep -u "$USER" -x "$syncthing_excutable" > /dev/null || "$syncthing_excutable" -no-browser &

# Sleep till WebUI responds
until $(wget -O "/dev/null" -q "http://127.0.0.1:8384"); do sleep 1; done

# Open Syncthing in Ubuntu Touch webapp container
webapp-container --webappUrlPatterns="https?://127.0.0.1:8384/*" "http://127.0.0.1:8384/" %u

