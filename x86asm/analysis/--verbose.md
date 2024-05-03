## [s@Showlight analysis]$ gcc if.c -o if.out --verbose
Using built-in specs.
COLLECT_GCC=gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/lto-wrapper
Target: x86_64-pc-linux-gnu
Configured with: /build/gcc/src/gcc/configure --enable-languages=ada,c,c++,d,fortran,go,lto,m2,objc,obj-c++ --enable-bootstrap --prefix=/usr --libdir=/usr/lib --libexecdir=/usr/lib --mandir=/usr/share/man --infodir=/usr/share/info --with-bugurl=https://bugs.archlinux.org/ --with-build-config=bootstrap-lto --with-linker-hash-style=gnu --with-system-zlib --enable-__cxa_atexit --enable-cet=auto --enable-checking=release --enable-clocale=gnu --enable-default-pie --enable-default-ssp --enable-gnu-indirect-function --enable-gnu-unique-object --enable-libstdcxx-backtrace --enable-link-serialization=1 --enable-linker-build-id --enable-lto --enable-multilib --enable-plugin --enable-shared --enable-threads=posix --disable-libssp --disable-libstdcxx-pch --disable-werror
Thread model: posix
Supported LTO compression algorithms: zlib zstd
gcc version 13.2.1 20230801 (GCC) 
COLLECT_GCC_OPTIONS='-o' 'if.out' '-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'if.out-'
 /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/cc1 -quiet -v if.c -quiet -dumpdir if.out- -dumpbase if.c -dumpbase-ext .c -mtune=generic -march=x86-64 -version -o /tmp/ccl7TRg3.s
GNU C17 (GCC) version 13.2.1 20230801 (x86_64-pc-linux-gnu)
        compiled by GNU C version 13.2.1 20230801, GMP version 6.3.0, MPFR version 4.2.1, MPC version 1.3.1, isl version isl-0.26-GMP

GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
ignoring nonexistent directory "/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/../../../../x86_64-pc-linux-gnu/include"
#include "..." search starts here:
#include <...> search starts here:
 /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/include
 /usr/local/include
 /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/include-fixed
 /usr/include
End of search list.
Compiler executable checksum: eb0b45108af02c02a078961940bce3e9
COLLECT_GCC_OPTIONS='-o' 'if.out' '-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'if.out-'
 as -v --64 -o /tmp/ccIhNkiL.o /tmp/ccl7TRg3.s
GNU assembler version 2.42.0 (x86_64-pc-linux-gnu) using BFD version (GNU Binutils) 2.42.0
COMPILER_PATH=/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/:/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/:/usr/lib/gcc/x86_64-pc-linux-gnu/:/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/:/usr/lib/gcc/x86_64-pc-linux-gnu/
LIBRARY_PATH=/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/:/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/../../../../lib/:/lib/../lib/:/usr/lib/../lib/:/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/../../../:/lib/:/usr/lib/
COLLECT_GCC_OPTIONS='-o' 'if.out' '-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'if.out.'
 /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/collect2 -plugin /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/liblto_plugin.so -plugin-opt=/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/lto-wrapper -plugin-opt=-fresolution=/tmp/cc5QDUom.res -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_s -plugin-opt=-pass-through=-lc -plugin-opt=-pass-through=-lgcc -plugin-opt=-pass-through=-lgcc_s --build-id --eh-frame-hdr --hash-style=gnu -m elf_x86_64 -dynamic-linker /lib64/ld-linux-x86-64.so.2 -pie -o if.out /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/../../../../lib/Scrt1.o /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/../../../../lib/crti.o /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/crtbeginS.o -L/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1 -L/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/../../../../lib -L/lib/../lib -L/usr/lib/../lib -L/usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/../../.. /tmp/ccIhNkiL.o -lgcc --push-state --as-needed -lgcc_s --pop-state -lc -lgcc --push-state --as-needed -lgcc_s --pop-state /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/crtendS.o /usr/lib/gcc/x86_64-pc-linux-gnu/13.2.1/../../../../lib/crtn.o
COLLECT_GCC_OPTIONS='-o' 'if.out' '-v' '-mtune=generic' '-march=x86-64' '-dumpdir' 'if.out.'
[s@Showlight analysis]$ 