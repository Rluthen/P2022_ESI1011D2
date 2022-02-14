#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
#
# SPDX-License-Identifier: GPL-3.0-or-later

EMAIL=""

die ()
{
    >&2 echo -e "${*}"
    exit 1
}

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
            EMAIL=$1
        ;;
    esac
    shift
done

if [ -z "${EMAIL}" ]
then
    die "No se proporcionó un correo electrónico"
fi

HASH=$(echo ${EMAIL} | sha256sum | cut -f 1 -d " ")

if [ ! -d wireguard/${HASH} ]
then
    die "No se encuntrá configuración para tu correo"
fi

rm -rf alumno
mkdir alumno
cp wireguard/${HASH}/* alumno 

echo "Los archivos de configuración esta en el directorio alumno"
