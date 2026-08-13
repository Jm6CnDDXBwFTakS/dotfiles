#!/bin/bash

source ~/.config/shells/shared/profile

# If there are multiple matches for completion, Tab should cycle through them
bind 'TAB: menu-complete'
# And Shift-Tab should cycle backwards
bind '"\e[Z": menu-complete-backward'

# Display a list of the matching files
bind "set show-all-if-ambiguous on"

# Perform partial (common) completion on the first Tab press, only start
# cycling full results on the second Tab press (from bash version 5)
bind "set menu-complete-display-prefix on"

# Case-insensitive tab completion
bind "set completion-ignore-case on"

export UNAME_OUTPUT=$(uname -o)
export PROMPT_DIRTRIM=0
export PS1='\[\033]0;\w : @\h\007\]\n\[\033[32m\]\u@\h:\[\033[33m\]\w \[\033[35m\]$UNAME_OUTPUT\[\033[36m\]`__git_ps1`\[\033[0m\]\n$ '

export GIT_PS1_SHOWCOLORHINTS="true"
export GIT_PS1_SHOWDIRTYSTATE="true"
export GIT_PS1_SHOWUNTRACKEDFILES="true"
export GIT_PS1_SHOWUPSTREAM="verbose"
