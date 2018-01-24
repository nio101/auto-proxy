#!/usr/bin/env bash

# find and replace values for proxy in ~/.bashrc

PROXY_STRING=$1
SOCKS_STRING=$2

# todo:
# faire un grep avec beginning of line detection
# => si variable n'existe pas, on l'ajoute
# puis awk, mais avec début de ligne, pour éviter de faire awk sur commentaire

# mieux: supprimer ce qu'il y a entre encarts et regénérer à la fin
# # -= auto. gen. by autoproxy -BEGIN- =-
# export blalabla...
# # -= auto. gen. by autoproxy -END- =-

# faire ca en utilisant:
# sed '/PATTERN-1/,/PATTERN-2/d' input.txt

#awk '/http_proxy/{gsub(/\"\"/, "\"'$PROXY_STRING'\"")};{print}' ~/.bashrc \
#| awk '/https_proxy/{gsub(/\"\"/, "\"'$PROXY_STRING'\"")};{print}' \
#| awk '/ftp_proxy/{gsub(/\"\"/, "\"'$PROXY_STRING'\"")};{print}' \
#| awk '/all_proxy/{gsub(/\"\"/, "\"'$SOCKS_STRING'\"")};{print}' > ~/.bashrc.new

# export all_proxy="socks://niceway.rd.francetelecom.fr:1080/"

# awk '/http_proxy/{gsub(/\"\"/, "\"http://localhost:3128\"")};{print}' .bashrc > .bashrc_test

# cat ~/.bashrc.new
