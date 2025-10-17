#!/bin/sh
# LTS Shell Wrapper
# This wrapper provides interactive command execution for lts
#
# When installed via Homebrew, this script is installed as 'lts' and calls 'lts-bin'
# When sourced manually, this defines an lts() function that wraps the lts binary

# Determine the underlying binary name
# If lts-bin exists in PATH, use it (Homebrew installation)
# Otherwise use 'lts' (manual source installation)
LTS_BINARY="lts-bin"

# Check if --raw flag is present (for scripting/piping)
for arg in "$@"; do
  if [ "$arg" = "--raw" ]; then
    command "$LTS_BINARY" "$@"
    return $?
  fi
done

# Pass through subcommands directly (help, init, completion)
if [ $# -gt 0 ]; then
  case "$1" in
  help | init | completion | --help | -h)
    command "$LTS_BINARY" "$@"
    return $?
    ;;
  esac
fi

# Generate the command using the lts binary
cmd=$(command "$LTS_BINARY" "$@" 2>&1)
exit_code=$?

# Check if command generation failed
if [ $exit_code -ne 0 ]; then
  echo "$cmd" >&2
  return $exit_code
fi

# Pre-fill the command in the shell buffer
# Use shell-specific method to push command to input buffer
if [ -n "$ZSH_VERSION" ]; then
  # Zsh: use print -z to push to buffer stack
  print -z "$cmd"
elif [ -n "$BASH_VERSION" ]; then
  # Bash: use bind to pre-fill readline
  bind '"\e[0n": "'"$cmd"'"'
  printf '\e[5n'
else
  # Fallback for other shells: just print the command
  echo "$cmd"
fi
