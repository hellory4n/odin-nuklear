#!/bin/sh
odin-c-bindgen .

# release
gcc -c -Wall -Wextra -O2 -fPIC nuklear.c -o nuklear.o
ar rcs libnuklear_linux_amd64_release.a nuklear.o

# debug
gcc -c -Wall -Wextra -g -O0 -fPIC nuklear.c -o nuklear.o
ar rcs libnuklear_linux_amd64_debug.a nuklear.o
