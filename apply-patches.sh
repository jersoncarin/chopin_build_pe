#!/bin/bash

set -e

patches="$(readlink -f -- $1)"
tree="$2"
branches="$3 common"

for b in $branches;do
    for project in $(cd $patches/patches/$tree/$b; echo *);do
        p="$(tr _ / <<<$project |sed -e 's;platform/;;g')"
        [ "$p" == build ] && p=build/make
        [ "$p" == treble/app ] && p=treble_app
        [ "$p" == vendor/hardware/overlay ] && p=vendor/hardware_overlay
        pushd $p
        for patch in $patches/patches/$tree/$b/$project/*.patch;do
            git am $patch --reject || exit
        done
        popd
    done
done
