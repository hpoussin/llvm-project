#!/usr/bin/env bash

ARCH=$1
ARCH=${ARCH:-mipsel}
TRIPLE=$ARCH-windows-msvc
if [ $ARCH = 'mipsel' ]; then
  CFLAGS="-mcpu=mips3 -Xclang -target-feature -Xclang -gp64"
fi

set -xe # enable command dump and exit if error

../build/bin/clang --target=$TRIPLE $CFLAGS -emit-llvm -S standalone.c -o standalone-$ARCH.ll -g
../build/bin/clang --target=$TRIPLE $CFLAGS -emit-llvm -S kernel32.c -o kernel32-$ARCH.ll -g
../build/bin/llc -mtriple=$TRIPLE standalone-$ARCH.ll -o standalone-$ARCH.obj --filetype=obj
../build/bin/llc -mtriple=$TRIPLE kernel32-$ARCH.ll -o kernel32-$ARCH.obj --filetype=obj
../build/bin/llvm-lib kernel32-$ARCH.obj /def:kernel32.def /out:kernel32-$ARCH.lib /machine:$ARCH
../build/bin/lld-link standalone-$ARCH.obj kernel32-$ARCH.lib /out:standalone-$ARCH.exe /subsystem:console,4 /pdb:standalone-$ARCH.pdb /debug
