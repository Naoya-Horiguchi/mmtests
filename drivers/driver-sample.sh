FINEGRAINED_SUPPORTED=yes
NAMEEXTRA=

run_bench() {
    printenv
    LOGDIR_TOPLEVEL=$LOGDIR_RESULTS
    $SCRIPTDIR/shellpacks/shellpack-bench-sample
    return $?
}
