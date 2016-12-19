only_interactive

# Local configuration. Should be loaded last.

# Set local prompt and window info
function local_prompt_info () {
  #export LOCAL_PROMPT_INFO="$(git_prompt_info)$(rvm_prompt_info) "
  export LOCAL_PROMPT_INFO="$(git_prompt_info) "
  export LOCAL_WINDOW_INFO="$USER@$(hostname -s)"
}
