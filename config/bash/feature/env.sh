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

# Certain Shell Options
shopt -s cdable_vars cdspell
