_LOGLEVEL=1 source ~/.config/bash/load_features.sh \
  utils env aliases \
  history-per-path cd-hooks prompt-hooks sessions \
  git-prompt \
  locals

source ~/.config/bash/private/scivi-mac.sh
is_interactive && source ~/.config/bash/private/scivi-mac-interactive.sh
