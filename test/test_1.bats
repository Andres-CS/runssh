setup() {
    load './test/test_helper/bats-support/load'
    load './test/test_helper/bats-assert/load'

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"
}

@test "Test string len" {
    source ./test/functions.sh
    local -a strings=("1" "22" "333" "4444" "55555")
    len="$(largest_string ${strings[@]})"
    [ "$len" -eq 5 ] 
}

@test "Test echo error message" {
    source ./test/functions.sh
    run err_msg 'ERROR'
    assert_success
    assert_output --partial 'ERROR'
}

@test "Test echo success message" {
    source ./test/functions.sh
    run succ_msg 'SUCCESS'
    assert_success
    assert_output --partial 'SUCCESS'
}

@test "Test echo welcome message" {
    source ./test/functions.sh
    run welcome_msg
    assert_success
    assert_output --partial 'Welcome to RunSSH'
}