#!/bin/bash

# LFS Reference:
# http://www.linuxfromscratch.org/lfs/view/stable/chapter05/gcc-pass1.html

set -o nounset
set -o errexit

source shared.sh
match_user "lfs" || die 'This script must be run as the "lfs" user.'

cd $LFS/sources
tar -xf gcc-4.5.2.tar.bz2 
cd gcc-4.5.2

tar -jxf ../mpfr-3.0.0.tar.bz2
mv -v mpfr-3.0.0 mpfr
tar -jxf ../gmp-5.0.1.tar.bz2
mv -v gmp-5.0.1 gmp
tar -zxf ../mpc-0.8.2.tar.gz
mv -v mpc-0.8.2 mpc

mkdir -v ../gcc-build
cd ../gcc-build

../gcc-4.5.2/configure \
    --target=$LFS_TGT --prefix=/tools \
    --disable-nls --disable-shared --disable-multilib \
    --disable-decimal-float --disable-threads \
    --disable-libmudflap --disable-libssp \
    --disable-libgomp --enable-languages=c \
    --with-gmp-include=$(pwd)/gmp --with-gmp-lib=$(pwd)/gmp/.libs \
    --without-ppl --without-cloog
make
make install

ln -vs libgcc.a `$LFS_TGT-gcc -print-libgcc-file-name | \
    sed 's/libgcc/&_eh/'`

# Cleanup
cd $LFS/sources
rm -rf gcc-4.5.2 gcc-build
