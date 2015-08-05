FINEGRAINED_SUPPORTED=no
NAMEEXTRA=

run_bench() {
	bash $SCRIPTDIR/shellpacks/shellpack-bench-compact-test
	return $?
}
