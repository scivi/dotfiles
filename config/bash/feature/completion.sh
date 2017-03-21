only_interactive

# Certainly complete completions
for dotfile in \
  $(brew --prefix)/etc/bash_completion \
  $(brew --prefix)/share/bash-completion/bash_completion \
  $(brew --prefix)/opt/git/share/zsh/site-functions/git-completion.bash
do
  [ -f $dotfile ] && source $dotfile
done

# Add tab completion for `defaults read|write NSGlobalDomain`
complete -W "NSGlobalDomain" defaults;
