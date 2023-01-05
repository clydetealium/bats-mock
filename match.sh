#!/bin/bash

function matches_re() {
  local actual=$1
  local expression=$2
  local message="\nFAILED ${FUNCNAME[0]}!\nGiven actual:\n'${actual}'\ndid not match expression:\n'${expression}'."

  outcome=$([[ "$actual" =~ $expression ]] && echo 0 || echo 1)
  check_outcome $outcome "$message"

  return $outcome
}

function contains() {
  local actual=$1
  local substring=$2
  local message="\nFAILED ${FUNCNAME[0]}!\nGiven actual:\n'${actual}'\ndid contain substring:\n'${substring}'."

  outcome=$([[ "$actual" == *"$substring"* ]] && echo 0 || echo 1)
  check_outcome $outcome "$message"

  return $outcome
}

function equals_num() {
  local actual=$1
  local expected=$2
  local message="\nFAILED ${FUNCNAME[0]}!\nGiven actual:\n'${actual}'\ndid not equal expected:\n'${expected}'."

  outcome=$([[ $actual -eq $expected ]] && echo 0 || echo 1)
  check_outcome $outcome "$message"

  return $outcome
}

function debug() {
  echo "status: $status"
  echo "output: $output"
}

function check_outcome() {
  local outcome=$1
  local message=$2

  if [[ "$outcome" -ne "0" ]]
  then
    echo -e $message
  fi
}

# export helpers
export -f matches_re
export -f contains
export -f equals_num
export -f debug
