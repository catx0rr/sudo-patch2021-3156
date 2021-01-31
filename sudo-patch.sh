#!/bin/bash

# CVE-2021-3156 patch for Heap based buffer overflow
# https://www.sudo.ws/
# Patch automation
# Author: War

banner="
----------------------------------------------
SUDO HEAP BASED BUFFER OVERFLOW PATCH
CVE-2021-3156
----------------------------------------------
"

patched_version="1.9.5p2"
abs_path="/home/$(whoami)/Downloads"

function version_checker
{	
	echo -e "$banner"

	echo -e "[*] Checking sudo version..\n"; sleep 3

	version=$(bash -c "sudo --version | xargs | awk -F' ' '{print \$3}'")

	echo -e "[+] Current sudo version: $version\n"

	if [[ $version == $patched_version ]]; then
		echo -e "[+] Current sudo version is up to date. Nothing to do.."
		
		exit
	fi

}

function download_sudo
{
	echo -e "[*] Downloading sudo version $patched_version..\n"

	curl -# -o $abs_path/sudo-$patched_version.tar.gz \
		https://www.sudo.ws/dist/sudo-$patched_version.tar.gz

	echo -e "[*] Extracting.\n"

	tar xfz $abs_path/sudo-$patched_version.tar.gz \
		-C $abs_path/

}

function install
{
	read -p "[+] Do you want to install sudo $patched_version now? [y/N] :" getopt

	case $getopt in
		[Yy]|[eE]|[sS])
			echo -e "\n[*] Installing sudo version $patched_version on the system.."
			;;

		[Nn]|[oO])
			echo -e "\n[+] sudo version $patched_version is downloaded on /home/$(whoami)/Downloads directory."
			
			exit
			;;

		*)
			install
			;;
	esac
}

function make_install
{
	echo -e "[*] Configuring sudo..\n"
	cd $abs_path/sudo-$patched_version/
	
	./configure >> /tmp/sudo-configure.log
	
	echo -e "[*] Compiling sudo..\n"

	make && sudo make install >> /tmp/sudo-makeinstall.log

	echo -e "\n[+] Done..\n"
}

function clean_dir
{
	rm -rf $abs_path/sudo-$patched_version*
}

function main 
{
	version_checker
	download_sudo
	install
	make_install
	version_checker
	clean_dir
}

main
