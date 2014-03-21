# Darwin-only features

alias free='vm_stat'
alias psf='ps -axu'
alias mat='open *.tmproj'
alias ls='ls -kG'  # KiB, Color
alias dir='ls -Fx' # Type marker, across.
alias pstree='pstree -g2 -w'

for d in /opt /opt/local /usr/local; do
  [ -d $d/bin ] && prepend_path PATH $d/bin
done

for d in /opt/local/share; do
  [ -d $d/man ] && prepend_path MANPATH $d/man
done

# Certain Shorthands of Folders
for d in ~/web ~/lib ~/Sites ~/Documents; do
  [ -d $d ] && append_path CDPATH $d
done
export CDPATH

# Certain Mac OS X integration
# From http://hints.macworld.com/article.php?story=20060719155640762
function ff() {
  osascript \
    -e 'tell application "Finder"' \
    -e   "if (${1-1} <= (count Finder windows)) then" \
    -e     "get POSIX path of (target of window ${1-1} as alias)" \
    -e   'else'
    -e     'get POSIX path of (desktop as alias)' \
    -e   'end if'
    -e 'end tell';
}

# Cd to where the current Finder window is.
function cdf() { pushd "`ff $@`"; }
