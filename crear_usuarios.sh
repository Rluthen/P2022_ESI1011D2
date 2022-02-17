#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

crear_usuario ()
{
    usuario=$(cat $1 | cut -f 3 -d " " | cut -f 1 -d @)
    useradd -m -c "${usuario}" ${usuario}
    mkdir /home/${usuario}/.ssh
    cp $1 /home/${usuario}/.ssh/authorized_keys
    chmod 600 /home/${usuario}/.ssh/authorized_keys
    chmod 700 /home/${usuario}/.ssh
    chown -R ${usuario}:${usuario} /home/${usuario}/.ssh
    usermod -a -G users ${usuario}
}

if [ $UID != 0 ]
then
    echo "Por favor ejecutar como root"
    exit 1
fi

while [ -n "${1}" ]
do
    case "$1" in
        -d|--debug)
            set -x
        ;;
        -e|--error)
            set -e
        ;;
        *)
            if test -f $1
            then
                crear_usuario $1
            fi
        ;;
    esac
    shift
done

