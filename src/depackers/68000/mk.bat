@echo off
echo -----------------------------------------------------
echo Assembling depackers for ATARI...
vasmm68k.exe -no-opt -quiet -Fbin -DATARI -DRESTORE_USER_LEVEL -o depacker.bin depacker.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DATARI -o depacker_no_user.bin depacker.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DATARI -DRESTORE_USER_LEVEL -o depacker_absolute.bin depacker_absolute.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DATARI -o depacker_absolute_no_user.bin depacker_absolute.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DATARI -o relocator.bin relocator.asm
if errorlevel 1 goto error
echo Converting depackers for ATARI...
bin2c depacker.bin atari\depacker_ATARI.h depacker
if errorlevel 1 goto error
bin2c depacker_no_user.bin atari\depacker_no_user_ATARI.h depacker_no_user
if errorlevel 1 goto error
bin2c depacker_absolute.bin atari\depacker_absolute_ATARI.h depacker_absolute
if errorlevel 1 goto error
bin2c depacker_absolute_no_user.bin atari\depacker_absolute_no_user_ATARI.h depacker_absolute_no_user
if errorlevel 1 goto error
bin2c relocator.bin atari\relocator_ATARI.h relocator
if errorlevel 1 goto error
echo -----------------------------------------------------
echo Assembling depackers for X68000...
vasmm68k.exe -no-opt -quiet -Fbin -DX68000 -DRESTORE_USER_LEVEL -o depacker.bin depacker.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DX68000 -o depacker_no_user.bin depacker.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DX68000 -DRESTORE_USER_LEVEL -o depacker_absolute.bin depacker_absolute.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DX68000 -o depacker_absolute_no_user.bin depacker_absolute.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DX68000 -o relocator.bin relocator.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -DX68000 -o entry_point.bin entry_point.asm
if errorlevel 1 goto error
echo Converting depackers for X68000...
bin2c depacker.bin x68000\depacker_X68000.h depacker
if errorlevel 1 goto error
bin2c depacker_no_user.bin x68000\depacker_no_user_X68000.h depacker_no_user
if errorlevel 1 goto error
bin2c depacker_absolute.bin x68000\depacker_absolute_X68000.h depacker_absolute
if errorlevel 1 goto error
bin2c depacker_absolute_no_user.bin x68000\depacker_absolute_no_user_X68000.h depacker_absolute_no_user
if errorlevel 1 goto error
bin2c relocator.bin x68000\relocator_X68000.h relocator
if errorlevel 1 goto error
bin2c entry_point.bin x68000\entry_point_X68000.h entry_point
if errorlevel 1 goto error
echo -----------------------------------------------------
echo Deleting intermediary files...
del depacker.bin
del depacker_no_user.bin
del depacker_absolute.bin
del depacker_absolute_no_user.bin
del relocator.bin
del entry_point.bin
echo Done.
:error
