#!/bin/bash
# (c) 2017 Valentijn "ev1l0rd"

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
	COMITTAG="r$COMITTAG"
	#Now we make the tag
	git tag "$COMITTAG"
}

function repoPush() {
	git push --force --tags "https://${API_KEY}@${REPOSITORY}"
}

function cleanUp() {
	cd ../ || exit
	rm -rf "$(basename ${REPOSITORY%.git})"
}
