# Certain Barking at Trees
function prompt_git_branch () {
  local branch=$(git branch 2>/dev/null)
  if [ -n "$branch" ]; then
    branch=$(echo "$branch" | grep '^*')
    branch="(${branch:2})"
  else
    branch=''
  fi
  echo $branch
}

# AUTHOR: Geoffrey Grosenbach http://peepcode.com, from http://pastie.org/325104
# Extended to give zero or more different symbols as per git status.

# Get the name of the branch we are on
function git_prompt_info () {
  local branch_prompt=$(prompt_git_branch)
  if [ -n "$branch_prompt" ]; then
    local status_icon=$(git_status)
    echo "$branch_prompt$status_icon"
  fi
}
# Show character if changes are pending
function git_status () {
  local current_git_status=$(git status | egrep '^# [A-Z]' 2> /dev/null)
  local tag=""
  case "$current_git_status" in
    *Changes\ to\ be\ committed*) tag="$tag$lightyellow ✔" ;;
  esac
  case "$current_git_status" in
    *Your\ branch\ is\ ahead*)    tag="$tag$green ▲" ;;
  esac
  case "$current_git_status" in
    *Your\ branch\ is\ behind*)   tag="$tag$purple ▼" ;;
  esac
  case "$current_git_status" in
    *Changes\ not\ staged*)       tag="$tag$red ■" ;;
  esac
  case "$current_git_status" in
    *Untracked\ files*)           tag="$tag$red ✚" ;;
  esac
  case "$current_git_status" in
    *added\ to\ commit*)          tag="$tag$lightred ♺" ;;
  esac
  echo "$tag$white"
}
