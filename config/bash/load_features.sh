### Certain Feature Loading
##  For a feature-rich bash.
#
function _boot_features () {
	# this is mandatory: base and OS-specifics
	source ~/.config/bash/feature/base.sh
	source ~/.config/bash/feature/$(uname).sh

	_log -n '~~ This shell features'
	for feature in $*; do load_feature $feature; done
	_log ' ~~'
	export FEATURES
}

# Certain Requiring of Feature Scripts
function load_feature () {
	local feature=$1
	local file=~/.config/bash/feature/$feature.sh

	[[ "${FEATURES[*]}" =~ "$feature" ]] && return
	[ -r $file ] || return

	source $file && \
		_log -n " $feature" && \
		FEATURES=( "${FEATURES[@]}" "$feature" )
}

function _cleanup () {
	unset -f _load_features
	unset -f _boot_features
	unset -f _cleanup
}

# Main
function _load_features () {
	export STARTUP='in progress'

	_boot_features $*
  _cleanup
	run_after_startup_hooks

	unset STARTUP
}

_load_features $*
true
