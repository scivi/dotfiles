only_interactive

### Certain Variable Assignments
##
#
# Certain Paths for Greater Usefulness
prepend_path PATH ~/bin
prepend_path PATH ./bin

export EDITOR=vim
if have subl ; then
  export VISUAL="subl_wait"
else
  export VISUAL=$EDITOR
fi

export PAGER=less
export LESS="-riMSx4 -FX"
export LESSOPEN='|~/.config/lib/lessfilter %s'

# Certain Manly Colours
# From http://zoetrope.speakermouth.com/2008/8/18/colored-man-pages
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# Certain Colour Abundance
white='\[\033[0m\]'
blue='\[\033[1;34m\]'
lightblue='\[\033[0;34m\]'
red='\[\033[1;31m\]'
lightred='\[\033[0;31m\]'
yellow='\[\033[1;33m\]'
lightyellow='\[\033[0;33m\]'
green='\[\033[1;32m\]'
purple='\[\033[0;35m\]'
lightpurple='\[\033[1;35m\]'


# Solarized colorscheme, from https://github.com/riobard/bash-powerline/
readonly FG_BASE03="\[$(tput setaf 8)\]"
readonly FG_BASE02="\[$(tput setaf 0)\]"
readonly FG_BASE01="\[$(tput setaf 10)\]"
readonly FG_BASE00="\[$(tput setaf 11)\]"
readonly FG_BASE0="\[$(tput setaf 12)\]"
readonly FG_BASE1="\[$(tput setaf 14)\]"
readonly FG_BASE2="\[$(tput setaf 7)\]"
readonly FG_BASE3="\[$(tput setaf 15)\]"

readonly BG_BASE03="\[$(tput setab 8)\]"
readonly BG_BASE02="\[$(tput setab 0)\]"
readonly BG_BASE01="\[$(tput setab 10)\]"
readonly BG_BASE00="\[$(tput setab 11)\]"
readonly BG_BASE0="\[$(tput setab 12)\]"
readonly BG_BASE1="\[$(tput setab 14)\]"
readonly BG_BASE2="\[$(tput setab 7)\]"
readonly BG_BASE3="\[$(tput setab 15)\]"

readonly FG_YELLOW="\[$(tput setaf 3)\]"
readonly FG_ORANGE="\[$(tput setaf 9)\]"
readonly FG_RED="\[$(tput setaf 1)\]"
readonly FG_MAGENTA="\[$(tput setaf 5)\]"
readonly FG_VIOLET="\[$(tput setaf 13)\]"
readonly FG_BLUE="\[$(tput setaf 4)\]"
readonly FG_CYAN="\[$(tput setaf 6)\]"
readonly FG_GREEN="\[$(tput setaf 2)\]"

readonly BG_YELLOW="\[$(tput setab 3)\]"
readonly BG_ORANGE="\[$(tput setab 9)\]"
readonly BG_RED="\[$(tput setab 1)\]"
readonly BG_MAGENTA="\[$(tput setab 5)\]"
readonly BG_VIOLET="\[$(tput setab 13)\]"
readonly BG_BLUE="\[$(tput setab 4)\]"
readonly BG_CYAN="\[$(tput setab 6)\]"
readonly BG_GREEN="\[$(tput setab 2)\]"

readonly DIM="\[$(tput dim)\]"
readonly REVERSE="\[$(tput rev)\]"
readonly RESET="\[$(tput sgr0)\]"
readonly BOLD="\[$(tput bold)\]"

# Certain Shell Options
shopt -s cdable_vars cdspell
