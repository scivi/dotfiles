only_interactive

### Certainly Stolen From ZSH: cd hooks
##
# To have an array of functions to be run after changing the directory.
function invoke_chpwd_functions () {
  if [ "$OLDPWD" != "$PWD" -a "$chpwd_last_invoked" != "$PWD" ]; then
    for fun in ${chpwd_functions[*]}; do
      [ "$fun" = "invoke_chpwd_functions" ] && continue
      maybe_run $fun
    done
    chpwd_last_invoked="$PWD"
    [ "$chpwd_silent" == "next" ] && unset chpwd_silent
  fi
}

function push_chpwd () {
  chpwd_functions=( "${chpwd_functions[@]}" "$@" )
}

# Display useful things on arrival in a new place.
function oncd_todo () {
  [ -z "$chpwd_silent" -a -r TODO ] && echo "· $PWD's TODO: »" && cat TODO && echo "«"
}
function oncd_maybe_readme () {
  [ -z "$chpwd_silent" -a ! -r TODO -a -r README ] && echo "· $PWD's README: »" && cat README && echo "«"
}
function oncd_setenv () {
  [ -z "$chpwd_silent" -a -x .direnv ] && source .direnv
  [ -r .env ] && source .env
}

# Certain Enabling of a Silent Welcome
# the previous hooks check for $chpwd_silent and skip printing if set.
function silently () {
  export chpwd_silent="next"
  "$*"
}

# Certain Silencing of any Subshell
[ $SHLVL -gt 1 ] && export chpwd_silent="I'm a shy subshell."

function cd_hook_init () {
  # Setup hooks to run on directory change
  push_chpwd \
    oncd_setenv \
    oncd_todo \
    oncd_maybe_readme

  # Check for changed PWD on each prompt
  push_prompt_callback invoke_chpwd_functions
}

after_startup_do cd_hook_init
