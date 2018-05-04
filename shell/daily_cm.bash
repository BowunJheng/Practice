#!/bin/bash

CODEPATH="Butterfly/bfc_systems"
ECOS_HOME="/home/daily/$CODEPATH/ecos20"
ECOSUTIL="~/ecos20"

if [ $1 != "history=100" ] ; then
	CODEPATH=$1
fi

shopt -s extglob
# set -a

alias ls="ls -F"
alias sd="cd"
alias path='echo $PATH'

alias bsp=". bsp.bash"
alias app=". app.bash e"
alias top=". top.bash"
alias up=". up.bash"
alias root=". root.bash"
alias td=". td.bash"
alias tdx=". tdx.bash"

export ECOS_DIR=$ECOS_HOME
export WORK_DIR="/home/daily/$CODEPATH"

alias work="cd $WORK_DIR"
echo "$WORK_DIR"

PS1="[\[\033[1;35m\]\$(date +%H:%M:%S):\[\033[1;36m\]\w\[\033[0m\]](WORK)$"

#if [ -d /tools/brcmutils ] ; then
#   PATH="$PATH:/tools/brcmutils"
#fi

# ECOS_DIR is the root directory for the eCos installation - including the
# Gnu tools


# ECOS_CONFIG_ROOT is the root directory for the eCos configurations, include
# files, and libraries.
#export ECOS_CONFIG_ROOT=${ECOS_DIR}
export ECOS_CONFIG_ROOT=$ECOS_HOME

# ECOS_CONFIG_DIR is the active eCos configuration directory.
#export ECOS_CONFIG_DIR="Bcm33xx/bcm33xx_install"
export ECOS_CONFIG_DIR="bcm33xx/bcm33xx_install"

# Add the Gnu cross-development tools to the path
if [ -d $ECOSUTIL/gnutools/mipsisa32-elf/bin ] ; then
   export PATH="$ECOSUTIL/gnutools/mipsisa32-elf/bin:$PATH"
fi

# Here's where we find ProgramStore, MessageLogZapper, and some scripts.
if [ -d $ECOSUTIL/brcmutils ] ; then
   export PATH="$ECOSUTIL/brcmutils:$PATH"
fi

# Make sure we don't inherit this variable from a VxWorks configuration.
unset GCC_EXEC_PREFIX

export app_os_default=ecos
export bsp_os_default=ecos
export bsp_board_default=common

