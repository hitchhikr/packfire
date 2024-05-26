# Microsoft Developer Studio Project File - Name="packfire" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=packfire - Win32 Release
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "packfire.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "packfire.mak" CFG="packfire - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "packfire - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "packfire - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
RSC=rc.exe

!IF  "$(CFG)" == "packfire - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GX /O2 /I ".\\" /D "NDEBUG" /D "_MBCS" /D "WIN32" /D "_CONSOLE" /FR /FD /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE RSC /l 0x419 /d "NDEBUG"
# ADD RSC /l 0x419 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib user32.lib shlwapi.lib /nologo /subsystem:console /machine:I386 /out:"..\packfire.exe" /opt:NOWIN98
# SUBTRACT LINK32 /pdb:none

!ELSEIF  "$(CFG)" == "packfire - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_CONSOLE" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /W3 /Gm /GX /ZI /Od /I ".\\" /D "_DEBUG" /D "_MBCS" /D "WIN32" /D "_CONSOLE" /FR /FD /GZ /c
# SUBTRACT CPP /YX /Yc /Yu
# ADD BASE RSC /l 0x419 /d "_DEBUG"
# ADD RSC /l 0x419 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib shlwapi.lib /nologo /subsystem:console /debug /machine:I386 /out:"..\packfire.exe" /pdbtype:sept

!ENDIF 

# Begin Target

# Name "packfire - Win32 Release"
# Name "packfire - Win32 Debug"
# Begin Group "Compress"

# PROP Default_Filter ""
# Begin Group "LZMA"

# PROP Default_Filter ""
# Begin Source File

SOURCE=7zip\Compress\LZMA\LZMA.h
# End Source File
# Begin Source File

SOURCE=7zip\Compress\LZMA\LZMAEncoder.cpp
# End Source File
# Begin Source File

SOURCE=7zip\Compress\LZMA\LZMAEncoder.h
# End Source File
# End Group
# Begin Group "RangeCoder"

# PROP Default_Filter ""
# Begin Source File

SOURCE=7zip\Compress\RangeCoder\RangeCoder.h
# End Source File
# Begin Source File

SOURCE=7zip\Compress\RangeCoder\RangeCoderBit.cpp
# End Source File
# Begin Source File

SOURCE=7zip\Compress\RangeCoder\RangeCoderBit.h
# End Source File
# Begin Source File

SOURCE=7zip\Compress\RangeCoder\RangeCoderBitTree.h
# End Source File
# Begin Source File

SOURCE=7zip\Compress\RangeCoder\RangeCoderOpt.h
# End Source File
# End Group
# Begin Group "LZ"

# PROP Default_Filter ""
# Begin Group "Pat"

# PROP Default_Filter ""
# Begin Source File

SOURCE=7zip\Compress\LZ\Patricia\Pat.h
# End Source File
# Begin Source File

SOURCE=7zip\Compress\LZ\Patricia\Pat4H.h
# End Source File
# Begin Source File

SOURCE=7zip\Compress\LZ\Patricia\PatMain.h
# End Source File
# End Group
# Begin Source File

SOURCE=7zip\Compress\LZ\IMatchFinder.h
# End Source File
# Begin Source File

SOURCE=7zip\Compress\LZ\LZInWindow.cpp
# End Source File
# Begin Source File

SOURCE=7zip\Compress\LZ\LZInWindow.h
# End Source File
# End Group
# End Group
# Begin Group "Windows"

# PROP Default_Filter ""
# Begin Source File

SOURCE=Windows\FileIO.cpp
# End Source File
# Begin Source File

SOURCE=Windows\FileIO.h
# End Source File
# End Group
# Begin Group "Common"

# PROP Default_Filter ""
# Begin Source File

SOURCE=Common\Alloc.cpp
# End Source File
# Begin Source File

SOURCE=Common\Alloc.h
# End Source File
# Begin Source File

SOURCE=Common\CRC.cpp
# End Source File
# Begin Source File

SOURCE=Common\CRC.h
# End Source File
# Begin Source File

SOURCE=Common\Defs.h
# End Source File
# Begin Source File

SOURCE=Windows\Defs.h
# End Source File
# Begin Source File

SOURCE=Common\MyCom.h
# End Source File
# Begin Source File

SOURCE=Common\MyWindows.h
# End Source File
# Begin Source File

SOURCE=Common\NewHandler.cpp
# End Source File
# Begin Source File

SOURCE=Common\NewHandler.h
# End Source File
# Begin Source File

SOURCE=Common\String.cpp
# End Source File
# Begin Source File

SOURCE=Common\String.h
# End Source File
# Begin Source File

SOURCE=Common\StringConvert.cpp
# End Source File
# Begin Source File

SOURCE=Common\StringConvert.h
# End Source File
# Begin Source File

SOURCE=Common\StringToInt.cpp
# End Source File
# Begin Source File

SOURCE=Common\StringToInt.h
# End Source File
# Begin Source File

SOURCE=Common\Types.h
# End Source File
# Begin Source File

SOURCE=Common\Vector.cpp
# End Source File
# Begin Source File

SOURCE=Common\Vector.h
# End Source File
# End Group
# Begin Group "7zip Common"

# PROP Default_Filter ""
# Begin Source File

SOURCE=7zip\Common\FileStreams.cpp
# End Source File
# Begin Source File

SOURCE=7zip\Common\FileStreams.h
# End Source File
# Begin Source File

SOURCE=7zip\ICoder.h
# End Source File
# Begin Source File

SOURCE=7zip\Common\InBuffer.cpp
# End Source File
# Begin Source File

SOURCE=7zip\Common\InBuffer.h
# End Source File
# Begin Source File

SOURCE=.\7zip\IStream.h
# End Source File
# Begin Source File

SOURCE=7zip\Common\OutBuffer.cpp
# End Source File
# Begin Source File

SOURCE=7zip\Common\OutBuffer.h
# End Source File
# End Group
# Begin Group "Depackers"

# PROP Default_Filter ""
# Begin Group "Depackers ATARI"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\depackers\68000\atari\depacker_absolute_ATARI.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\atari\depacker_absolute_no_user_ATARI.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\atari\depacker_ATARI.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\atari\depacker_no_user_ATARI.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\atari\relocator_ATARI.h
# End Source File
# End Group
# Begin Group "Depackers X68000"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\depackers\68000\x68000\depacker_absolute_no_user_X68000.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\x68000\depacker_absolute_X68000.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\x68000\depacker_no_user_X68000.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\x68000\depacker_X68000.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\x68000\entry_point_X68000.h
# End Source File
# Begin Source File

SOURCE=.\depackers\68000\x68000\relocator_X68000.h
# End Source File
# End Group
# End Group
# Begin Group "Loaders"

# PROP Default_Filter ""
# Begin Group "Loader ATARI"

# PROP Default_Filter ""
# Begin Source File

SOURCE=loaders\Atari\atari.cpp
# End Source File
# Begin Source File

SOURCE=loaders\Atari\atari.h
# End Source File
# End Group
# Begin Group "Loader X68000"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\loaders\x68000\x68000.cpp
# End Source File
# Begin Source File

SOURCE=.\loaders\x68000\x68000.h
# End Source File
# End Group
# Begin Source File

SOURCE=loaders\loaders.h
# End Source File
# End Group
# Begin Source File

SOURCE=main.cpp
# End Source File
# End Target
# End Project
