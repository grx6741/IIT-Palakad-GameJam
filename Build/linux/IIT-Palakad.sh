#!/bin/sh
echo -ne '\033c\033]0;IIT-Palakad\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/IIT-Palakad.x86_64" "$@"
