# auto-proxy

> Argos plugin to automatically check intranet/internet connectivity and set proxy settings accordingly.

## Features

* detects automatically intranet connectivity by pinging a given server (an intranet/corporate proxy, for example).
* switch proxy configuration (env vars, cntlm, git, apt, etç...) accordingly.
* check resulting internet connectivity (basic curl to google.com, plus other optional checks).
* your can easily add your own script to take into account new settings, or dedicated commands.

## Requirements

* a linux distribution with GNOME (the latests Ubuntu release, for example).
* Argos shell extension installed and running (see https://github.com/p-e-w/argos).

## How it works

What the main bash script does for each iteration:

1. Checks the presence of `/tmp/autoproxy_auto/manual_on.flag` or `/tmp/autoproxy_auto/manual_off.flag` to
	 assess the current session's proxy's state: _on/off/unknown_.

2. Checks for connectivity by pinging the intranet host defined in the settings.
	* if OK => we're on the intranet, and proxy should be set.
	* else, proxy should be removed.

3. To set the proxy, it will run every executable inside the `.autoproxy_set_proxy/` subdir
	* to unset the proxy, it will do the same with the `.autoproxy_unset_proxy/` subdir
	* example of scripts actions: set env vars in `/etc/bash.bashrc`, in `/etc/apt.conf`, etç...
	* after each proxy setting/unsetting, the main script will source `/etc/bash.bashrc` to refresh its env vars.
	* currents provided scripts:
		* cntlm start/stop.
		* `/etc/bash.bashrc` env vars.
		* setting alias in `/etc/bash.bashrc` to run firefox with the proper profile (one for intranet, the other fot internet). 

4. Checks for connectivity to some internet server (google.com)
	* if on the intranet, we use a curl command to test connectivity at HTTP level (via proxy) because a ping command (TCP/IP level) wouldn't basically work with an http_proxy.
    * if not on the intranet, we can use a basic ping command.
		* if OK => internet connectivity step 1 is confirmed (through the proxy, or not)
		* if NOK => no intranet nor internet connectivity, the script will show "???" in it's title.

* The status bar label reflects intranet/internet connectivity/status, depending on the zone (intranet or not)
and adds an icon and a color to reflect internet connectivity:
	* green + 🚀 if OK
 	* orange + ⛔ if NOK

* details are provided within the menu:
	- current proxy status (ON/OFF).
	- cntlm service status.
	- proxy ping (in red if no connectivity).
	- google ping (in red if no connectivity).
* You can easily remove some checks or add your own by modifying the main bash script.

* If you want to modify the script's icon:
	- sudo apt-get install gtk-3-examples
	- run gtk3-icon-browser in terminal and choose an icon.
	- it's name is set in the main bash script using the iconName property.

* :warning: Every env variables export are set automatically in `/etc/bash.bashrc`. The script modifies and sources that script only. So:
	* if settings are present in ~/.bashrc, they will overwrite those settings
and the plugin won't be able to properly do its job.
	* when the proxy settings have been modified by the plugin, you should source `/etc/bash.bashrc` and `~/.bashrc` to refresh any already open terminal/console on your local machine. tip: use `alias env_reload='source /etc/bash.bashrc; source ~/.bashrc'` in your `~/.bashrc`, and juste use `env_reload`.

## Installation

1. Clone or unzip the repository locally.
2. Modify the settings at the beginning of the bash script named `autoproxy.r.30s.sh` to reflect your proxy configuration.
3. Rename optionally this script using the proper [argos file naming syntax](https://github.com/p-e-w/argos#filename-format) to modify the plugin position and refresh frequency.
4. Add/remove/modify scripts inside the `.autoproxy_set_proxy` and the `.autoproxy_unset_proxy` directories. The executables inside those directories will be run in alphabetical order when the proxy settings must be set/unset. You can write your own scripts, using the variables set at the beginning of `autoproxy.r.30s.sh`.
5. Use `make install` to install auto-proxy to your local argo directory (`~/.config/argos/`) and make it run.

## Problems?

* To debug any problem, you can go to the argo directory `~/.config/argos/` and manually run `autoproxy.r.30s.sh`.

Have fun! :)

_contact: nio101@outlook.com_