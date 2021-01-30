#!/bin/sh

if [ "$1" = "-h" -o "$1" = "--help" ]; then
	echo "Usage: xcp [source] [destination]"
	echo
	echo "Copies files/drectories from <source> to <destionation>"
	echo "Source and destination can be actual files or SCP URLs"
	exit 0
fi

if [ -n "$SPASS" -o -n "$DPASS" ] && ! which sshpass >/dev/null 2>&1; then
	echo "Please install sshpass to use SPASS and DPASS options."
	exit 1
fi

src=$1
dst=$2

[ -z "$src" ] && echo "missing source" && exit 1
[ -z "$dst" ] && echo "missing destination" && exit 1

updir=
uptgt=$src
if echo $src | grep ':'; then
	[ -n "$SPASS" ] && PASS="sshpass -p $SPASS" || PASS=
	updir=`mktemp -d /tmp/xcp.XXXXXX`/
	uptgt=`basename $src`
	$PASS scp -r $src $updir || {
		rm -r $updir
		exit $?
	}
fi

if echo $dst | grep ':'; then
	[ -n "$DPASS" ] && PASS="sshpass -p $DPASS" || PASS=
	$PASS scp -r "$updir""$uptgt" $dst
else
	cp -r "$updir""$uptgt" $dst
fi

[ -n "$updir" ] && rm -r $updir
