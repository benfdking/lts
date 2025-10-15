#!/bin/sh
# LTS Shell Wrapper
# This wrapper provides interactive command execution for lts
# Source this file in your shell configuration (.bashrc, .zshrc, etc.)

lts() {
    # Check if --raw flag is present (for scripting/piping)
    for arg in "$@"; do
        if [ "$arg" = "--raw" ]; then
            command lts "$@"
            return $?
        fi
    done

    # Generate the command using the lts binary
    local cmd
    cmd=$(command lts "$@" 2>&1)
    local exit_code=$?

    # Check if command generation failed
    if [ $exit_code -ne 0 ]; then
        echo "$cmd" >&2
        return $exit_code
    fi

    # Display the generated command
    echo "Generated command:"
    echo "  $cmd"
    echo

    # Prompt for execution
    printf "Execute? (y/N): "
    read -r response

    case "$response" in
        [yY]|[yY][eE][sS])
            echo
            eval "$cmd"
            ;;
        *)
            echo "Command not executed."
            return 1
            ;;
    esac
}
