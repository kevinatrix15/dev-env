# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color|*rxvt*) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# git functions
rebase() {
  git checkout master && \
    git fetch upstream && \
    git rebase upstream/master && \
    git push
}

branchdelete() {
	echo "Are you sure you want to delete ${1}?"
	read -n1 ANS
	if [[ "${ANS}" == "y" ]]; then
		git push origin --delete "${1}"
		git branch -d "${1}"
	fi
}

mymake() {
  make -j 8 && \
    make test CTEST_OUTPUT_ON_FAILURE=1
}

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# autojump functionality
[[ -s /home/kevin/.autojump/etc/profile.d/autojump.sh ]] && source /home/kevin/.autojump/etc/profile.d/autojump.sh

# added by Anaconda2 4.4.0 installer
export PATH="/usr/local/anaconda2/bin:$PATH"

# Paraview 5.4
export PATH="/usr/local/ParaView-4.4.0-Qt4-OpenGL2-Linux-64bit/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/ParaView-4.4.0-Qt4-OpenGL2-MPI-Linux-64bit/lib:$LD_LIBRARY_PATH"
#export PATH="/usr/local/ParaView-5.4.1-RC3-Qt5-OpenGL2-MPI-Linux-64bit/bin:$PATH"
#export LD_LIBRARY_PATH="/usr/local/ParaView-5.4.1-RC3-Qt5-OpenGL2-MPI-Linux-64bit/lib:$LD_LIBRARY_PATH"

# Pinging AWS servers for docker status
alias docker_ping="echo aws1;ssh aws1 docker ps;echo aws2;ssh aws2 docker ps;echo aws3;ssh aws3 docker ps;echo aws4;ssh aws4 docker ps;echo aws5;ssh aws5 docker ps;echo aws6;ssh aws6 docker ps;"

# output thermal solver run times
alias get-thermal-runtime="find . -name solver.log -exec grep -H Total {} \; | awk '{ split(\$1,a,\"/\"); print a[2],\$11/60. \" mins\" }' | sort"

# outputh thermal solver run time on a layer-wise basis
get-layerseconds() { ltimes=`grep "Run Layer" solver.log | awk '{print("<"$5"-"$2"-"$3,$4">")}' | sed 's/://' | sed 's/</"/g' | sed 's/>/",/g'`; python -c 'import numpy as np; import calendar; stamps=['"$ltimes"']; times = np.array( [ x.replace( x[5:8], "{:02d}".format( list(calendar.month_abbr).index(x[5:8]) ) ) for x in stamps ], dtype="datetime64[s]" ); layers=times[1:]-times[:-1]; print [(k,x.item().total_seconds()) for k,x in enumerate(layers)]'; }

# output thermal solver elapsed time for currently running simulation
elapsed-mins() { ltimes=`grep "Run Layer" solver.log | awk '{print("<"$5"-"$2"-"$3,$4">")}' | sed 's/://' | sed 's/</"/g' | sed 's/>/",/g'`; python -c 'import numpy as np; import calendar; stamps=['"$ltimes"']; times = np.array( [ x.replace( x[5:8], "{:02d}".format( list(calendar.month_abbr).index(x[5:8]) ) ) for x in stamps ], dtype="datetime64[m]" ); print times[-1]-times[0]';}

elapsed-hrs() { ltimes=`grep "Run Layer" solver.log | awk '{print("<"$5"-"$2"-"$3,$4">")}' | sed 's/://' | sed 's/</"/g' | sed 's/>/",/g'`; python -c 'import numpy as np; import calendar; stamps=['"$ltimes"']; times = np.array( [ x.replace( x[5:8], "{:02d}".format( list(calendar.month_abbr).index(x[5:8]) ) ) for x in stamps ], dtype="datetime64[h]" ); print times[-1]-times[0]';}

# grep input file for certain string
get_parameters() { find . -name input.json -exec grep -H $1 {} \; | sort; }

cgrep() {
  grep -rn "$@" --include={*.h,*.hpp,*.c,*.cpp,*.cxx} . ;
}

# display functions

display-above() {
  xrandr --output eDP-1 --mode 1920x1080
  xrandr --output DP-1 --mode 1920x1080 --above eDP-1
  xrandr --output DP-1-1 --mode 1920x1080 --above eDP-1
}

display-left() {
  xrandr --output eDP-1 --mode 1920x1080
  xrandr --output DP-1 --mode 1920x1080 --left-of eDP-1
  xrandr --output DP-1-1 --mode 1920x1080 --left-of eDP-1
}

display-same() {
  xrandr --output eDP-1 --mode 1920x1080
  xrandr --output DP-1 --mode 1920x1080 --same-as eDP-1
  xrandr --output DP-1-1 --mode 1920x1080 --same-as eDP-1
}

display-off() {
  xrandr --output DP-1 --off
  xrandr --output DP-1-1 --off
}
