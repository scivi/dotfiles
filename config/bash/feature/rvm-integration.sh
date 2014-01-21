### Certain RVM Integration
##
#

# Certain RVM Info in the Prompt
function rvm_prompt_info () {
  local rvm_prompt_info=$(rvm-prompt u)
  if [ -n "$rvm_prompt_info" ]; then
    local gemset=$(rvm-prompt g)
    echo "$purple $rvm_prompt_info ${gemset/@/}"
  fi
}

# Re-add RVM load .ruby-* / .rvmrc after cd, and after session-restore.
function rvm_rvmrc_init () {
  push_prompt_callback rvm_rvmrc_session_restore
  push_chpwd __rvm_project_rvmrc
}

# We need to wait for RVM to become available, hence we run that in a prompt hook once.
function rvm_rvmrc_session_restore () {
  __rvm_project_rvmrc
  remove_prompt_callback rvm_rvmrc_session_restore
}

after_startup_do rvm_rvmrc_init
