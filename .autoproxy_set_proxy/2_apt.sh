#!/usr/bin/env bash

# modify /etc/apt/apt.conf

# remove the special group entry in /etc/bash.bashrc, if it exists
sed '/# -= autoproxy config, DO NOT EDIT MANUALLY =-/,/# -= autoproxy config =-/d' /etc/apt/apt.conf|sudo tee /etc/apt/apt.conf > /dev/null

# create it again, with proper values
sudo bash -c 'echo "# -= autoproxy config, DO NOT EDIT MANUALLY =-" >> /etc/apt/apt.conf'
sudo bash -c 'echo "Acquire::http::proxy \"'"$AP_HTTPS_PROXY"'/\";">> /etc/apt/apt.conf'
sudo bash -c 'echo "# -= autoproxy config =-" >> /etc/apt/apt.conf'
echo "ok?" > /tmp/log.txt
