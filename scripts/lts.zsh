# Function: calls lts-bin and inserts result into editor buffer
function lts() {
  local cmd
  if ! cmd=$(lts-bin "$@" 2>&1); then
    print -u2 -- "$cmd"
    return 1
  fi
  print -z -- "$cmd"
}
