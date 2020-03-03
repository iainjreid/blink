#!/bin/bash

. deps/term/term.sh

read -r -d "" usage <<EOM
Usage: blink
TODO: Write me!
EOM

clear_tty() {
  tput smcup
  clear
}

reset_tty() {
  tput rmcup
}

#
# Create a new project.
#
new() {
  if [[ -z ${1} ]]; then
    echo "Please provide a path!" && exit 1
  fi

  if [[ -d ${1} ]]; then
    echo "Path already exists!" && exit 1
  fi

  mkdir -p ${1}

  touch ${1}/dimensions
  touch ${1}/history

  open ${1}
}

#
# Load a project.
#
open() {
  if [[ -z ${1} ]]; then
    echo "Please provide a path!" && exit 1
  fi

  if [[ ! -d ${1} ]]; then
    echo "Project not found!" && exit 1
  fi

  clear_tty && trap reset_tty EXIT

  width=$(expr $(stty size | cut -d" " -f2) / 2)
  height=$(stty size | cut -d" " -f1)

  echo "${width}x${height}" > ${1}/dimensions

  tail -f ${1}/history | while read line; do
    out=""

    for char in ${line//,/ }; do
      case $char in
        0)
          out="${out}‏‏‎  " ;;
        1)
          out="${out}██" ;;
        *)
          exit 1;
      esac
    done

    term_move 0 $((( $_y + 1 ) % $height))
    term_write "$out"
  done
}

while [[ $# > 0 ]]; do
  case "$1" in
    help)
      echo "$usage"; exit 1
      ;;
    n|new)
      new ${2}; shift
      ;;
    o|open)
      open ${2}; shift
      ;;
    *)
      echo "Unknown command: ${1}"; exit 1
      ;;
  esac

  shift
done

## No commands or arguments specified?! Show them the usage block!
echo "$usage"
