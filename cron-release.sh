#!/bin/bash
# cron-release.sh - Automates freeShop cache updates.
# Copyright (C) 2017 - Valentijn "Ev1l0rd"
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.


function showLicense() {
	printf "This program comes with ABSOLUTELY NO WARRANTY;
		This is free software, and you are welcome to redistribute it
		under certain conditions. For more details see the LICENSE file"
}

function envVars() {
	if [ ! -f variables.conf ]; then
		printf "variables.conf not found.\n Please set the environment variables and re-run the script.\n Exiting... "
		exit 1
	fi
	source variables.conf
}

function repoClone() {
	git clone https://"$REPOSITORY"
	cd "$(basename ${REPOSITORY%.git})" || exit
	git config user.name "$USERNAME"
	git config user.email "${EMAIL}"
}

function repoTag() {
	#Get latest tag
	LATESTAG=$(git describe --abbrev=0)
	#Remove r part from tag
	COMMITTAG=${LATESTAG#r}
	#Increase tag by 1
	COMMITTAG="$((COMMITTAG+1))"
	#Re-add r part to tag
	PUSHTAG="r${COMMITTAG}"
	#Now we make the tag. Note: Has to be annotated, or else git describe wont work. If you run this w/o an annotated tag as the last tag, it will not generate functional tags.
	git tag "$PUSHTAG" -m "."
}

function repoPush() {
	git push --force --tags "https://${API_KEY}@${REPOSITORY}"
}

function cleanUp() {
	cd ../ || exit
	rm -rf "$(basename ${REPOSITORY%.git})"
}

showLicense
envVars
repoClone
repoTag
repoPush
cleanUp
