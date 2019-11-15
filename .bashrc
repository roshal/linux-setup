
# if not running interactively don't do anything
[[ $- != *i* ]] && return

PS1='\e[40;90m\n\e[97m\$\e[90m \e[91m\D{%V-%u}\e[90m \e[92m\t\e[90m \e[94m\w$(__git_ps1 "\e[90m \e[97m%s\e[90m")\e[K\e[m\n'
