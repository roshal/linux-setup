
# If not running interactively, don't do anything
[[ ${-} != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

#

TERM=terminator

#

source /usr/share/git/completion/git-prompt.sh

PS1='\e[40;90m\n\e[97m#\e[90m \e[92m\t\e[90m \e[94m\w\e[90m$(__git_ps1 " \e[97m%s\e[90m")\e[K\e[m\n'

alias g='grep --color'
alias l='ls -Al --group-directories-first'
alias z='grep -iz --color'
alias h='history'

alias hh='hstr'
alias ll='ls -A --group-directories-first'
alias py='python'
alias rc='echo -ne \\'\ec\\''
alias re='exec bash'

alias diff='diff --color'
alias grep='grep --color'
alias lint='npx eslint --color --ext .ts,.tsx --'
alias lock='swaylock --color 000000 --image /-/pictures/waves.jpg --tiling --font monospace --indicator-radius 96 --indicator-thickness 576'
alias syre='systemctl reboot'
alias sysu='systemctl suspend'

alias suck='sysu && lock'

alias _gff='cd /-/git.esphere.local/frontend/Fish'
alias _gfl='cd /-/git.esphere.local/frontend/Leda'
alias _gcl='cd /-/git.esphere.local/courier/light-ui'
alias _cff='cd /-/git.esphere.local.copy/frontend/Fish'
alias _cfl='cd /-/git.esphere.local.copy/frontend/Leda'
alias _ccl='cd /-/git.esphere.local.copy/courier/light-ui'

### fix webstorm window draw
# # https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland#java-under-xwayland
# # https://wiki.archlinux.org/index.php/Java#Gray_window,_applications_not_resizing_with_WM,_menus_immediately_closing
export _JAVA_AWT_WM_NONREPARENTING=1
export AWT_TOOLKIT=MToolkit

### xkb not for sway
export XKB_DEFAULT_LAYOUT=us,ru
export XKB_DEFAULT_OPTIONS=grp:caps_toggle

### nvm
source /usr/share/nvm/init-nvm.sh

###-begin-nps-completions-###
#
# yargs command completion script
#
# Installation: node_modules/.bin/nps completion >> ~/.bashrc
#    or node_modules/.bin/nps completion >> ~/.bash_profile on OSX.
#
function _yargs_completions {
  local cur_word args type_list

  cur_word="${COMP_WORDS[COMP_CWORD]}"
  args=("${COMP_WORDS[@]}")

  # ask yargs to generate completions.
  type_list=$(node_modules/.bin/nps --get-yargs-completions "${args[@]}")

  COMPREPLY=( $(compgen -W "${type_list}" -- ${cur_word}) )

  # if no match was found, fall back to filename completion
  if [ ${#COMPREPLY[@]} -eq 0 ]; then
    COMPREPLY=( $(compgen -f -- "${cur_word}" ) )
  fi

  return 0
}
complete -F _yargs_completions nps
###-end-nps-completions-###

export LC_MESSAGES=ru_RU.UTF-8

# # https://wiki.archlinux.org/index.php?oldid=584342#man
function man {
  LESS_TERMCAP_me=$'\e[0m' \
  LESS_TERMCAP_ue=$'\e[0m' \
  LESS_TERMCAP_se=$'\e[0m' \
  LESS_TERMCAP_md=$'\e[92m' \
  LESS_TERMCAP_us=$'\e[94m' \
  LESS_TERMCAP_so=$'\e[7m' \
  command man "${@}"
}

# if [[ -r /usr/share/doc/mcfly/mcfly.bash ]]
# then
#   source /usr/share/doc/mcfly/mcfly.bash
# fi

shopt -s histappend

# hstr configuration hstr -s

# get more colors
export HSTR_CONFIG=hicolor
# leading space hides commands from history
export HISTCONTROL=ignorespace
# increase history file size (default is 500)
export HISTFILESIZE=65536
# increase history size (default is 500)
export HISTSIZE=${HISTFILESIZE}
# if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)
if [[ ${-} =~ .*i.* ]]; then bind '"\C-r": "\C-a hstr -- \C-j"'; fi
# if this is interactive shell, then bind 'kill last command' to Ctrl-x k
if [[ ${-} =~ .*i.* ]]; then bind '"\C-xk": "\C-a hstr -k \C-j"'; fi

# # https://wiki.archlinux.org/index.php/Wayland#Qt_5
# # https://wiki.qt.io/QtWayland#Run_Qt_applications_as_Wayland_clients
export QT_QPA_PLATFORM=wayland

# # https://github.com/swaywm/sway/wiki/Running-programs-natively-under-wayland#firefox
# # https://wiki.archlinux.org/index.php/Firefox#Wayland
export MOZ_ENABLE_WAYLAND=1

export WLR_RDP_TLS_CERT_PATH=/-/remmina/tls.crt
export WLR_RDP_TLS_KEY_PATH=/-/remmina/tls.key
WLR_RDP_ADDRESS=0.0.0.0
WLR_BACKENDS=rdp
