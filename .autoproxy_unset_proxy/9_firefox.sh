#!/usr/bin/env bash

# run firefox with the intranet profile
cmd="firefox --profile /home/nio/.mozilla/firefox/1k1aqvtd.default"
eval "${cmd}" &>/dev/null &!;
