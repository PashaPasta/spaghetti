#!/bin/bash

# Requires prips and whois to be installed


if [[ $1 = -h ]] ; then
printf " Available options: -cidr <CIDR>
-list <path to list of ips, one IP per line>
-h Displays help text
"
fi
if [[ $1 = --check-install ]] ; then
dpkg --get-selections > /tmp/dpkglist.txt
	if grep -q prips "/tmp/dpkglist.txt" ; then
		printf "Dependencies appear to be installed correctly.\n"
		exit 
	else
		sudo apt-get install prips > /dev/null
		printf "The dependent package prips was installed.\n"
	fi
fi
if [[ $1 = -cidr ]] ; then
prips $2 > /tmp/ips.txt
        now=$(date +"%m_%d_%Y_%H_%M")
        xargs -0 -n 1 whois < <(tr \\n \\0 </tmp/ips.txt) | tee results_$now.txt
        printf " Check results_$now.txt for whois output.\n"
fi

if [[ $1 = -list ]] ; then
now=$(date +"%m_%d_%Y_%H_%M")
        xargs -0 -n 1 whois < <(tr \\n \\0 < $2) | tee results_$now.txt
        printf "Check results_$now.txt for whois output.\n"
fi
