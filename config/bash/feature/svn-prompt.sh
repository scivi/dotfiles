# SVN prompt info
function svn_rev () {
	svn info 2>/dev/null | awk '/^Revision: / { printf("r%s", $2); }' 
}

function svn_last_author () {
	svn info 2>/dev/null | awk '/Author: / { print $4; }'
}

function svn_branch () {
  svn info 2>/dev/null | awk -F/ '/^URL:/ { print $8; }'
}

function svn_prompt_info () {
	echo "$(svn_branch)$white/$yellow$(svn_rev)"
}
