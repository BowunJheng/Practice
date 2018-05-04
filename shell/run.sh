#!/bin/sh
YYMMDD=`/bin/date '+%Y%m%d'`
WorkDir="~/LikeProject"
SrcPath=$WorkDir"/CrossCompiler"
TargetDir=$WorkDir"/gnutools_"$YYMMDD
InitDir=$WorkDir"/initrd_"$YYMMDD
Initrdfile="./initrd.img"
ToolChain=0
BuiltALL=0
RootFS=0

function decr()
{
    LogItem=`expr $LogItem - 1`
}

function updatesource()
{
    cd $SrcPath/$2
    echo "[$LogItem] update $2 via $1";decr
    case "$1" in
    "cvs")
        /usr/bin/cvs -q update -A
    ;;
    "svn")
        /usr/bin/svn update
    ;;
    "git")
        /usr/bin/git pull
    ;;
    *)
    ;;
    esac
    cd ../..
    echo "[$LogItem] copy $2 to the current directory";decr
    /bin/cp -R $SrcPath/$2 .
}

function ResetCrossDIR()
{
    LogItem=1
    echo "[$LogItem] remove & create gnutools directory";decr
    /bin/rm -rf $WorkDir/gnutools_* $WorkDir/gnutools
    /bin/mkdir $TargetDir
    /bin/ln -s $TargetDir $WorkDir/gnutools
}

function BulidBinutil()
{
    LogItem=5
    updatesource cvs binutil
    cd ./binutil
    echo "[$LogItem] configure binutil";decr
    ./configure --prefix=$TargetDir --target=mipsisa32-elf
    echo "[$LogItem] build & install binutil";decr
    /usr/bin/make all install
    cd ..
    echo "[$LogItem] remove binutil";decr
    /bin/rm -rf ./binutil
}

function BulidGccNewlib()
{
    LogItem=8
    updatesource svn gcc
    updatesource cvs newlib
    echo "[$LogItem] copy newlib to the gcc directory";decr
    /bin/cp -R ./newlib/newlib ./newlib/libgloss gcc
    #/bin/cp CrossCompiler/configure.patch gcc
    #echo "[$LogItem] patch configure file";decr
    #/usr/bin/patch -p0 < gcc/configure.patch
    /bin/mkdir gcc/objdir 
    cd ./gcc/objdir
    echo "[$LogItem] configure gcc";decr
    ../configure --prefix=$TargetDir --target=mipsisa32-elf --enable-languages=c,c++ --with-newlib --with-gnu-as --with-gnu-ld --with-gxx-include-dir=$TargetDir/mipsisa32-elf/include
    echo "[$LogItem] build & install gcc";decr
    /usr/bin/make all install
    cd ../..
    echo "[$LogItem] remove gcc";decr
    /bin/rm -rf ./gcc ./newlib
}

function BulidGdb()
{
    LogItem=5
    updatesource cvs gdb
    cd ./gdb
    echo "[$LogItem] configure gdb";decr
    ./configure --prefix=$TargetDir --target=mipsisa32-elf
    echo "[$LogItem] build & install gdb";decr
    /usr/bin/make all install
    cd ..
    echo "[$LogItem] remove gdb";decr
    /bin/rm -rf ./gdb
}

function BuilduClibc()
{
    LogItem=5
    updatesource git uClibc
    /bin/cp $SrcPath/Rules.mak.patch uClibc
    echo "[$LogItem] patch configure file";decr
    /usr/bin/patch -p0 < uClibc/Rules.mak.patch
    cd uClibc
    export PATH=$WorkDir/gnutools/bin:$PATH
    echo "[$LogItem] build & install uClibc";decr
    # arch=mips, lib=no shared,no large file,linuxthread cross=mipsisa32-elf-
    # -I~/LikeProject/gnutools/mipsisa32-elf/include
    # -nostdinc -L~/LikeProject/gnutools/mipsisa32-elf/lib
    /usr/bin/make CFLAG=-nostdinc CROSS=mipsisa32-elf- menuconfig
    /usr/bin/make CFLAG=-nostdinc CROSS=mipsisa32-elf- PREFIX=$TargetDir all install
    cd ..
    echo "[$LogItem] remove busybox";decr
    #/bin/rm -rf uClibc
}

function ResetInitrd()
{
    LogItem=1
    echo "[$LogItem] mount/create initrd directory";decr
    /bin/rm -rf $WorkDir/initrd_* $WorkDir/initrd
    /bin/mkdir $InitDir
    /bin/ln -s $InitDir $WorkDir/initrd
    if [ -e $Initrdfile ] ; then
        /bin/mount -o loop $Initrdfile $WorkDir/initrd
    else
        /bin/dd if=/dev/zero of=$Initrdfile bs=1k count=8192 
        /sbin/mke2fs -F -v -m0 $Initrdfile
        /bin/mount -o loop $Initrdfile $WorkDir/initrd
        cd initrd
        /bin/mkdir dev proc etc sbin bin lib mnt tmp var usr root
        /bin/chmod 755 dev etc sbin bin lib mnt var usr root
        /bin/chmod 555 proc
        /bin/chmod 1777 tmp
        cd dev
        /bin/mknod -m 600 console c 5 1
        /bin/mknod -m 600 ram0 b 1 0 
        /bin/mknod -m 666 tty c 5 0
        /bin/mknod -m 666 tty0 c 4 0 
        /bin/mknod -m 666 tty1 c 4 0 
        /bin/mknod -m 666 tty2 c 4 0 
        /bin/mknod -m 666 null c 1 3
        cd ..
        /bin/cp -R ../CrossCompiler/busybox/examples/bootfloppy/etc/* etc/
        cd ..
    fi
}

function BuildBusyBox()
{
    LogItem=4
    cd CrossCompiler/busybox
    echo "[$LogItem] update busybox via git";decr
    /usr/bin/git pull
    cd ../..
    echo "[$LogItem] copy busybox to the current working directory";decr
    /bin/cp -R CrossCompiler/busybox .
    cd busybox
    export PATH=$WorkDir/gnutools/bin:$PATH
    export CFLAGS=""
    export CXXFLAGS=""

    echo $PATH
    echo "[$LogItem] build & install busybox";decr
    /usr/bin/make CONFIG_STATIC=y ARCH=mipsisa32 CROSS_COMPILE=mipsisa32-elf- menuconfig 
    /usr/bin/make CONFIG_STATIC=y ARCH=mipsisa32 CROSS_COMPILE=mipsisa32-elf- all
    cd ..
    echo "[$LogItem] remove busybox";decr
    #/bin/rm -rf busybox
}

function BuildToolChain()
{
    unset CFLAGS
    unset CXXFLAGS
    export PATH=/usr/lib/perl5/core_perl/bin:$WorkDir/gnutools/bin:$PATH
    ResetCrossDIR
    BulidBinutil
    BulidGccNewlib
    BulidGdb
}

#function BuildInitrd()
#{
    #ResetInitrd
    #BuildBusyBox
    #/bin/umount $WorkDir/initrd
    #/bin/rm -rf $WorkDir/initrd_* $WorkDir/initrd
#}
#----------------------------------------

for parm in "$@" ; do
    if [ "${parm}" == "all" ] ; then
        BuiltALL=1
        break
    elif [ "${parm}" == "toolchain" ] ; then
        ToolChain=1
    elif [ "${parm}" == "rootfs" ] ; then
        RootFS=1
    fi
done

if [ "${BuiltALL}" == "1" ] ; then
    BuildToolChain
else
    if [ "${ToolChain}" == "1" ] ; then
        BuildToolChain
    fi
    if [ "${RootFS}" == "1" ] ; then
        BuildInitrd
    fi
fi
#BuilduClibc
