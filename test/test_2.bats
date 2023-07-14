setup() {
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"
    
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
}

@test "Test run runssh" {
    run ./runssh.sh
    assert_output --partial 'Welcome'
}