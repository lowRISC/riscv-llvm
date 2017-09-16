#!/bin/sh

# This is a simple script that can compile and link a file for RV32, using the
# GNU linker, newlib, and libgcc. It's not pleasant, but fiddling with a shell
# script is easier than modifying the Clang driver when experimenting.

if [ ! -d "$RV" ]; then
  printf 'Must set $RV to path where RISC-V gcc is installed\n'
  exit 1
fi

GCC_VER=${GCC_VER:-7.1.1}

RVLIB=$RV/riscv32-unknown-elf/lib
RVSYSINC=$RV/riscv32-unknown-elf/sys-include
RVINC=$RV/riscv32-unknown-elf/include
RVGCCLIB=$RV/lib/gcc/riscv32-unknown-elf/$GCC_VER
RVGCCINC=$RVGCCLIB/include
RVGCCINC2=$RVGCCLIB/include-fixed

CLANG=/local/scratch/asb58/new-riscv-llvm/build/bin/clang

BASEFILE="${1%.*}"

$CLANG -target riscv32 \
  -Wl,-T$RVLIB/ldscripts/elf32lriscv.x \
  -nostdinc -I$RVGCCINC -I$RVGCCINC2 -I$RVSYSINC -I$RVINC \
  $RVLIB/crt0.o $RVGCCLIB/crtbegin.o -Wl,-L$RVGCCLIB -Wl,-L$RVLIB \
  $1 \
  -lgcc -Wl,--start-group -lc -lgloss -Wl,--end-group -lgcc $RVGCCLIB/crtend.o -o output/$BASEFILE $2

