#!/usr/bin/env bash

# run firefox with the intranet profile
cmd="firefox --profile /home/nio/.mozilla/firefox/ko8osw3x.intranet"
eval "${cmd}" &>/dev/null &!;
