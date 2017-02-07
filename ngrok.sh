#!/usr/bin/env bash

echo ">>> Installing ngrok"

wget https://bin.equinox.io/c/4VmDzA7iaHb/ngrok-stable-linux-amd64.zip
dtrx --one here ngrok-stable-linux-amd64.zip
sudo mv ngrok /usr/bin/ngrok
rm ngrok-stable-linux-amd64.zip
