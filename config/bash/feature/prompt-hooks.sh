only_interactive

### Certain Informative Prompting
##
#
function setprompt() {
  if [ "`id -u`" -eq 0 ]; then
    # Certain Rooty Redness
    local usercolor=$red
  else
    # Certain Blueface Promptness
    local usercolor=$lightblue
  fi
  export PS1="$usercolor\u@$blue\h$white[\D{%d}.\t]$lightblue\!$white${LOCAL_PROMPT_INFO}$blue\w $red"'${exit_code/0/}'"${yellow}∴$white "
}

# Certain Window Betitling
function setwindowtitle() {
  echo -ne "\033]0;${LOCAL_WINDOW_INFO}:${PWD/$HOME/~}\007"
}

# To be overwritten by local config
function local_prompt_info () {
  export LOCAL_PROMPT_INFO=''
  export LOCAL_WINDOW_INFO=''
}

### Certain Prompt Bookkeeping and Chatterisms
##
#   To do stuff before printing the prompt.
function prompt_callback () {
	export exit_code=$?
	for fun in ${PROMPT_HOOKS[*]}; do
    	[ "$fun" = "prompt_callback" ] && continue
      maybe_run $fun
    done
}
export PROMPT_COMMAND=prompt_callback

function push_prompt_callback () {
  PROMPT_HOOKS=( "${PROMPT_HOOKS[@]}" "$@" )
}

function remove_prompt_callback () {
  let i=0
  for hook in ${PROMPT_HOOKS[*]}; do
    [ "$1" = "$hook" ] && unset PROMPT_HOOKS[$i] && break
    let i=i+1
  done
}

### Hooks

function prompt_hooks_init () {
  push_prompt_callback \
    local_prompt_info \
    setprompt \
    setwindowtitle
}
after_startup_do prompt_hooks_init
