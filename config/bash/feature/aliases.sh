# Certain Shorthands
alias ....='cd ../../..'
alias ...='cd ../..'
alias ..='cd ..'
alias bx='bundle exec'
alias cd..='cd ..'
alias clean='rm -f *~ #*#'
alias df='df -h'
alias du='du -k'
alias grep='GREP_COLOR="1;37;41" LANG=C grep --color=auto'
alias hexdump='hexdump -C'
alias l='ls -l'
alias ll='ls -al'
alias ls.='ll | grep --color=never " \..*$"'
alias lsd='l | grep "^d"'
alias lsdirs='ll | grep "^d"'
alias vi='vim'
alias x='gnuclient'

if have subl ; then
  alias s='subl'
  alias sn='subl -n'
  function subl_wait () {
    subl -nw "$@"
  }
fi

is_interactive || shopt -s expand_aliases
