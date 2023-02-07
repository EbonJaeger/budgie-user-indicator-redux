#!/bin/bash

# Script adapted from Budgie Desktop

function do_gettext()
{
    xgettext --package-name=budgie-user-indicator-redux --package-version=1.0.0 $* --default-domain=budgie-user-indicator-redux --join-existing --from-code=UTF-8 --no-wrap
}

function do_intltool()
{
    intltool-extract --type=$1 $2
}

rm budgie-user-indicator-redux.po -f
touch budgie-user-indicator-redux.po

for file in `find src -name "*.vala"`; do
    if [[ `grep -F "_(\"" $file` ]]; then
        do_gettext $file --add-comments
    fi
done

for file in `find src -name "*.ui"`; do
    if [[ `grep -F "translatable=\"yes\"" $file` ]]; then
        do_intltool gettext/glade $file
        do_gettext ${file}.h --add-comments --keyword=N_:1
        rm $file.h
    fi
done

for file in `find src -name "*.in"`; do
    if [[ `grep -E "^_*" $file` ]]; then
        do_intltool gettext/keys $file
        do_gettext ${file}.h --add-comments --keyword=N_:1
        rm $file.h
    fi
done

mv budgie-user-indicator-redux.po po/budgie-user-indicator-redux.pot
tx push -s
