#****************************************************************************
#*    Author: Jeff Mou
#*    Date: 20061225
#*    Revision: 1.0
#*    Description:
#*      // when you want to add a new file to cvs. this will prompt file name and ask if you want to add a new file.
#*			sh cvs.sh add
#*      //this will list the files you have updated in the end. 
#*      sh cvs.sh update
#*
#*    Author: bw.cheng
#*    Date: 20070702
#*    Revision: 1.7
#*    Description:
#*      // 1.1
#*      // recursively commit the source tree for cvs
#*      // 1.5
#*      // addmenu
#*      // file extension name filter ( DERSERT_EXT=".bin.jpg.png" )
#*      // 1.6
#*      // forceallDIR
#*      // 1.7
#*      // rename forceallDIR to forceDIR
#*      // page_inv: inverse page all
#*
#****************************************************************************/

#!/bin/bash 
CVS_CMD="/usr/bin/cvs"
SORT_CMD="/usr/bin/sort"
SED_CMD="/bin/sed"
CUT_CMD="/bin/cut"
DERSERT_EXT=".bin.jpg.png"
ITEM_PER_PAGE=20


function update_file_type ()
{
        case $1 in
                "U")
                echo "[U] Those files were brought up to date with respect to the repository."
# The file was brought up to date with respect to the repository.  This
# is  done  for  any file that exists in the repository but not in your
# working directory, and for files that you haven't changed but are not
# the most recent versions available in the repository.
                ;;
                "P")
                echo "[P] The cvs server sends patchs instead of those entire files."
# Like  U,  but the cvs server sends a patch instead of an entire file.
# This accomplishes the same thing as U using less bandwidth.
                ;;
                "A")
                echo "[A] Those files have been added to your private copy of the sources."
# The file has been added to your private copy of the sources, and will
# be  added  to  the source repository when you run commit on the file.
# This is a reminder to you that the file needs to be committed.
                ;;
                "R")
                echo "[R] Those files have been removed from your private copy of the sources."
# The file has been removed from your private copy of the sources,  and
# will be removed from the source repository when you run commit on the
# file.  This is a reminder to you that the file needs to be committed.
                ;;
                "M")
                echo "[M] Those files are modified in your working directory."
# The file is modified in  your  working  directory.

# M can indicate one of two states for a file you're working on: either
# there were no modifications to the same file in  the  repository,  so
# that  your  file  remains as you last saw it; or there were modifica-
# tions in the repository as well as in your copy, but they were merged
# successfully, without conflict, in your working directory.

# cvs  will  print  some  messages if it merges your work, and a backup
# copy of your working file (as it looked before you ran  update)  will
# be made.  The exact name of that file is printed while update runs.
                ;;
                "C")
                echo "[C] Conflicts were detected while trying to merge your changes to filewith changes from the source repository."
# A  conflict  was  detected while trying to merge your changes to file
# with changes from the source repository.   file  (the  copy  in  your
# working  directory)  is now the result of attempting to merge the two
# revisions; an unmodified copy of your file is also  in  your  working
# directory,  with the name .#file.revision where revision is the revi-
# sion that your modified file started from.  Resolve the  conflict  as
# described  in  see node `Conflicts example' in the CVS manual.  (Note
# that some systems automatically purge files that  begin  with  .#  if
# they  have not been accessed for a few days.  If you intend to keep a
# copy of your original file, it is a very good  idea  to  rename  it.)
# Under vms, the file name starts with __ rather than .#.
                ;;
                "?")
                echo "[?] Those files are in your working directory, but are not in the list of  files for cvs."
# file  is  in  your working directory, but does not correspond to any-
# thing in the source repository, and is not in the list of  files  for
# cvs  to  ignore  (see  the description of the -I option, and see node
# `cvsignore' in the CVS manual).
                ;;
        esac
}


function strstr ()
{
    if [ ${#1} -eq 0 ] || [ ${#2} -eq 0 ] || [ ${#2} -gt ${#1} ];then
        return 0
    fi
    case "$1" in
        *$2*)
            first=${1/$2*/}
            return `expr ${#first} + 1`
        ;;
        *)
            return 0
        ;;
    esac
}


function check_Y_N ()
{
    if [ -z $1 ];then
        Y_or_N="Y"
    elif [ $1 = "ALL" ];then
        Y_or_N="ALL"
    else
        Y_or_N=`expr match $Y_or_N '\(^\w\)*'`
    fi
    if [ $Y_or_N = "Y" ] || [ $Y_or_N = "y" ];then
        return 1
    elif [ $Y_or_N = "ALL" ];then
        return 99
    else
        return 0
    fi
}


function recursive_adddir ()
{
        return_value=0
        UPDATE_INFO=( $($CVS_CMD -nq update -d | $SED_CMD -n '/^?/p' | $CUT_CMD -d" " -f2))
        for element in $(seq 0 $((${#UPDATE_INFO[@]} - 1)))
        do
            if [ -d ${UPDATE_INFO[$element]} ];then
                read -p "adding directory ${UPDATE_INFO[$element]} (y/n)?" Y_or_N
                check_Y_N $Y_or_N
                if [ $? -eq 1 ];then
                    $CVS_CMD add ${UPDATE_INFO[$element]}
                    return_value=1
                else
                    echo "not adding directory" ${UPDATE_INFO[$element]}
                fi
            fi
        done
        return $return_value
}


function file_filter ()
{
            PROG=`expr match $1 '.*[/]\(.*\)'`
            extension_name=`expr match "$2" '.*\(\.\w*\)'`
            strstr $DERSERT_EXT $extension_name
            MATCH_EXT=$?
            if [ $2 = $PROG ] \
                    || [ $MATCH_EXT -gt 0 ] \
                    || [ "images/" = ${2%%/*} ]
            then
                    return 1
            else
                    return 0
            fi
}


function cvs_addfile ()
{
        UPDATE_INFO=( $($CVS_CMD -nq update -d | $SED_CMD -n '/^?/p' | $CUT_CMD -d" " -f2))
        if [ ${#UPDATE_INFO[@]} -eq 0 ];then
                exit
        fi
        for element in $(seq 0 $((${#UPDATE_INFO[@]} - 1)))
        do
            if [ -f ${UPDATE_INFO[$element]} ];then
                file_filter $0 ${UPDATE_INFO[$element]}
                if [ $? -eq 0 ];then
                    read -p "adding file ${UPDATE_INFO[$element]} (y/n/ALL)?" Y_or_N
                    check_Y_N $Y_or_N
                    Y_or_N=$?
                    if [ $Y_or_N -eq 1 ];then
                        $CVS_CMD add ${UPDATE_INFO[$element]}
                    elif [ $Y_or_N -eq 99 ];then
                        return 1
                    else
                        echo "not adding file" ${UPDATE_INFO[$element]}
                    fi
                fi
            fi
        done
        return 0
}


function cvs_add_noprompt ()
{
        UPDATE_INFO=( $($CVS_CMD -nq update -d | $SED_CMD -n '/^?/p' | $CUT_CMD -d" " -f2))
        for element in $(seq 0 $((${#UPDATE_INFO[@]} - 1)))
        do
            file_filter $0 ${UPDATE_INFO[$element]}
            if [ $? -eq 0 ];then
                echo "adding file" ${UPDATE_INFO[$element]}
            fi
        done
        read -p "adding all files on the list (y/n)?" Y_or_N
        check_Y_N $Y_or_N
        if [ $? -eq 0 ];then
                exit
        fi
        for element in $(seq 0 $((${#UPDATE_INFO[@]} - 1)))
        do
            file_filter $0 ${UPDATE_INFO[$element]}
            if [ $? -eq 0 ];then
                    $CVS_CMD add ${UPDATE_INFO[$element]}
            fi
        done
}

function cvs_faddmenu ()
{
    UPDATE_INFO=( $($CVS_CMD -nq update -d | $SED_CMD -n '/^?/p' | $CUT_CMD -d" " -f2))
    PAGE_NUM=0
    MAX_ITEM=`expr ${#UPDATE_INFO[@]} - 1`
    TEST_ADD=0
    if [ $MAX_ITEM -eq -1 ];then
            exit
    fi
    if [ `expr $MAX_ITEM % $ITEM_PER_PAGE` -eq 0 ];then
        MAX_PAGE=`expr $MAX_ITEM / $ITEM_PER_PAGE - 1`
    else
        MAX_PAGE=`expr $MAX_ITEM / $ITEM_PER_PAGE`
    fi
    START=0
    for element in $(seq 0 $MAX_ITEM)
    do
        ITEM_SELECT[$element]=0
        if [ -d ${UPDATE_INFO[$element]} ];then
            DIR_SELECT[$element]=1
            $CVS_CMD add ${UPDATE_INFO[$element]}
            TEST_ADD=1
        fi
    done
    return $TEST_ADD
}

function cvs_addmenu ()
{
    UPDATE_INFO=( $($CVS_CMD -nq update -d | $SED_CMD -n '/^?/p' | $CUT_CMD -d" " -f2))
    PAGE_NUM=0
    MAX_ITEM=`expr ${#UPDATE_INFO[@]} - 1`
    if [ $MAX_ITEM -eq -1 ];then
            exit
    fi
    if [ `expr $MAX_ITEM % $ITEM_PER_PAGE` -eq 0 ];then
        MAX_PAGE=`expr $MAX_ITEM / $ITEM_PER_PAGE - 1`
    else
        MAX_PAGE=`expr $MAX_ITEM / $ITEM_PER_PAGE`
    fi
    START=0
    for element in $(seq 0 $MAX_ITEM)
    do
        ITEM_SELECT[$element]=0
        if [ -d ${UPDATE_INFO[$element]} ];then
            DIR_SELECT[$element]=1
        else
            DIR_SELECT[$element]=0
        fi
    done
    while true;do
        clear
        echo "================= $0 (`expr $PAGE_NUM + 1`/`expr $MAX_PAGE + 1`) ================="
        START=`expr $PAGE_NUM \* $ITEM_PER_PAGE`
        END=`expr $START + $ITEM_PER_PAGE`
        if [ $START -ge $MAX_ITEM ];then
            START=0
        fi
        if [ $END -ge $MAX_ITEM ];then
            END=$MAX_ITEM
        fi
        for element in $(seq $START $END)
        do
            if [ $element -lt 10 ];then
                echo -n "          "
            elif [ $element -lt 100 ];then
                echo -n "         "
            elif [ $element -lt 1000 ];then
                echo -n "        "
            fi
            echo -n $element") "
            if [ ${ITEM_SELECT[$element]} -eq 1 ];then
                echo -n "[X] "
            else
                echo -n "[ ] "
            fi
            if [ -d ${UPDATE_INFO[$element]} ];then
                DIR_SELECT[$element]=1
                echo -n "<DIR> "
            elif [ -f ${UPDATE_INFO[$element]} ];then
                echo -n "<FILE> "
            else
                echo -n "<UNKNOW> "
            fi
            echo ${UPDATE_INFO[$element]}
        done
        echo "Previous page <p>, Next page <n>, or select the file which you want to add"
        read -p "FUNC> (p/n/#/j#/all/forceDIR/reset/inverse/page_inv/commit/quit) : " FILENUM
        case $FILENUM in
            "p")
                PAGE_NUM=`expr $PAGE_NUM - 1`
            ;;
            "n")
                PAGE_NUM=`expr $PAGE_NUM + 1`
            ;;
            "a"|"all")
                for add_item in $(seq 0 $MAX_ITEM)
                do
                    if [ ${DIR_SELECT[$add_item]} -eq 0 ] && [ ${ITEM_SELECT[$add_item]} -eq 0 ];then
                        ITEM_SELECT[$add_item]=1
                    fi
                done
            ;;
            "r"|"reset")
                for add_item in $(seq 0 $MAX_ITEM)
                do
                    if [ ${ITEM_SELECT[$add_item]} -eq 1 ];then
                        ITEM_SELECT[$add_item]=0
                    fi
                done
            ;;
           "i"|"inverse")
                for add_item in $(seq 0 $MAX_ITEM)
                do
                    if [ ${DIR_SELECT[$add_item]} -eq 0 ] && [ ${ITEM_SELECT[$add_item]} -eq 0 ];then
                        ITEM_SELECT[$add_item]=1
                    elif [ ${ITEM_SELECT[$add_item]} -eq 1 ];then
                        ITEM_SELECT[$add_item]=0
                    fi
                done
            ;;
            "j"*)
                INPUT_PAGE=`expr match $FILENUM 'j\([0-9]\+\)'`
                if [ -z $INPUT_PAGE ];then
                    INPUT_PAGE=-1
                else
                    INPUT_PAGE=`expr $INPUT_PAGE - 1`
                fi
                if [ $INPUT_PAGE -le $MAX_PAGE ] && [ $INPUT_PAGE -ge 0 ];then
                    PAGE_NUM=$INPUT_PAGE
                fi
            ;;
            "q"|"quit")
                echo "Bye..."
                exit
            ;;
            "")
            ;;
            "c"|"commit")
                commit_file=0
                for add_item in $(seq 0 $MAX_ITEM)
                do
                    if [ ${ITEM_SELECT[$add_item]} -eq 1 ];then
                        echo "add "${UPDATE_INFO[$add_item]}
                        commit_file=`expr $commit_file + 1`
                    fi
                done
                if [ $commit_file -eq 0 ];then
                        echo "NO one file is selected to add to cvs server."
                        exit
                fi
                read -p "adding all files on the list (y/n)?" Y_or_N
                check_Y_N $Y_or_N
                if [ $? -eq 1 ];then
                    for add_item in $(seq 0 $MAX_ITEM)
                    do
                        if [ ${ITEM_SELECT[$add_item]} -eq 1 ];then
                            $CVS_CMD add ${UPDATE_INFO[$add_item]}
                        fi
                    done
                    return 0
                fi
            ;;
            "f"|"forceDIR")
                while true;do
                    cvs_faddmenu
                    if [ $? -eq 0 ];then
                        break;
                    fi
                done
                return 1
            ;;
            "pi"|"page_inv")
                for page_add_item in $(seq $START $END)
                   do
                    if [ ${ITEM_SELECT[$page_add_item]} -eq 1 ];then
                        ITEM_SELECT[$page_add_item]=0
                    else
                        ITEM_SELECT[$page_add_item]=1
                    fi
                done
            ;;
            *)
                INPUT_NUM=`expr match $FILENUM '\([0-9]\+\)'`
                if [ -z $INPUT_NUM ];then
                        INPUT_NUM=-1
                fi
                if [ $INPUT_NUM -le $MAX_ITEM ] && [ $INPUT_NUM -ge 0 ];then
                    if [ ${ITEM_SELECT[$INPUT_NUM]} -eq 1 ];then
                        ITEM_SELECT[$INPUT_NUM]=0
                    else
                        if [ ${DIR_SELECT[$INPUT_NUM]} -eq 1 ];then
                            read -p "adding directory ${UPDATE_INFO[$INPUT_NUM]} (y/n)?" Y_or_N
                            check_Y_N $Y_or_N
                            if [ $? -eq 1 ];then
                            $CVS_CMD add ${UPDATE_INFO[$INPUT_NUM]}
                            fi
                            return 1
                        fi
                        ITEM_SELECT[$INPUT_NUM]=1
                    fi
                fi
            ;;
        esac
        if [ $PAGE_NUM -lt 0 ];then
            PAGE_NUM=$MAX_PAGE
        elif [ $PAGE_NUM -gt $MAX_PAGE ];then
            PAGE_NUM=0
        fi
    done
}


function remove_menu ()
{
        echo ""
}


if [ -z $1 ];then
        echo "CVS Ext. Command"
        echo "# cvs.sh update"
        echo "    Update your source tree."
        echo "# cvs.sh addmenu  [suggest]"
        echo "    Show the file menu."
        echo "# cvs.sh add"
        echo "    Prompt filename and ask if you want to add a new file into cvs."
        exit
else
        FUNCTION=$1
fi

case $FUNCTION in
    "update")
        UPDATE_INFO=( $($CVS_CMD -q update -d | $SORT_CMD))
        LAST_TYPE="-"
        for element in $(seq 0 $((${#UPDATE_INFO[@]} - 1)))
        do
                if [ `expr $element % 2` -eq 0 ];then
                    if [ ${UPDATE_INFO[$element]} != $LAST_TYPE ];then
                        if [ $element -ne 0 ];then
                            echo;echo
                        fi
                        update_file_type ${UPDATE_INFO[$element]}
                    else
                        echo
                    fi
                    LAST_TYPE=${UPDATE_INFO[$element]}
                fi
                echo -n "${UPDATE_INFO[$element]} "
        done
    ;;
    "add")
        while true;do
            recursive_adddir
            if [ $? -eq 0 ];then
                    break;
            fi
        done
        cvs_addfile
        if [ $? -eq 1 ];then
                cvs_add_noprompt
        fi
        $0 update
        echo
        read -p "commit (y/n)?" Y_or_N
        check_Y_N $Y_or_N
        Y_or_N=$?
        if [ $Y_or_N -eq 1 ];then
            echo
            $CVS_CMD commit
        else
            echo "If you want to commit your codes to CVS, type the command \"cvs commit\"."
        fi
    ;;
    "addmenu")
        while true;do
            cvs_addmenu
            if [ $? -eq 0 ];then
                    break;
            fi
            if [ $? -eq 2 ];then
                    break;
            fi
        done
        read -p "commit (y/n)?" Y_or_N
        check_Y_N $Y_or_N
        Y_or_N=$?
        if [ $Y_or_N -eq 1 ];then
            echo
            $CVS_CMD commit
        else
            echo "If you want to commit your codes to CVS, type the command \"cvs commit\"."
        fi
    ;;
    #"remove")
    #    remove_menu
    #;;
    *)
        echo "This CVS extension command, [$FUNCTION], is not supported!!"
    ;;
esac
echo
