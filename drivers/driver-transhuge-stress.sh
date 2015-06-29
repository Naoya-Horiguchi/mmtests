run_bench() {
    local options=

    if [ "$TRANSHUGE_STRESS_TESTTIME" ] ; then
        options="$options --testtime $TRANSHUGE_STRESS_TESTTIME"
    fi
    $SHELLPACK_INCLUDE/shellpack-bench-transhuge-stress $options
    return $?
}
