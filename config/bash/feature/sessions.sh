only_interactive

###  Certain Permanentizing of Sessions
##
# For new shells to drop right into place, just call saveplace while still there.
# TODO: Should we keep the whole dirstack, not just the last place? And if so, restore with pushd -n
TTY=$(basename $(tty)); TTY=${TTY/tty/}; export TTY
export SESSION_STORE=~/.shsessions
export SESSION_SAVE=on
export SESSION_PLACE=$SESSION_STORE/place_for_$TTY

function saveplace() {
  [ ! -f $SESSION_PLACE ] && local um=$(umask -p) && umask 0077 && touch $SESSION_PLACE && `$um`
  [ "$1" == "on" ]    && chmod u+x $SESSION_PLACE && return
  [ "$1" == "off" ]   && echo > $SESSION_PLACE && chmod -x $SESSION_PLACE && return
  [ "$1" == "go" ]    && source $SESSION_PLACE && return
  [ $HOME != "$PWD" ] && echo cd \"$PWD\" > $SESSION_PLACE && chmod u+x $SESSION_PLACE && return
  # Going home means to switch it off..
  [ "$1" == "-f" -a $HOME == "$PWD" ] && chmod -x $SESSION_PLACE
}

alias dropplaces='chmod -x `dirname $SESSION_PLACE`/place_for_*'

function showplaces() {
  for f in `dirname $SESSION_PLACE`/place_for_*; do
    [ ! -s $f ] && continue
    if [ -x $f ]; then
      echo -n "[*] "
    else
      echo -n "    "
    fi
    echo -n $(basename $f | tr _ \ )": "
    awk "{print \$2;}" $f
  done
}

### Hooks
function oncd_maybe_saveplace () {
  [ "$SESSION_SAVE" == "on" ] && saveplace -f
}
push_chpwd oncd_maybe_saveplace

function jump_to_savedplace () {
  # Make sure our storage directory is there.
  [ -d $SESSION_STORE ] || mkdir -p $SESSION_STORE
  # This is a workaround when the session place might interfere.
  echo -n "** $EXEC_IMMEDIATELY"
  maybe_run exec $EXEC_IMMEDIATELY
  # Now go to stored directory, if any.
  if [ -x "$SESSION_PLACE" -a "$SESSION_SAVE" == "on" ]; then
    source $SESSION_PLACE >/dev/null && maybe_run invoke_chpwd_functions
    _log "Welcome back!"
  else
    # iTerm2 would end up in / instead of ~, so... let's make sure we go home.
    cd >/dev/null
    popd -n -1 >/dev/null
    _log "Welcome home!"
  fi
}
after_startup_do jump_to_savedplace
