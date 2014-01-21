only_interactive

# Certain Environmental Decoloring
function env() {
  if [ -z "$1" ]; then
    # Those LESS_TERMCAP colors destroy the output, so just filter them.
    /usr/bin/env | grep -v LESS_TERMCAP | sort
  else
    /usr/bin/env $@
  fi
}

# Certain Math Calculations
function ? () { echo "scale=2;$*" | bc -l; }

### Certain Multitasking
##
#   Run command for each remaining arg in parallel.
#   For commands with multiple arguments, just wrap all arguments together in quotes.
function parallelize () {
	if [ -z "$2" ]
	then
		echo 'usage: parallelize COMMAND ARGS+    # run command for each arg in parallel, in a background subshell.'
		exit 1
	fi

	command=$1
	shift

	for arg in $@; do
		(eval $command $arg) &
	done
}

# Certain Remote Shelling
function R() {
  if [ "$1" == "R" ]; then
    # Remote Root via sudo
    shift
    local cmnd="sudo bash --login"
    [ -n "$1" ] && cmnd="$cmnd -c $*"
  fi

  if [ -z "$1" ]; then
    echo 'Usage: R [R] [user@]host [cmd]' >&2 && exit 1
  fi

  local remote=$1; shift
  [ -z "$cmnd" ] && local cmnd=$*
  ssh -tx $remote $cmnd
}
# Remote Root
alias RR='R R'
