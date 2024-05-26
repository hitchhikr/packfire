@echo off
echo Assembling 'depacker.bin'...
vasmm68k.exe -no-opt -quiet -Fbin -DRESTORE_USER_LEVEL=1 -o depacker.bin depacker.asm
if errorlevel 1 goto error
echo Assembling 'depacker_no_user.bin'...
vasmm68k.exe -no-opt -quiet -Fbin -DRESTORE_USER_LEVEL=0 -o depacker_no_user.bin depacker.asm
if errorlevel 1 goto error
echo Assembling 'depacker_absolute.bin'...
vasmm68k.exe -no-opt -quiet -Fbin -DRESTORE_USER_LEVEL=1 -o depacker_absolute.bin depacker_absolute.asm
if errorlevel 1 goto error
echo Assembling 'depacker_absolute_no_user.bin'...
vasmm68k.exe -no-opt -quiet -Fbin -DRESTORE_USER_LEVEL=0 -o depacker_absolute_no_user.bin depacker_absolute.asm
if errorlevel 1 goto error

echo Assembling 'relocator.bin'...
vasmm68k.exe -no-opt -quiet -Fbin -o relocator.bin relocator.asm
if errorlevel 1 goto error

echo Converting 'depacker.bin' to 'depacker.h'...
bin2c depacker.bin depacker.h depacker
if errorlevel 1 goto error
echo Converting 'depacker_no_user.bin' to 'depacker_no_user.h'...
bin2c depacker_no_user.bin depacker_no_user.h depacker_no_user
if errorlevel 1 goto error
echo Converting 'depacker_absolute.bin' to 'depacker_absolute.h'...
bin2c depacker_absolute.bin depacker_absolute.h depacker_absolute
if errorlevel 1 goto error
echo Converting 'depacker_absolute_no_user.bin' to 'depacker_absolute_no_user.h'...
bin2c depacker_absolute_no_user.bin depacker_absolute_no_user.h depacker_absolute_no_user
if errorlevel 1 goto error

echo Converting 'relocator.bin' to 'relocator.h'...
bin2c relocator.bin relocator.h relocator
if errorlevel 1 goto error

echo Deleting intermediary files...
del depacker.bin
del depacker_no_user.bin
del depacker_absolute.bin
del depacker_absolute_no_user.bin
del relocator.bin
echo Done.
:error
