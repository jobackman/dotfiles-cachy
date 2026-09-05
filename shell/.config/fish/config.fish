source /usr/share/cachyos-fish-config/cachyos-config.fish

# Set up fzf key bindings
fzf --fish | source

zoxide init fish | source

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/johan/.lmstudio/bin
# End of LM Studio CLI section

mise activate fish | source