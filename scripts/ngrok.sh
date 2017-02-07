#!/usr/bin/env bash

echo ">>> Installing ngrok"

wget -q https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
dtrx --one here ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/sbin/ngrok
rm ngrok-stable-linux-amd64.zip
