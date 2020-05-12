only_interactive

### Certain Separatisms of History
##
#   Per Directory
function local_history() {
  HISTARCHIVE=$HOME/.bash_histories
  [ -d "$HISTARCHIVE" ] || mkdir $HISTARCHIVE
  [ -z "$1" ] && history -w
  HISTLOG=$HISTARCHIVE/archive
  HISTLOGOLD=$HISTARCHIVE/log
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
HISTIGNORE="\::[bf]g:exit:w:top:psf:lsd:dir:dirs:[pc]d:cd..:cd-:..:...:pushd:popd:[ 	]*"

export HISTFILE HISTFILESIZE HISTSIZE HISTCONTROL HISTARCHIVE HISTLOG
shopt -s histappend histverify histreedit


# Certain Bookkeeping
# Track shell's pid, user, directory, command number, and timestamp for each command line
# in a global history log file. This has certainly proved immensely useful.
function push_histlog () {
  if [ $exit_code -eq 0 ]; then mark=":"; else mark="÷"; fi
  last_cmd=$(history 1)
  num=$(awk '{ print $1; }' <<<$last_cmd)
  cmd=$(awk '{ $1=""; print; }' <<<$last_cmd)

  echo $(date +%FT%T) "$num" "$USER" "$$" "$PWD" "$mark" "$cmd" >> $HISTLOG
}

# Certain History Researchability Providers
# Show last commands from the global history archive.
function hist() {
  [ -n "$1" ] && lines="-n $1"
  tail $lines $HISTLOG
}

# What's the history?
# This searches the archive, having user name, directory, timestamp ...
function whist() {
  if [ -z "$1" ]; then
    cat $HISTLOG
  else
    if which -s ag; then
      grep="ag --nonumbers"
    else
      grep=grep
    fi
    $grep "$@" $HISTLOGOLD $HISTLOG
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
  local target=''
  if [ -z "$1" ]; then
    target=~
  else
    [ "$1" == "." ] && return
    if [ "$1" == '-' ]; then
      target=$OLDPWD
    else
      target="$*"
    fi
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
