#!/usr/bin/env bash

# This is a plugin of Argos, compatible with BitBar
# https://github.com/p-e-w/argos, https://github.com/matryer/bitbar

# AUTOPROXY
#
# It checks intranet/internet connectivity and set proxy accordingly, automatically
#
# contact: nio101@outlook.com
#

# dependencies: ping, curl

# ================================================================
# -= UNCOMMENT THE FOLLOWING TO TEMPORARILY DISABLE THE PLUGIN =-

#echo "internet 🚀| color=#1a9850 iconName=network-transmit-receive"
#exit 0

# ================================================================
# -= MAKE YOU CUSTOM CONFIG MODIFICATIONS HERE! =-

# Proxy Settings that will be used in the .autoproxy_set_proxy scripts
# to make changes to system's conf

# this one will be used with ping to detect intranet connectivity
AP_INTRANET_HOST="intra_host"
AP_MAIN_PROXY_HOST="localhost"
AP_MAIN_PROXY_PORT="3128"
AP_MAIN_PROXY="http://$AP_MAIN_PROXY_HOST:$AP_MAIN_PROXY_PORT"

# those will be used in the set_proxy scripts
AP_ALL_PROXY=$AP_MAIN_PROXY
AP_HTTP_PROXY=$AP_MAIN_PROXY
AP_HTTPS_PROXY=$AP_MAIN_PROXY
AP_FTP_PROXY=$AP_MAIN_PROXY
AP_RSYNC_PROXY=$AP_MAIN_PROXY
AP_NO_PROXY="localhost,127.0.0.0/8,::1"

# ================================================================
export AP_ALL_PROXY
export AP_HTTP_PROXY
export AP_HTTPS_PROXY
export AP_HTTP_PROXY
export AP_FTP_PROXY
export AP_RSYNC_PROXY
export AP_NO_PROXY

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

GOOGLE_HOST="www.google.com"
GITHUB_HOST="www.github.com"

# -= 1. any previous status for this session? =-
STATUS="unknown"
if [ -f /tmp/autoproxy_auto_on.flag ]; then
    STATUS="ON"
fi
if [ -f /tmp/autoproxy_auto_off.flag ]; then
    STATUS="OFF"
fi

# -= 2. check intranet proxy connectivity =-
function ping_server {	# and return the ping value in ms
	arg1=$1
	# ping the main proxy
	if RES=$(timeout 2 ping -c 2 -n -q $arg1 2>/dev/null); then
	    PING_TIME=$(echo "$RES" | awk -F '/' 'END {printf "%.0f\n", $5}')
	else
	    PING_TIME=$MAX_PING
	fi
	echo "$PING_TIME"
}

function colorize {
  	if [ "$1" -ge $MAX_PING ]; then
    	echo "${COLORS[0]}"
  	elif [ "$1" -ge 600 ]; then
    	echo "${COLORS[1]}"
  	elif [ "$1" -ge 300 ]; then
    	echo "${COLORS[2]}"
  	elif [ "$1" -ge 100 ]; then
    	echo "${COLORS[3]}"
  	elif [ "$1" -ge 50 ]; then
    	echo "${COLORS[4]}"
  	else
    	echo "${COLORS[5]}"
  	fi
}

function show_ping_result {
	arg1=$1
	arg2=$2
	if [ $arg1 -ge $MAX_PING ]; then
	  echo "ping $arg2: ❌| color=$(colorize $arg1) $FONT"
	else
	  echo "ping $arg2: $arg1 ms| color=$(colorize $arg1) $FONT"
	fi
}

PROXY_PING=$(ping_server ${AP_INTRANET_HOST})
GOOGLE_PING=$(ping_server ${GOOGLE_HOST})
GITHUB_PING=$(ping_server ${GITHUB_HOST})

if [ $PROXY_PING -ge $MAX_PING ]; then
	ZONE="internet"
else
	ZONE="intranet"
fi

function set_proxy {
	for SCRIPT in ~/.config/argos/.autoproxy_set_proxy/*
	do
		if [ -f $SCRIPT -a -x $SCRIPT ]
		then
			#source $SCRIPT$
			$SCRIPT > "$SCRIPT.txt"
			ret_code=$?            # Capture return code
			if [ ! $ret_code == "0" ]; then
				echo "warning: $SCRIPT exited with non-zero code!"
				exit 1
			fi
		fi
	done
	notify-send -u normal -t 2000 -a autoproxy -i network-transmit-receive "Intranet detected, proxy configured!"
	touch /tmp/autoproxy_auto_on.flag
	rm /tmp/autoproxy_auto_off.flag
	exit 0
}

function unset_proxy {
	for SCRIPT in ~/.config/argos/.autoproxy_unset_proxy/*
	do
		if [ -f $SCRIPT -a -x $SCRIPT ]
		then
			#source $SCRIPT$
			$SCRIPT
			ret_code=$?            # Capture return code
			if [ ! $ret_code == "0" ]; then
				echo "warning: $SCRIPT exited with non-zero code!"
				exit 1
			fi
		fi
	done
	notify-send -u normal -t 2000 -a autoproxy -i network-transmit-receive "Internet detected, proxy disabled!"
	touch /tmp/autoproxy_auto_off.flag
	rm /tmp/autoproxy_auto_on.flag
	exit 0
}

if [[ $STATUS == "unknown" ]] && [[ $ZONE == "intranet" ]]; then
	if RES=$(set_proxy); then
	    # proxy set, create the flag file
	    STATUS="ON"
	else
	    echo "$RES"
	fi
else
	if [[ $STATUS == "unknown" ]] && [[ $ZONE == "internet" ]]; then
		if RES=$(unset_proxy); then
		    # proxy unset, create the flag file
		    STATUS="OFF"
		else
		    echo "$RES"
		fi
	else
		if [[ $STATUS == "ON" ]] && [[ $ZONE == "internet" ]]; then
			if RES=$(unset_proxy); then
			    # proxy unset, update the flag files
			    STATUS="OFF"
			else
			    echo "$RES"
			fi
		else
			if [[ $STATUS == "OFF" ]] && [[ $ZONE == "intranet" ]]; then
				if RES=$(set_proxy); then
				    # proxy set, update the flag files
				    STATUS="ON"
				else
				    echo "$RES"
				fi
			fi
		fi
	fi
fi

# -= now, source the bash file =-
# to simulate an interactive shell
# without it, /etc/bash.bashrc just exits
PS1='$ '
source /etc/bash.bashrc

# -= then check internet connectivity =-
if [ "$ZONE" == "internet" ]; then
	if [ $GOOGLE_PING -ge $MAX_PING ]; then
		ICON="⛔"
		COLOR="#fc8d59"
	else
		ICON="🚀"
		COLOR="#1a9850"
	fi
fi

if RES=$(curl -H 'Cache-Control: no-cache' -I http://google.com 2>/dev/null); then
	# got an answer
	ICON="🚀"
	COLOR="#1a9850"
	DO_TIME_HTTP="yes"
else
	ICON="⛔"
	COLOR="#fc8d59"
	DO_TIME_HTTP="no"
	if [ "$ZONE" == "internet" ]; then
		# no intranet ping && no internet http access
		# => no man's land!
		ZONE="???"
	fi
fi

echo "$ZONE $ICON| color=$COLOR iconName=network-transmit-receive $MENUFONT"
echo "---"

systemctl is-active cntlm >/dev/null 2>&1 && echo "cntlm: ON" || echo "cntlm: OFF"
echo "proxy: $STATUS"
echo "---"

echo "$(show_ping_result $PROXY_PING 'intra_proxy')"
echo "$(show_ping_result $GOOGLE_PING google.com)"
echo "$(show_ping_result $GITHUB_PING github.com)"

echo "---"
if [ "$DO_TIME_HTTP" == "yes" ]; then
	echo "---"
	GOOGLE_HTTP_TIME=$({ /usr/bin/time -f "%e" curl -H 'Cache-Control: no-cache' -sI google.com|tail -n 1| tr -d '\n' >/dev/null 2>&1;} 2>&1 )
	echo "http google.com: $GOOGLE_HTTP_TIME sec| color=#1a9850 $FONT"
	GITHUB_HTTP_TIME=$({ /usr/bin/time -f "%e" curl -H 'Cache-Control: no-cache' -sI github.com|tail -n 1| tr -d '\n' >/dev/null 2>&1;} 2>&1 )	
	echo "http github.com: $GITHUB_HTTP_TIME sec| color=#1a9850 $FONT"
else
	echo "http google.com: ❌| color=#fc8d59 $FONT"
	echo "http github.com: ❌| color=#fc8d59 $FONT"
fi

echo "---"
echo "Refresh... | refresh=true"
