@echo off
echo -----------------------------------------------------
echo Assembling depackers for ATARI...
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DATARI -DRESTORE_USER_LEVEL -o 68000\depacker.bin 68000\depacker.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DATARI -o 68000\depacker_no_user.bin 68000\depacker.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DATARI -DRESTORE_USER_LEVEL -o 68000\depacker_absolute.bin 68000\depacker_absolute.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DATARI -o 68000\depacker_absolute_no_user.bin 68000\depacker_absolute.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DATARI -o 68000\relocator.bin 68000\relocator.asm
if errorlevel 1 goto error
echo Converting depackers for ATARI...
bin2c 68000\depacker.bin 68000\atari\depacker_ATARI.h depacker
if errorlevel 1 goto error
bin2c 68000\depacker_no_user.bin 68000\atari\depacker_no_user_ATARI.h depacker_no_user
if errorlevel 1 goto error
bin2c 68000\depacker_absolute.bin 68000\atari\depacker_absolute_ATARI.h depacker_absolute
if errorlevel 1 goto error
bin2c 68000\depacker_absolute_no_user.bin 68000\atari\depacker_absolute_no_user_ATARI.h depacker_absolute_no_user
if errorlevel 1 goto error
bin2c 68000\relocator.bin 68000\atari\relocator_ATARI.h relocator
if errorlevel 1 goto error
echo -----------------------------------------------------
echo Assembling depackers for X68000...
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DX68000 -DRESTORE_USER_LEVEL -o 68000\depacker.bin 68000\depacker.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DX68000 -o 68000\depacker_no_user.bin 68000\depacker.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DX68000 -DRESTORE_USER_LEVEL -o 68000\depacker_absolute.bin 68000\depacker_absolute.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DX68000 -o 68000\depacker_absolute_no_user.bin 68000\depacker_absolute.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DX68000 -o 68000\relocator.bin 68000\relocator.asm
if errorlevel 1 goto error
vasmm68k.exe -no-opt -quiet -Fbin -I 68000 -DX68000 -o 68000\entry_point.bin 68000\entry_point.asm
if errorlevel 1 goto error
echo Converting depackers for X68000...
bin2c 68000\depacker.bin 68000\x68000\depacker_X68000.h depacker
if errorlevel 1 goto error
bin2c 68000\depacker_no_user.bin 68000\x68000\depacker_no_user_X68000.h depacker_no_user
if errorlevel 1 goto error
bin2c 68000\depacker_absolute.bin 68000\x68000\depacker_absolute_X68000.h depacker_absolute
if errorlevel 1 goto error
bin2c 68000\depacker_absolute_no_user.bin 68000\x68000\depacker_absolute_no_user_X68000.h depacker_absolute_no_user
if errorlevel 1 goto error
bin2c 68000\relocator.bin 68000\x68000\relocator_X68000.h relocator
if errorlevel 1 goto error
bin2c 68000\entry_point.bin 68000\x68000\entry_point_X68000.h entry_point
if errorlevel 1 goto error
echo -----------------------------------------------------
echo Assembling depacker for Nintendo DS...
arm-none-eabi-as -I arm -o arm\depacker.elf arm\depacker.asm
if errorlevel 1 goto error
arm-none-eabi-strip --output-target=binary -o arm\depacker.bin arm\depacker.elf
if errorlevel 1 goto error
echo Converting depacker for Nintendo DS...
bin2c arm\depacker.bin arm\nds\depacker_NDS.h depacker
if errorlevel 1 goto error
echo -----------------------------------------------------
echo Deleting intermediary files...
del arm\depacker.elf
del arm\depacker.bin
del 68000\depacker.bin
del 68000\depacker_no_user.bin
del 68000\depacker_absolute.bin
del 68000\depacker_absolute_no_user.bin
del 68000\relocator.bin
del 68000\entry_point.bin
echo Done.
:error
