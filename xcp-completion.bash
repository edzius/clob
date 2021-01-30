#!/usr/bin/env bash

export COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}

_urlcomplete() {
	COMPREPLY=()
	if [ ${#COMP_WORDS[@]} -gt 7 ]; then
		exit 1
	fi

	local CURRENT_PROMPT="${COMP_WORDS[COMP_CWORD]}"
	if [[ ${CURRENT_PROMPT} == *@*  ]] ; then
		local OPTIONS="-P ${CURRENT_PROMPT/@*/}@ -- ${CURRENT_PROMPT/*@/}"
	else
		local OPTIONS=" -- ${CURRENT_PROMPT}"
	fi

	# parse hosts defined in /etc/hosts
	if [ -r /etc/hosts ]; then
		COMPREPLY=( ${COMPREPLY[*]} $(compgen -W "$(awk '/^[^#]/ { print $2 }' /etc/hosts)" ${OPTIONS}) )
	fi

	# parse history addresses
	if [ -r ~/.bash_history ]; then
		COMPREPLY=( ${COMPREPLY[*]} $(compgen -W "$(cat ~/.bash_history | grep -wE "^(ssh|scp|xcp)" | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' | sort | uniq)" ${OPTIONS}) )
	fi
}
complete -o default -o nospace -F _urlcomplete xcp
