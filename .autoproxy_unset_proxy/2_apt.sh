#!/usr/bin/env bash

# modify /etc/apt/apt.conf

# remove the special group entry in /etc/bash.bashrc, if it exists
sed '/# -= autoproxy config, DO NOT EDIT MANUALLY =-/,/# -= autoproxy config =-/d' /etc/apt/apt.conf|sudo tee /etc/apt/apt.conf > /dev/null
