#!/usr/bin/env bash

# run firefox with the internet profile

# remove the special group entry in /etc/bash.bashrc, if it exists
sed '/# -= autoproxy firefox config, DO NOT EDIT MANUALLY =-/,/# -= autoproxy firefox config =-/d' /etc/bash.bashrc|sudo tee /etc/bash.bashrc > /dev/null

# create it again, with proper values
sudo bash -c 'echo "# -= autoproxy firefox config, DO NOT EDIT MANUALLY =-" >> /etc/bash.bashrc'
sudo bash -c 'echo "alias ff=\"firefox --profile /home/nio/.mozilla/firefox/1k1aqvtd.default\"">> /etc/bash.bashrc'
sudo bash -c 'echo "# -= autoproxy firefox config =-" >> /etc/bash.bashrc'
