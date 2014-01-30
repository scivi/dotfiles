only_interactive

### Certain Separatisms of History
##
#   Per Directory
function local_history() {
  HISTARCHIVE=$HOME/.bash_histories
  [ -d "$HISTARCHIVE" ] || mkdir $HISTARCHIVE
  [ -z "$1" ] && history -w
  HISTLOG=$HISTARCHIVE/log
  HISTFILE="$HISTARCHIVE$PWD/bash_history"
  HISTMODE=local
  [ "$1" == "init" ] && return
  history -c
  history -r
}

#   Per session, i.e. tty. Turned out to be not that useful.
function session_history() {
  HISTFILE=${HOME}.bash_history_$(basename `tty`)
  HISTMODE=session
}

# Certain Limits of Historical Knowledge, Ignoring Emptyness as well as Duplication
HISTSIZE=2000
HISTFILESIZE=10000
HISTCONTROL=ignoreboth

# Certain Selectivity of Historical Remembrance
# Matching commands (like those prepended by a space, the final pattern) are immediately forgotten.
HISTIGNORE="\::[bf]g:exit:w:top:psf:lsd:dir:dirs:[pc]d:cd..:cd-:..:...:pushd:popd:R:RR:[ 	]*"

export HISTFILE HISTFILESIZE HISTSIZE HISTCONTROL HISTARCHIVE HISTLOG
shopt -s histappend histverify histreedit


# Certain Bookkeeping
# Track commands by shell, user, directory with command number and timestamp,
# in a global history log file.
function push_histlog () {
  EXIT=$?
  echo $(printf "%5d %-10s %s " $$ $USER "$PWD") "$(HISTTIMEFORMAT='%FT%T ' history 1)" >> $HISTLOG
}

# Certain History Researchability Providers
# Deals with the global history log.
alias History="cat $HISTLOG"
function hist() {
  [ -n "$1" ] && lines="-n $1"
  tail $lines $HISTLOG
}

function whist() {
  if [ -z "$1" ]; then
    cat $HISTLOG
  else
    grep "$@" $HISTLOG
  fi
}

# Certain History Schizophrenia Automation
function diverting_history() {
  # Save history, then change directory, then load history.
  # TODO: Merge history of multiple sessions in the same directory.
  #       Currently last save wins and overwrites other session's history.
  #       Perhaps know about other sessions and show where they are?
  local cmd=$1
  [ -z "$cmd" ] && echo -e "Usage: diverting_history command directory\n\ncommand = cd, pushd, popd\n" && return
  shift
  local params="$*"
  if [ "$HISTMODE" = "local" ]; then
    # don't save empty history on startup.
    if [ "$STARTUP" != "in progress" ]; then
      history -w
    fi

    if [ -z "$params" ]; then
      # Even if $params is empty, passing "" to $cmd might be bad: `pushd ""` == `pushd -0`
      $cmd
    else
      $cmd "$params"
    fi

    if [ "$OLDPWD" != "$PWD" ]; then
      local HISTDIR="$HISTARCHIVE$PWD" # using nested folders for history.
      [ -d "$HISTDIR" ] || mkdir -p "$HISTDIR"
      export HISTFILE="$HISTDIR/bash_history"
      history -c
      history -r
    else
      return
    fi
  else
    # Behave transparently.
    if [ -z "$params" ]; then
      $cmd
    else
      $cmd "$params"
    fi
  fi
}

function cd_and_remember() {
  # Emulate cd, but actually use pushd: let's have breadcrumbs in the shell.
  # And it can switch history as well.
  [ "$1" == '--help' -o "$1" == '-h' ] && help pushd
  if [ -z "$1" ]; then
    local target=~
  else
    [ "$1" == "." ] && return
    [ "$1" == '-' ] && popd_and_remember $OLDPWD && return
    local target="$*"
  fi
  diverting_history pushd "$target"
}

function popd_and_remember() {
  [ "$1" == '--help' -o "$1" == '-h' ] && help popd
  diverting_history popd "$@"
}

# There and back again.
alias cd=cd_and_remember
alias cs=cd_and_remember
alias bcd='builtin cd'
alias pd=popd_and_remember
alias cd-=popd_and_remember

### Hooks
function history_init () {
  ${HISTMODE:-local}_history init
  push_prompt_callback push_histlog
}
after_startup_do history_init
