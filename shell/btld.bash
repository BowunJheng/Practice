#!/bin/bash

shopt -s extglob

# set -a

alias ls="ls -F"
alias sd="cd"
alias path='echo $PATH'

alias bsp=". bsp.bash"
alias app=". app.bash"
alias top=". top.bash"
alias up=". up.bash"
alias root=". root.bash"
alias td=". td.bash"
alias tdx=". tdx.bash"
# alias work="cd /projects/bfc/work/$USER"

PS1="[\[\033[1;35m\]\$(date +%H:%M:%S):\[\033[1;36m\]\w\[\033[0m\]](WORK)$"

#if [ -d /tools/brcmutils ] ; then
#   PATH="$PATH:/tools/brcmutils"
#fi

# Here's where we find ProgramStore, MessageLogZapper, and some scripts.
if [ -d ~/ecos20/brcmutils ] ; then
   PATH="$PATH:~/ecos20/brcmutils"
fi

# ECOS_DIR is the root directory for the eCos installation - including the
# Gnu tools
export ECOS_DIR="~/ecos20"

# ECOS_CONFIG_ROOT is the root directory for the eCos configurations, include
# files, and libraries.
export ECOS_CONFIG_ROOT=${ECOS_DIR}

# ECOS_CONFIG_DIR is the active eCos configuration directory.
export ECOS_CONFIG_DIR="bcm33xx/bcm33xx_install"

# Add the Gnu cross-development tools to the path
if [ -d $ECOS_DIR/gnutools/mipsisa32-elf/bin ] ; then
   PATH="$ECOS_DIR/gnutools/mipsisa32-elf/bin:$PATH"
fi

# Make sure we don't inherit this variable from a VxWorks configuration.
unset GCC_EXEC_PREFIX

export app_os_default=ecos
export bsp_os_default=ecos
export bsp_board_default=common
