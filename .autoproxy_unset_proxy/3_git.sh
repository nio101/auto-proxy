#!/usr/bin/env bash

git config --global --unset http.proxy
# because git unset returns non zero status code
exit 0
