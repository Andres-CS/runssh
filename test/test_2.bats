setup() {
    load 'test_helper/bats-support/load.bash'
    load 'test_helper/bats-assert/load.bash'

    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"
}

@test "Test run runssh" {
    run ./runssh.sh
    assert_output --partial 'Welcome'
}