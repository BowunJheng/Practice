#!/bin/sh
/bin/umount /home/strongarm/armroot
/bin/rm -rf /home/strongarm
/bin/mkdir /home/strongarm
/bin/mkdir /home/strongarm/armroot
/bin/mount -o loop ./arm-initrd /home/strongarm/armroot
/bin/mkdir /home/strongarm/root
/bin/mkdir /home/strongarm/root/boot
/bin/mkdir /home/strongarm/blob
/bin/rm -rf /usr/local/root/binutil /usr/local/root/gcc /usr/local/root/newlib
/bin/rm -rf /usr/local/root/ccache /usr/local/root/linux-2.6.17.6 
/bin/rm -rf /usr/local/root/sstrip


#---------binutil
cd src/binutil
/usr/bin/cvs update
cd
/bin/cp -R src/binutil .
cd binutil
./configure --prefix=/home/strongarm --target=strongarm-linux-elf
/usr/bin/make all install
cd

#---------gcc
cd src/gcc
/usr/bin/svn update
cd
cd src/newlib
/usr/bin/cvs update
cd
/bin/cp -R src/gcc src/newlib .
cd gcc
/bin/ln -s ../newlib/newlib ../newlib/libgloss ../newlib/COPYING.NEWLIB .
./configure --prefix=/home/strongarm --target=strongarm-linux-elf --enable-languages=c,c++ --disable-shared --disable-threads --with-newlib
/usr/bin/make all install
cd

#---------other tools
cd src/buildroot/toolchain/sstrip
/usr/bin/svn update
cd
/bin/cp -R src/buildroot/toolchain/sstrip .
cd sstrip
/usr/bin/gcc -O2 -g -o sstrip sstrip.c
/bin/cp sstrip /home/strongarm/bin
cd
cd src/ccache
/usr/bin/cvs update
cd
/bin/cp -R src/ccache .
cd ccache
./configure --prefix=/home/strongarm
/usr/bin/make all install
cd

#---------linux kernel
cd src/
/bin/tar zxf linux-2.6.17.6.tar.gz
/bin/mv linux-2.6.17.6 ..
cd
/usr/bin/patch -p0 < binfmt_aout.patch
cd linux-2.6.17.6
/usr/bin/make ARCH=arm CROSS_COMPILE=/home/strongarm/bin/strongarm-linux-elf- neponset_defconfig
/usr/bin/make ARCH=arm CROSS_COMPILE=/home/strongarm/bin/strongarm-linux-elf- all
/usr/bin/make ARCH=arm CROSS_COMPILE=/home/strongarm/bin/strongarm-linux-elf- modules_install INSTALL_MOD_PATH=/home/strongarm/root
/bin/cp System.map /home/strongarm/root/boot
/bin/cat arch/arm/boot/zImage > /home/strongarm/root/boot/vmlinux
cd

#---------initrd
#/bin/dd if=/dev/zero of=arm-initrd bs=1024 count=4096
#/sbin/mkfs.ext3 -F arm-initrd
#/bin/mount -o loop arm-initrd /home/strongarm/armroot
/bin/mkdir /home/strongarm/armroot/bin /home/strongarm/armroot/dev /home/strongarm/armroot/etc /home/strongarm/armroot/lib /home/strongarm/armroot/new_root /home/strongarm/armroot/proc /home/strongarm/armroot/sbin /home/strongarm/armroot/sys
MO=`/usr/bin/find /home/strongarm/root/lib -type f|/bin/sed "/modules\./d"`
for modules in $MO
do
	/bin/cp $modules /home/strongarm/armroot/lib
done
/bin/echo "none	none	none	defaults	0	0" > /home/strongarm/armroot/etc/fstab

#---------busybox
#cd src/busybox
#/usr/bin/svn update
#cd
#/bin/cp -R src/busybox .
#cd busybox
#make TARGET_ARCH=arm CROSS_COMPILE=/home/strongarm/bin/strongarm-linux-elf- PREFIX=/home/strongarm/armroot defconfig all install 
#cd


#---------blob
#cd src/blob
#/usr/bin/cvs update
#cd
#/bin/cp -R src/blob .
#cd blob
#/bin/echo "AC_CONFIG_HEADERS(config.h)" >> configure.in
#/usr/bin/autoheader
#/usr/bin/aclocal
#/usr/bin/autoconf
#/bin/touch tools/install-sh tools/missing tools/config.guess tools/config.sub ./INSTALL include/blob/config.h.in tools/depcomp tools/compile
#/usr/bin/automake
#export CC=/home/strongarm/bin/strongarm-linux-elf-gcc 
#export OBJCOPY=/home/strongarm/bin/strongarm-linux-elf-objcopy
#./configure --prefix=/home/strongarm/blob --with-board=neponset
#/usr/bin/make all install
#cd

