; ------------------------------------------
; PackFire
; ------------------------------------------

; Atari ST stuff
VID_COLOR_0             =       $FFFF8240

; X68000 stuff
SPR_PAL0_DTA            =       $E82200
MFP_IERA                =       $E88007
_SUPER		            =       $FF20

_SYS_STAT               equ     $AC

TRAP_IOSCALL            equ     15

MPU_TYPE                equ     $CBC

DOS                     MACRO
                        dc.w	\1
                        ENDM

IOCS                    MACRO
                        IFNE    \1<$80
                            moveq   #\1,d0
                        ELSE
                            moveq   #-($100-\1),d0
                        ENDC
                        trap    #TRAP_IOSCALL
                        ENDM

                        include "lzma_constants.inc"
