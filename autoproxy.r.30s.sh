#!/usr/bin/env bash

# This is a plugin of Argos, compatible with BitBar
# https://github.com/p-e-w/argos, https://github.com/matryer/bitbar

# AUTOPROXY
#
# It checks intranet/internet connectivity and set proxy accordingly, automatically
#
# contact: nicolas.barthe@orange.com
#

# dependencies: ping, curl

# How it works:

# 1. It checks the presence of /tmp/autoproxy_auto/manual_on.flag or /tmp/autoproxy_auto/manual_off.flag to
# 	 assess the current session's proxy's state: on/off/unknown

# 2. It checks for connectivity by pinging the intranet proxy server.
# 	 if OK => we're on the intranet, and proxy should be set
#	 else, proxy should be removed.

# 3. to set the proxy, it will run every executable inside the .autoproxy_set_proxy/ subdir
#	 to unset the proxy, it will do the same with the .autoproxy_unset_proxy/ subdir
#	 example of scripts actions: set env vars in /etc/bash.bashrc, in /etc/apt.conf, etç...
#	 (after that, it will source /etc/bash.bashrc to refresh the updated env vars)

# 4. it then checks for connectivity to some internet server (google.com)
# 	 if on the intranet, we use a curl command to test at http level (via proxy)
#	 because a ping command (TCP/IP level) wouldn't work with an http_proxy.
#    if not on the intranet, we can use a basic ping command.
# 		if OK => internet connectivity step 1 is confirmed (through the proxy, or not)
#		if NOK => no internet connectivity :s

# 5. a batch of checks are then run, through all the scripts in the .autoproxy_checks/ subdir
#    their results will be shown on the menu view of the plugin

# the status bar label reflects intranet/internet connectivity/status, depending on the zone (intranet or not)
# and adds an icon and a color to reflect internet connectivity:
# 	green + 🚀 if OK
#   orange + ⛔ if NOK

# details are provided within the menu:
# - current proxy status (set/unset/error).
# 	error means a set/unset script has encountered an error.
# - proxy ping (in red if no connectivity)
# - google ping (in red if no connectivity)

# commands are provided to manually set/unset proxy, disabling the auto detection mode
# or to enable again the auto detection mode.

# note: to list usable icons with iconName:
# - sudo apt-get install gtk-3-examples
# - run gtk3-icon-browser in terminal
# - names are usable with the iconName property

# please note: every env variables export are set automatically in /etc/bash.bashrc
# the script modifies and sources that script only.
# if settings are present in ~/.bashrc, they will overwrite those settings
# and the plugin won't be able to properly do its job

# todo: virer les checks/cross après les ping times/checks
# utiliser uniquement pour les commandes/options
# voir comment implémenter les commandes pour auto/on/off
# ajouter des ping sur la forge, sur devwatt, openwatt...
# TODO: le rouge est illisible, préférer l'orange

# Themes copied from here: http://colorbrewer2.org/
# shellcheck disable=SC2034
PURPLE_GREEN_THEME=("#762a83" "#9970ab" "#c2a5cf" "#a6dba0" "#5aae61" "#1b7837")
# shellcheck disable=SC2034
#RED_GREEN_THEME=("#d73027" "#fc8d59" "#fee08b" "#d9ef8b" "#91cf60" "#1a9850")
RED_GREEN_THEME=("#fc8d59" "#fc8d59" "#fee08b" "#d9ef8b" "#91cf60" "#1a9850")
# shellcheck disable=SC2034
ORIGINAL_THEME=("#acacac" "#ff0101" "#cc673b" "#ce8458" "#6bbb15" "#0ed812")

# Configuration
COLORS=(${RED_GREEN_THEME[@]})
MENUFONT="" #size=10 font=UbuntuMono-Bold"
FONT=""

MAX_PING=1000

FLAG_FILE="/tmp/autoproxy_proxy_set.flag"

GOOGLE_HOST="www.google.com"
GITHUB_HOST="www.github.com"

echo "internet 🚀| color=#1a9850 iconName=emblem-web $MENUFONT"
#echo "intranet ⛔| color=#fc8d59 iconName=emblem-web $MENUFONT"
echo "---"

# read the proxy config
source ~/.config/argos/.autoproxy_config.cfg

function ping_server {	# and return the ping value in ms
	arg1=$1
	# ping the main proxy
	if RES=$(timeout 1 ping -c 1 -n -q $arg1 2>/dev/null); then
	    PING_TIME=$(echo "$RES" | awk -F '/' 'END {printf "%.0f\n", $5}')
	else
	    PING_TIME=$MAX_PING
	fi
	echo "$PING_TIME"
}

function colorize {
  	if [ $1 -ge $MAX_PING ]; then
    	echo "${COLORS[0]}"
  	elif [ $1 -ge 600 ]; then
    	echo "${COLORS[1]}"
  	elif [ $1 -ge 300 ]; then
    	echo "${COLORS[2]}"
  	elif [ $1 -ge 100 ]; then
    	echo "${COLORS[3]}"
  	elif [ $1 -ge 50 ]; then
    	echo "${COLORS[4]}"
  	else
    	echo "${COLORS[5]}"
  	fi
}

function show_ping_result {
	arg1=$1
	arg2=$2
	if [ $arg1 -ge $MAX_PING ]; then
	  echo "$arg2: ❌| color=$(colorize $arg1) $FONT"
	else
	  echo "$arg2: $arg1 ms| color=$(colorize $arg1) $FONT"
	fi
}

PROXY_PING=$(ping_server ${AP_MAIN_PROXY_HOST})
GOOGLE_PING=$(ping_server ${GOOGLE_HOST})
GITHUB_PING=$(ping_server ${GITHUB_HOST})

echo "$(show_ping_result $PROXY_PING 'intranet proxy')"
echo "$(show_ping_result $GOOGLE_PING google.com)"
echo "$(show_ping_result $GITHUB_PING github.com)"
echo "---"

if [ -f "$FLAG_FILE" ]
then
	echo "proxy: on | color=#91cf60 $FONT"
else
	echo "proxy: off | color=#91cf60 $FONT"
fi
echo "$INTRANET_HTTP_PROXY"
echo "ping proxy: ok | color=#1a9850 iconName=network-wired $FONT"
echo "ping proxy: ok | color=#91cf60 iconName=face-embarrassed $FONT"
echo "cntlm: ok | color=#d9ef8b $FONT"
echo "internet: ok | color=#fee08b $FONT"
echo "---"

echo "$http_proxy"
source ~/.bashrc && echo $http_proxy
for SCRIPT in ~/.config/argos/.testdir/*
	do
		if [ -f $SCRIPT -a -x $SCRIPT ]
		then
			#source $SCRIPT
			$SCRIPT
			ret_code=$?            # Capture return code
			echo $ret_code
		fi
	done
echo "$http_proxy"
# to simulate an interactive shell
# without it, /etc/bash.bashrc just exits
PS1='$ '
source /etc/bash.bashrc
echo "$http_proxy"


echo "---"
echo "Refresh... | refresh=true"
