#!/usr/bin/env bash

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1}
  msg "$msg"
  exit "$code"
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m' WHITE='\033[1;37m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

parse_params() {
  flag=0
  param=''

  while :; do
    case "${1-}" in
      -g) unit="g" ;;
      -m) unit="m" ;;
      -k) unit="k" ;;
      -u | --unit)
        unit="${2-}"
        shift
        ;;
      -?*) die "Unknown option: $1" ;;
      *) break ;;
    esac
    shift
  done

  target_path=$1

  [[ -z "$target_path" ]] && die "The path is not specified"
  return 0
}

parse_params "$@"
setup_colors

GB=1073741824
MB=1048576
KB=1024

unit_size=0
if [[ "$unit" = "g" ]]; then
  unit_size=$GB
elif [[ "$unit" = "m" ]]; then
  unit_size=$MB
elif [[ "$unit" = "k" ]]; then
  unit_size=$KB
fi

human_readable_bytes() {
  local bytes=$(cat -)
  if [[ "$bytes" -gt "$GB" ]]; then
    unit_char="G"
    unit_bytes=$GB
    color=$RED
  elif [[ "$bytes" -gt $MB ]]; then
    unit_char="M"
    unit_bytes=$MB
    color=$GREEN
  elif [[ "$bytes" -gt $KB ]]; then
    unit_char="K"
    unit_bytes=$KB
    color=$BLUE
  else
    unit_char="B"
    unit_bytes=1
    color=$WHITE
  fi
  local n=$(echo "scale=1; ${bytes} / ${unit_bytes}" | bc)
  echo -e "${n}${color}${unit_char}${NOFORMAT}"
}

## GNU du
gdu -B 1 -d 1 "$target_path" 2>/dev/null | gsort -n -r -k 1 | while read line; do
  size=$(echo $line | awk '{ print $1 }')
  path=$(echo $line | awk '{ print $2 }')
  if [[ "$size" -gt "$unit_size" ]]; then
    printf "%25s\t%s\n" $(echo $size | human_readable_bytes) $path
  fi
done

