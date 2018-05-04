#!/bin/bash
CVSCMD="cvs"
GREPCMD="grep"
CUTCMD="cut"
AWKCMD="awk"
RMCMD="rm"
CPCMD="cp"
MKDIRCMD="mkdir"
MVCMD="mv"
BACKNAME=".sbakj"
SEDCMD="sed"
CurrentStr="current"

#---------- other fucntions ----------
function CheckARGC ()
{
if [ -z $1 ];then
    echo "Checkout the change files between two revisions"
    echo ""
    echo "$ $0 #revision1"
    echo "        To get the different files between #revision1 and mainline"
    echo ""
    echo "$ $0 current"
    echo "        To get the different files between local and cvs server"
    echo "        [The files are in the list of files for cvs, not include those files which need to be added.]"
    echo ""
    echo "$ $0 #revision1 #revision2"
    echo "        To get the different files between #revision1 and #revision2"
    exit 1
fi
}

function SaveMV ()
{
    if [ -e $1 ] && [ -n $2 ];then
        $MVCMD $1 $2
        return 0
    fi
    return -1
}

#---------- main fucntion ----------
CheckARGC $1

if [ -z $2 ];then
    if [ $1 = $CurrentStr ];then
        UPDATE_INFO=( $($CVSCMD -q update -P -d 2>&1 | $AWKCMD '{if($1=="M") print $2}'))
        CREATEDIR="Diff_CVS_Local"
        DIR1="$CREATEDIR/CVS"
        DIR2="$CREATEDIR/Local"
    else
        #UPDATE_INFO=( $($CVSCMD -Q diff --brief -r $1 2>&1 | $GREPCMD -e '^Index:' | $CUTCMD -d" " -f2))
        UPDATE_INFO=( $($CVSCMD -Q diff --brief -r $1 2>&1 | $GREPCMD -e '^Index:' -e '^cvs server:' | $AWKCMD '{if($1!="Index:") print $(NF); else print $2}'))
        CREATEDIR="Diff_$1_Mainline"
        DIR1="$CREATEDIR/$1"
        DIR2="$CREATEDIR/Mainline"
    fi
else
    #UPDATE_INFO=( $($CVSCMD -Q diff --brief -r $1 -r $2 2>&1 | $GREPCMD -e '^Index:' | $CUTCMD -d" " -f2))
    UPDATE_INFO=( $($CVSCMD -Q diff --brief -r $1 -r $2 2>&1 | $GREPCMD -e '^Index:' -e '^cvs server:' | $AWKCMD '{if($1!="Index:") print $(NF); else print $2}'))
    CREATEDIR="Diff_$1_$2"
    DIR1="$CREATEDIR/$1"
    DIR2="$CREATEDIR/$2"
fi

if [ -d $CREATEDIR ];then
    $RMCMD -rf $CREATEDIR
fi
$MKDIRCMD $CREATEDIR
$MKDIRCMD "$DIR1"
$MKDIRCMD "$DIR2"
    
for element in $(seq 0 $((${#UPDATE_INFO[@]} - 1)))
do
    if [ -z ${UPDATE_INFO[$element]} ];then
        continue;
    fi
    echo ${UPDATE_INFO[$element]}
    #ORG_VERSION1=`$CVSCMD -q status ${UPDATE_INFO[$element]} | $GREPCMD -e 'Sticky Tag:' | $CUTCMD -f3`
    ORG_VERSION1=`$CVSCMD -q status ${UPDATE_INFO[$element]} | $GREPCMD -e 'Sticky Tag:' | $AWKCMD '{print $3}'`
    ORG_VERSION=""
    if [ "$ORG_VERSION1" = "(none)" ];then
        #ORG_VERSION=`$CVSCMD -q status ${UPDATE_INFO[$element]} | $GREPCMD -e 'Working revision:' | $CUTCMD -f2`
        ORG_VERSION=`$CVSCMD -q status ${UPDATE_INFO[$element]} | $GREPCMD -e 'Working revision:' | $AWKCMD '{print $3}'`
    else
        ORG_VERSION=$ORG_VERSION1;
    fi
    SaveMV ${UPDATE_INFO[$element]} "${UPDATE_INFO[$element]}_$BACKNAME"
    if [ $1 = $CurrentStr ];then
        Str01=`$CVSCMD -q update ${UPDATE_INFO[$element]} 2>&1`
        echo "$Str01 [CVS]"
    else
        Str01=`$CVSCMD -q update -r $1 ${UPDATE_INFO[$element]} 2>&1`
        echo "$Str01 [$1]"
    fi
    NEWPATH="$DIR1/`dirname ${UPDATE_INFO[$element]}`"
    $MKDIRCMD -p $NEWPATH
    SaveMV ${UPDATE_INFO[$element]} $NEWPATH
    if [ $? -eq -1 ];then
        echo "[Log] Can't move ${UPDATE_INFO[$element]} to $NEWPATH [$1]"
    fi
    if [ -z $2 ];then
        if [ $1 != $CurrentStr ];then
            Str02=`$CVSCMD -q update -A ${UPDATE_INFO[$element]} 2>&1`
            echo "$Str02 [Mainline]"
        fi
    else
        echo "$CVSCMD -q update -r $2 ${UPDATE_INFO[$element]} 2>&1"
        Str02=`$CVSCMD -q update -r $2 ${UPDATE_INFO[$element]} 2>&1`
        echo "$Str02 [$2]"
    fi
    NEWPATH="$DIR2/`dirname ${UPDATE_INFO[$element]}`"
    $MKDIRCMD -p $NEWPATH
    if [ $1 = $CurrentStr ];then
        $CPCMD "${UPDATE_INFO[$element]}_$BACKNAME" "$DIR2/${UPDATE_INFO[$element]}"
    else
        SaveMV ${UPDATE_INFO[$element]} $NEWPATH
        if [ $? -eq -1 ];then
            echo "[Log] Can't move ${UPDATE_INFO[$element]} to $NEWPATH [$2]"
        fi
        if [ -n $ORG_VERSION ];then
            $CVSCMD -q update -r $ORG_VERSION ${UPDATE_INFO[$element]}
        fi
    fi
    SaveMV "${UPDATE_INFO[$element]}_$BACKNAME" ${UPDATE_INFO[$element]}
done
