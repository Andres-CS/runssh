setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'

}

@test "Test run runssh" {
    run /home/$USER/Development/5_runssh/runssh.sh
    assert_output --partial 'Welcome'
}