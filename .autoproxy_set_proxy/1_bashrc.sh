#!/usr/bin/env bash

# set proxy env vars > /etc/bash.bashrc

# remove the special group entry in /etc/bash.bashrc, if it exists
sed '/# -= autoproxy config, DO NOT EDIT MANUALLY =-/,/# -= autoproxy config =-/d' /etc/bash.bashrc|sudo tee /etc/bash.bashrc > /dev/null

# create it again, with proper values
sudo bash -c 'echo "# -= autoproxy config, DO NOT EDIT MANUALLY =-" >> /etc/bash.bashrc'
sudo bash -c 'echo "export http_proxy='"$AP_HTTP_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export https_proxy='"$AP_HTTPS_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export rsync_proxy='"$AP_RSYNC_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export ftp_proxy='"$AP_FTP_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export all_proxy='"$AP_ALL_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export no_proxy='"$AP_NO_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export HTTP_PROXY='"$AP_HTTP_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export HTTPS_PROXY='"$AP_HTTPS_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export RSYNC_PROXY='"$AP_RSYNC_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export FTP_PROXY='"$AP_FTP_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export ALL_PROXY='"$AP_ALL_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "export NO_PROXY='"$AP_NO_PROXY"'" >> /etc/bash.bashrc'
sudo bash -c 'echo "# -= autoproxy config =-" >> /etc/bash.bashrc'
