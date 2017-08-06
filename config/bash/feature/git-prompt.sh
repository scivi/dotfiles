# Certain Barking at Trees
# Get the name of the branch we are on
function git_prompt_info () {
  local branch_prompt=$(prompt_git_branch)
  if [ -n "$branch_prompt" ]; then
    local status_icon=$(git_status)
    echo "($branch_prompt)$status_icon"
  fi
}

function prompt_git_branch () {
  local GIT_BRANCH=$(git branch 2>/dev/null | grep '^*')
  GIT_BRANCH=${GIT_BRANCH:2}
  echo $GIT_BRANCH
}

# Show character if changes are pending
# AUTHOR: Geoffrey Grosenbach http://peepcode.com, from http://pastie.org/325104
# Extended to give zero or more different symbols as per git status.
function git_status () {
  local current_git_status=$(git status 2>/dev/null)
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
