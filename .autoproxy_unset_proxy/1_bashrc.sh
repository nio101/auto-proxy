#!/usr/bin/env bash

# unset proxy env vars > /etc/bash.bashrc

# remove the special group entry in /etc/bash.bashrc, if it exists
sed '/# -= autoproxy config, DO NOT EDIT MANUALLY =-/,/# -= autoproxy config =-/d' /etc/bash.bashrc|sudo tee /etc/bash.bashrc > /dev/null

# create it again, with proper values
sudo bash -c 'echo "# -= autoproxy config, DO NOT EDIT MANUALLY =-" >> /etc/bash.bashrc'
sudo bash -c 'echo "export http_proxy=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export https_proxy=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export rsync_proxy=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export ftp_proxy=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export all_proxy=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export no_proxy=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export HTTP_PROXY=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export HTTPS_PROXY=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export RSYNC_PROXY=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export FTP_PROXY=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export ALL_PROXY=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "export NO_PROXY=\"\"" >> /etc/bash.bashrc'
sudo bash -c 'echo "# -= autoproxy config =-" >> /etc/bash.bashrc'
