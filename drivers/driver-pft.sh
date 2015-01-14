FINEGRAINED_SUPPORTED=yes
NAMEEXTRA=

run_bench() {
	LOGDIR_TOPLEVEL=$LOGDIR_RESULTS
	for PAGESIZE in $PFT_PAGESIZES; do
		unset USE_DYNAMIC_HUGEPAGES
                unset PAGEPARAM
		case $PAGESIZE in
		base)
			PAGEPARAM=--smallonly
			disable_transhuge
			;;
		huge)
			PAGEPARAM=--hugeonly
			disable_transhuge
			;;
		dynhuge)
			PAGEPARAM=--hugeonly
			export USE_DYNAMIC_HUGEPAGES=yes
			disable_transhuge
			;;
		transhuge)
			PAGEPARAM=--smallonly
			if [ "$TRANSHUGE_AVAILABLE" = "yes" ]; then
				enable_transhuge
			else
				echo THP support unavailable for transhuge
				continue
			fi
			;;
		default)
			reset_transhuge
			;;
		esac

		export LOGDIR_RESULTS=$LOGDIR_TOPLEVEL/$PAGESIZE
		mkdir -p $LOGDIR_RESULTS
		$SHELLPACK_INCLUDE/shellpack-bench-pft $PAGEPARAM
		RETVAL=$?
	done
	export LOGDIR_RESULTS=$LOGDIR_TOPLEVEL
	return $RETVAL
}
