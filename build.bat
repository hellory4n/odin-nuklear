@echo off

odin-bindgen .

where cl >nul 2>nul
if %errorlevel% equ 0 (    
    cl /c /Z7 /DDEBUG nuklear.c
    lib /OUT:nuklear_windows_amd64_debug.lib nuklear.obj
    del nuklear.obj

    cl /c /O2 nuklear.c
    lib /OUT:nuklear_windows_amd64_release.lib nuklear.obj
    del nuklear.obj
)

where emcc >nul 2>nul
if %errorlevel% equ 0 (
    call emcc -c -g -DDEBUG nuklear.c -o nukler_wasm_debug.o
    call emcc -c -O2 nuklear.c -o nukler_wasm_release.o
)

:eof
