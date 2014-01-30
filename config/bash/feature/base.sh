### Certain required basic functions and aliases
##
#

# We can't have have too early, can we?
alias have='which -s'

# Certain Conditional Output
function _log () {
  [ -n "${_LOGLEVEL}" ] && echo "$@"
}

# Certain Dynamic Invocations
#   maybe_run foo
#   maybe_run exec foo
function maybe_run () {
  local fun=$2
  if [ -n "$fun" ]; then
    local invoke_via=$1
  else
    fun=$1
    [ "$fun" = "exec" ] && return
  fi

  if [ -n "$fun" ]; then
    type $fun >/dev/null 2>&1 && $invoke_via $fun
  fi
}

# Certain hook processing for feature scripts to peruse.
function after_startup_do () {
  local hook=$1
  AFTER_STARTUP_HOOKS=( "${AFTER_STARTUP_HOOKS[@]}" "$hook" )
}

function run_after_startup_hooks () {
  for hook in ${AFTER_STARTUP_HOOKS[@]}; do
    maybe_run $hook && unset -f $hook
  done
  unset AFTER_STARTUP_HOOKS
}

# Certain Interactivity Determination
alias is_interactive='[ -n "$PS1" ]'
alias only_interactive='is_interactive || return'

# Certain Locals on the Path
# append_path + prepend_path are copied from Fink (http://fink.sf.net)
#      Copyright (c) 2001 Christoph Pfisterer / Copyright (c) 2001-2004 The Fink Team

# append_path and prepend_path to add directory paths, e.g. PATH, MANPATH.
function append_path() {
  if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\"" ; then
    eval "$1=\$$1:$2"
  fi
}

function prepend_path() {
  if ! eval test -z "\"\${$1##*:$2:*}\"" -o -z "\"\${$1%%*:$2}\"" -o -z "\"\${$1##$2:*}\"" -o -z "\"\${$1##$2}\"" ; then
    eval "$1=$2:\$$1"
  fi
}
