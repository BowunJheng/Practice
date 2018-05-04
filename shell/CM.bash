#!/bin/bash
#
#LSInfo=( $(/bin/ls -d */) )
#for element in $(seq 0 $((${#LSInfo[@]} - 1 )))
#do
#    echo ${LSInfo[$element]}
#done
#-------------------------------------------

SupportModule=(PKE3349 PKE3368 Butterfly Bobcat Starfish)
SupportBFC=(/v3_tmm /bfc_systems /bfc_systems /bfc_systems_v4 /rbb_cm_src)
CheckEcos=(ecos20 eCos20)
DefaultEcos=("/usr/local" "/usr" $HOME)
nameOEMtools="zOEMtools_eCos"
GnuToolPath="gnutools/mipsisa32-elf/bin"
BrcmUtilPath="BrcmUtils"

#-------------------------------------------

fMATCHMODULE=()
ListMenu=()
ReturnEcosHome=""
EcosUtilPath=()

function showhelp ()
{
    echo "Usage: $0 Module/Branch"
    echo 
    echo "Support Module:[ PKE3349 PKE3368 Butterfly Bobcat ]"
    echo 
    echo "Ex1: #$0 PKE3349"
    echo "Ex2: #$0 No.Bobcat-20080606"
}

function matchmodule()
{
    for element in $(seq 0 $((${#SupportModule[@]} - 1 )))
    do
        if [[ $1 =~ ${SupportModule[$element]} ]]; then
            n=${#BASH_REMATCH[*]}
            fMATCHMODULE=(${fMATCHMODULE[@]} ${BASH_REMATCH[0]} $element)
        fi
        ListMenu=(${ListMenu[@]} ${SupportModule[$element]} $element);
    done
    return `expr ${#fMATCHMODULE[@]} / 2`
}

function selectmodule()
{
    MAXModule=$((${#fMATCHMODULE[@]} / 2 ))
    if [[ $MAXModule -eq 0 ]]; then
        MAXModule=${#SupportModule[@]}
    else
        ListMenu=(${fMATCHMODULE[@]})
    fi
    for element in $(seq 0 `expr $MAXModule - 1`)
    do
        echo "$element.) ${ListMenu[($element * 2)]}"
    done
    read -p "Please Select Module (0-"`expr $MAXModule - 1`"): (default:0)? " InputNUM
    returnNUM=1
    if [[ $InputNUM -lt $MAXModule && $InputNUM -ge 0 &&  -n $InputNUM ]]; then
        returnNUM=$(($InputNUM * 2 + 1))
    fi
    return $returnNUM
}

function CheckHomeEcos ()
{
    TrueFalse=0
    for element in $(seq 0 $((${#CheckEcos[@]} - 1 )))
    do
        CheckEcosDir="$PWD/$CODEPATH/${CheckEcos[$element]}"
        if [[ -d $CheckEcosDir ]]; then
            ReturnEcosHome=$CheckEcosDir
            TrueFalse=1
            break;
        fi
        CheckEcosDir="$PWD/$Module/$nameOEMtools/${CheckEcos[$element]}"
        if [[ -d $CheckEcosDir ]]; then
            ReturnEcosHome=$CheckEcosDir
            TrueFalse=1
            break;
        fi
    done
    return $TrueFalse
}

function CheckSysEcos ()
{
    NESTLOOPBREAK=0
    for pathelement in $(seq 0 $((${#DefaultEcos[@]} - 1 )))
    do
        for element in $(seq 0 $((${#CheckEcos[@]} - 1 )))
        do
            CheckEcosDir="${DefaultEcos[$pathelement]}/${CheckEcos[$element]}"
            if [[ -d $CheckEcosDir ]]; then
                ReturnEcosHome=$CheckEcosDir
                NESTLOOPBREAK=1
                break;
            fi
        done
        if [[ $NESTLOOPBREAK -eq 1 ]];then
            break;
        fi
    done
    return $NESTLOOPBREAK
}

function ExistDir2Array()
{
    if [[ -d $1 ]]; then
        EcosUtilPath=(${EcosUtilPath[@]} $1)
    fi
}

function CheckAllUtil ()
{
    for element in $(seq 0 $((${#CheckEcos[@]} - 1 )))
    do
        CheckEcosDir="$PWD/$CODEPATH/${CheckEcos[$element]}"
        if [[ -d $CheckEcosDir ]]; then
            ExistDir2Array "$CheckEcosDir/$GnuToolPath"
            ExistDir2Array "$CheckEcosDir/$BrcmUtilPath"
        fi
        CheckEcosDir="$PWD/$Module/$nameOEMtools/${CheckEcos[$element]}"
        if [[ -d $CheckEcosDir ]]; then
            ExistDir2Array "$CheckEcosDir/$GnuToolPath"
            ExistDir2Array "$CheckEcosDir/$BrcmUtilPath"
        fi
    done

    for pathelement in $(seq 0 $((${#DefaultEcos[@]} - 1 )))
    do
        for element in $(seq 0 $((${#CheckEcos[@]} - 1 )))
        do
            CheckEcosDir="${DefaultEcos[$pathelement]}/${CheckEcos[$element]}"
            if [[ -d $CheckEcosDir ]]; then
                ExistDir2Array "$CheckEcosDir/$GnuToolPath"
                ExistDir2Array "$CheckEcosDir/$BrcmUtilPath"
            fi
        done
    done
}

#-------------------------------------------

if [[ $# -lt 1 ]]; then
    showhelp
    return 1
fi

Module=$1
if [[ ${Module:(${#Module}-1)} = '/' ]]; then 
    Module=${Module:0:(${#Module}-1)}
fi

if [[ ! -d $Module ]]; then
    echo "[ERROR] Please Input an Existed Directory!!"
    return 2
fi

matchmodule $Module
MatchManyMod=$?
if [[ $MatchManyMod -eq 1 ]]; then
    CODEPATH="$Module${SupportBFC[${fMATCHMODULE[1]}]}"
else
    selectmodule
    CODEPATH="$Module${SupportBFC[${ListMenu[$?]}]}"
fi

if [[ -z $CODEPATH ]]; then
    echo "[ERROR] Please set CODEPATH env. value!!"
    return 3
else
    echo "[LOG] CODEPATH=\"$CODEPATH\""
fi

CheckHomeEcos
if [[ $? -eq 1 ]];then
    ECOS_HOME=$ReturnEcosHome
else
    CheckSysEcos
    if [[ $? -eq 1 ]];then
        ECOS_HOME=$ReturnEcosHome
    fi
fi

if [[ -z $ECOS_HOME ]];then
    echo "[ERROR] Please set ECOS_HOME env. value!!"
    return 3
else
    echo "[LOG] ECOS_HOME=\"$ECOS_HOME\""
fi

CheckAllUtil
for element in $(seq 0 $((${#EcosUtilPath[@]} - 1 )))
do
    if [[ $element -eq 0 ]]; then
        ADDPATH="${EcosUtilPath[$element]}"
    else
        ADDPATH="$ADDPATH:${EcosUtilPath[$element]}"
    fi
done

ECOSUTIL=$ECOS_HOME


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
export WORK_DIR="$PWD/$CODEPATH"


alias work="cd $WORK_DIR"
echo "[LOG] WORK_DIR=\"$WORK_DIR\""

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
#if [ -d $ECOSUTIL/gnutools/mipsisa32-elf/bin ] ; then
#   export PATH="$ECOSUTIL/gnutools/mipsisa32-elf/bin:$PATH"
#fi

# Here's where we find ProgramStore, MessageLogZapper, and some scripts.
#if [ -d $ECOSUTIL/brcmutils ] ; then
#   export PATH="$ECOSUTIL/brcmutils:$PATH"
#fi

export PATH="$ADDPATH:$PATH"

# Make sure we don't inherit this variable from a VxWorks configuration.
unset GCC_EXEC_PREFIX

export app_os_default=ecos
export bsp_os_default=ecos
export bsp_board_default=common

work
app
