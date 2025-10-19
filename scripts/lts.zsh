# Function: calls lts-bin and inserts result into editor buffer
function lts() {
  # For init and help, call the binary directly without shell integration
  if [[ "$1" == "init" || "$1" == "help" || "$1" == "--help" || "$1" == "-h" ]]; then
    lts-bin "$@"
    return $?
  fi

  local cmd
  if ! cmd=$(lts-bin "$@" 2>&1); then
    print -u2 -- "$cmd"
    return 1
  fi
  print -z -- "$cmd"
}
