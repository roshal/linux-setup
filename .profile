
PATH="${HOME}/bin:${PATH}"

if [[ "$SHELL" = '/bin/bash' ]]
then
	[[ -f ~/.bashrc ]] && . ~/.bashrc
fi

setxkbmap -layout us,ru -option grp:caps_toggle

export TERMINAL=terminator
