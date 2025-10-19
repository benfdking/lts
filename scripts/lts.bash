# Function: calls lts-bin and inserts result into readline buffer
function lts() {
  local cmd
  if ! cmd=$(lts-bin "$@" 2>&1); then
    echo "$cmd" >&2
    return 1
  fi
  READLINE_LINE="$cmd"
  READLINE_POINT=${#READLINE_LINE}
}
