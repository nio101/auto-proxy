.DEFAULT_GOAL := mydefault

deploy:
	@/bin/echo -e "\x1B[01;93m -= deploying auto-proxy to argo dir =- \x1B[0m"
	cp -r .autoproxy_set_proxy ~/.config/argos
	cp -r .autoproxy_unset_proxy ~/.config/argos
	cp .autoproxy_config.cfg ~/.config/argos
	cp autoproxy.r.30s.sh ~/.config/argos

mydefault:
	# done

.PHONY: test lock update mydefault
