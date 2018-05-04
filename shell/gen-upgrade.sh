#!/bin/sh
echo "opkg update"
opkg list_installed | sed 's/ - .*//' | sed 's/\(^.*$\)/echo "[\1]";opkg upgrade \1/'
