#!/bin/bash
# Author: Raphael Lekies

PKGNAME=$1
DIST=$2
DIST2=$3

tmpdir=$(mktemp -d /tmp/git-tmp.XXXXXX) > /dev/null || exit 1


pushd "$tmpdir" || exit 1
git clone https://github.com/IT4smart/base-files-controller-it4smart.git .
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
git tag -l | sort -u -r | while read TAG ; do
	if [ $NEXT ];then
		echo "${PKGNAME} (${NEXT#'v'}~${DIST2}) ${DIST}; urgency=low"
	fi

	GIT_PAGER=cat git log --no-merges --format="  * %s%n" $TAG..$NEXT

    if [ $NEXT ];then
        echo " -- IT4smart GmbH <support@it4smart.eu>  $(git log -n1 --no-merges --format='%aD' $NEXT)"
    fi
    NEXT=$TAG
done
FIRST=$(git tag -l | head -1)
echo
echo "${PKGNAME} (${FIRST#'v'}~${DIST2}) ${DIST}; urgency=low"
GIT_PAGER=cat git log --no-merges --format="  * %s%n" $FIRST
echo " -- IT4smart  GmbH <support@it4smart.eu> $(git log -n1 --no-merges --format='%aD' $FIRST)"
popd > /dev/null

rm -rf "$tmpdir"