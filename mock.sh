#!/bin/bash

MOCK_BASE_DIR=${BATS_TEST_DIRNAME:-.}
MOCK_PATH=$MOCK_BASE_DIR/local_path
export OLD_PATH=$PATH

MOCKED_UTILITY='[[:blank:]]+utility: ([a-z]+)[[:blank:]]+'
MOCKED_STATUS_CODE='[[:blank:]]+status: ([0-9]+)[[:blank:]]+'
MOCKED_STANDARD_OUT="[[:blank:]]+stdout: ['\"](.*)['\"][[:blank:]]+"
MOCKED_STANDARD_ERROR="[[:blank:]]+stderr: ['\"](.*)['\"][[:blank:]]+"

mock() {
  local expression=" ${1} "
  local utility=''
  local status_code=0
  local standard_out=''
  local standard_error=''

  if [[ "$expression" =~ $MOCKED_UTILITY ]]
  then 
    utility=${BASH_REMATCH[1]}
  fi

  if [[ "$expression" =~ $MOCKED_STATUS_CODE ]]
  then
    status_code=${BASH_REMATCH[1]}
  fi
  
  if [[ "$expression" =~ $MOCKED_STANDARD_OUT ]]
  then
    standard_out=${BASH_REMATCH[1]}
  fi

  if [[ "$expression" =~ $MOCKED_STANDARD_ERROR ]]
  then
    standard_error=${BASH_REMATCH[1]}
  fi

  if [[ -z "$utility" ]]
  then
    echo "you must specify utility to mock"
  else
    _mock "$utility" "$status_code" "$standard_out" "$standard_error"
    echo "mocked $utility, with status: $status_code, std out: '$standard_out', std err: '$standard_error'"
  fi
}

export -f mock

_mock() {
  local utility=$1
  local status_code=$2
  local standard_out=$3
  local standard_error=$4

  mkdir -p $MOCK_PATH
  PATH=$MOCK_PATH:$PATH

  touch $MOCK_PATH/$utility
  cat > "$MOCK_PATH/$utility" <<EOF
#!/bin/bash
if [[ ! -z '$standard_out' ]]; then echo '$standard_out'; fi;
if [[ ! -z '$standard_error' ]]; then echo '$standard_error'; fi;
exit $status_code
EOF
  chmod +x $MOCK_PATH/$utility
}

export -f _mock

clearMocks() {
  PATH=$OLD_PATH
  if [[ -d $MOCK_PATH ]]
  then
    rm -rf $MOCK_PATH
  fi
}

export -f clearMocks
