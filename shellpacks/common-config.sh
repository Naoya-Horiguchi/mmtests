export PROFILE_PATH=$SCRIPTDIR
export SHELLPACK_TOPLEVEL=$SCRIPTDIR
export SHELLPACK_STAP=$SHELLPACK_TOPLEVEL/stap-scripts
export SHELLPACK_TEST_MOUNT=$SCRIPTDIR/work/testdisk
export SHELLPACK_SOURCES=$SHELLPACK_TEST_MOUNT/sources
export SHELLPACK_TEMP=$SHELLPACK_TEST_MOUNT/tmp/$$
export SHELLPACK_INCLUDE=$SCRIPTDIR/shellpacks
export SHELLPACK_LOG=$SCRIPTDIR/work/log
export LINUX_GIT=/src/linux-dev
[ ! "$WEBROOT" ] && export WEBROOT=http://nfssv.rhts.fuchu/export/data/user/n-horiguchi/mmtests-mirror
export SSHROOT=`echo $WEBROOT | sed -e 's/http:\/\//ssh:\/\/root@/'`/public_html
export TESTDISK_DIR
