#!/bin/sh
# LTS Shell Integration
# This script provides shell wrappers that inject commands into your prompt

# Bash integration
lts_bash_integration() {
    cat << 'EOF'
# LTS wrapper for bash - adds command to readline buffer
lts() {
    local cmd
    cmd=$(command lts "$@")
    if [ $? -eq 0 ] && [ -n "$cmd" ]; then
        # Use bind to insert command into readline buffer
        bind '"\e[0n": "'"$cmd"'"'
        bind '"\e[0n"'
    fi
}
EOF
}

# Zsh integration
lts_zsh_integration() {
    cat << 'EOF'
# LTS wrapper for zsh - adds command to buffer
lts() {
    local cmd
    cmd=$(command lts "$@")
    if [ $? -eq 0 ] && [ -n "$cmd" ]; then
        # Use print -z to add to zsh buffer
        print -z "$cmd"
    fi
}
EOF
}

# Fish integration
lts_fish_integration() {
    cat << 'EOF'
# LTS wrapper for fish - adds command to commandline
function lts
    set -l cmd (command lts $argv)
    if test $status -eq 0; and test -n "$cmd"
        # Use commandline to set the buffer
        commandline -r "$cmd"
    end
end
EOF
}

# Detect shell and output appropriate integration
detect_and_output() {
    case "$1" in
        bash)
            lts_bash_integration
            ;;
        zsh)
            lts_zsh_integration
            ;;
        fish)
            lts_fish_integration
            ;;
        *)
            echo "Unsupported shell: $1" >&2
            echo "Supported shells: bash, zsh, fish" >&2
            exit 1
            ;;
    esac
}

# If script is sourced, detect current shell
if [ -n "$BASH_VERSION" ]; then
    eval "$(lts_bash_integration)"
    echo "LTS bash integration loaded. Commands will now appear in your prompt."
elif [ -n "$ZSH_VERSION" ]; then
    eval "$(lts_zsh_integration)"
    echo "LTS zsh integration loaded. Commands will now appear in your prompt."
else
    # If not sourced or unknown shell, show usage
    cat << 'USAGE'
LTS Shell Integration

To enable command injection into your shell prompt:

Bash:
  echo 'eval "$(lts shell-integration bash)"' >> ~/.bashrc

Zsh:
  echo 'eval "$(lts shell-integration zsh)"' >> ~/.zshrc

Fish:
  lts shell-integration fish > ~/.config/fish/conf.d/lts.fish

Or manually source this script:
  source shell-integration.sh
USAGE
fi
