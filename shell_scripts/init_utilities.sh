#!/bin/bash

###################### COPYRIGHT/COPYLEFT ######################

# (C) 2020 Michael Soegtrop

# Released to the public under the
# Creative Commons CC0 1.0 Universal License
# See https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt

###################### UTILITY FUNCTIONS #####################

# ------------------------------------------------------------------------------
# Convert a version string in A.B.C.D format to a comparable number
# - the version string may have up to 4 components
# - each component may have up to 2 digits
#
# Parameters
# $1 version string
# ------------------------------------------------------------------------------

function version_to_number {
  printf "%d%02d%02d%02d" $(echo "$1" | tr '.' ' ');
}

# ------------------------------------------------------------------------------
# Check if a command is available
#
# Parameters
# $1 command ro check for, e.g. gcc, clang, curl
# ------------------------------------------------------------------------------

function check_command_available {
  if ! command -v "$1" &> /dev/null
  then
    echo "=========================== Missing prerequisite ============================"
    echo "This script requires command '$1' to be installed."
    echo "Please install this command manually using your system's package manager!"
    echo "This script will exit now."
    echo "Please restart the script after you installed '$1'."
    echo "=========================== Missing prerequisite ============================"
    return 1
  fi
}

# ------------------------------------------------------------------------------
# Ask a one option + cancel question
# Set environment variable ANSWER to the result
#
# $1 message
# $2 option 1 keys (only first is shown - this is also the retuen value)
# $3 option 1 text
# ------------------------------------------------------------------------------

function ask_user_opt1_cancel {
  while true; do
    read -p "$1 (${2:0:1} / c=cancel) " answer
    case "$answer" in
        [$2]* ) ANSWER=${2:0:1}; echo; return 0 ;;
        [cC]* ) return 1 ;;
        * ) echo "Please answer '${2:0:1}'=$3 or 'c'=cancel/exit.";;
    esac
  done
}

# ------------------------------------------------------------------------------
# Ask a two option + cancel question
# Set environment variable ANSWER to the result
#
# $1 message
# $2 option 1 keys (only first is shown - this is also the retuen value)
# $3 option 1 text
# $4 option 2 keys (only first is shown - this is also the retuen value)
# $5 option 2 text
# ------------------------------------------------------------------------------

function ask_user_opt2_cancel {
  while true; do
    read -p "$1 (${2:0:1} / ${4:0:1} / c=cancel) " answer
    case "$answer" in
        [$2]* ) ANSWER=${2:0:1}; echo; return 0 ;;
        [$4]* ) ANSWER=${4:0:1}; echo; return 0 ;;
        [cC]* ) return 1 ;;
        * ) echo "Please answer '${2:0:1}'=$3 or ${4:0:1}'=$5 or 'c'=cancel/exit.";;
    esac
  done
}

# ------------------------------------------------------------------------------
# Ask for a number
#
# $1 message
# $2 lower
# $3 upper
# ------------------------------------------------------------------------------

function ask_user_mumber {
  while true; do
    read -p "$1 (number in $2..$3) " answer
    case "$answer" in
        [cC]* ) return 1 ;;
    esac
    if [ "$2" -le "$answer" ] && [ "$answer" -le "$3" ]
    then
      ANSWER="$answer"
      echo
      return 0
    else
      echo "Please enter a number between $2 and $3 or c to cancel"
    fi
  done
}

# ------------------------------------------------------------------------------
# Determine the total and available RAM in kbyte
#
# results are stored in MEM_TOTAL and MEM_AVAIL
# ------------------------------------------------------------------------------

function get_memory_info {
  if [[ "$OSTYPE" == linux-gnu* ]]
  then
      echo "TODO: unimplemented"
    return 1
  elif [[ "$OSTYPE" == darwin* ]]
  then
    MEM_TOTAL=$(echo $(sysctl hw.memsize | awk '{print $2}') / 1024 | bc)
    MEM_AVAIL=$(echo '(' $(sysctl vm.page_free_count | awk '{print $2}') '+' $(sysctl vm.page_speculative_count | awk '{print $2}') ') * 4' | bc)
  elif [[ "$OSTYPE" == cygwin ]]
  then
      echo "TODO: unimplemented"
    return 1
  else
      echo "ERROR: unsopported OS type '$OSTYPE'"
      return 1
  fi
}
