.DEFAULT_GOAL := mydefault

install:
	@/bin/echo -e "\x1B[01;93m -= copying auto-proxy to argo dir =- \x1B[0m"
	rm -rf ~/.config/argos/.autoproxy_set_proxy
	rm -rf ~/.config/argos/.autoproxy_unset_proxy
	cp -r .autoproxy_set_proxy ~/.config/argos
	cp -r .autoproxy_unset_proxy ~/.config/argos
	rm -rf /tmp/autoproxy*
	cp autoproxy.r.30s.sh ~/.config/argos

mydefault:
	# done

.PHONY: test lock update mydefault
