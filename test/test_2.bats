load '../node_modules/bats-support/load'
load '../node_modules/bats-assert/load'

setup() {
    DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )"
    PATH="$DIR/../src:$PATH"
}

@test "Test run runssh" {
    run ./src/runssh.sh
    assert_output --partial 'Welcome'
}