source $BATS_TEST_DIRNAME/mock.sh

teardown() {
  clearMocks
}

@test "politely requires a specified utility" {
  run mock ""
  
  [[ $status -eq 0 ]] &&
  [[ $output == *"you must specify utility to mock"* ]]
}

@test "mocks utility" {
  run mock "utility: which"
  
  [[ -d "$BATS_TEST_DIRNAME/local_path" ]] &&
  [[ $status -eq 0 ]] &&
  [[ $output == *"mocked which, with status: 0, std out: '', std err: ''"* ]]
}

@test "mocks utility with status code" {
  run mock "utility: which status: 4"
  
  [[ -d "$BATS_TEST_DIRNAME/local_path" ]] &&
  [[ $status -eq 0 ]] &&
  [[ $output == *"mocked which, with status: 4, std out: '', std err: ''"* ]]
}

@test "mocks utility with status code demonstrated" {
  mock "utility: which status: 4"
  run which ls
  
  [[ $status -eq 4 ]]
}

@test "mocks utility with standard out demonstrated" {
  local stdout='blah blah meep mawp'
  mock "utility: which stdout: '$stdout'"
  run which ls
  
  [[ $status -eq 0 ]] &&
  [[ $output == *"$stdout"* ]]
}

@test "mocks utility with standard error demonstrated" {
  local stderr='dun dun DUN!'
  mock "utility: which status: 3 stderr: '$stderr'"
  run which ls

  [[ $status -eq 3 ]] &&
  [[ $output == *"$stderr"* ]]
}
