; ------------------------------------------
; PackFire
; ------------------------------------------

                        opt     a+
                        include "depacker_constants.inc"

                        org     0

Ptrs:                   dc.l    Code-Start+2+(7*4)
                        dc.l    0                               ; phony
                        dc.l    Max_Size-Start+2+(7*4)          ; depacked length to clear
                        dc.l    Size_To_Depack-Start+2+(7*4)    ; depacked length
                        dc.l    Dest-Start+2+(7*4)              ; absolute address
                        dc.l    Relocate-Start+(7*4)            ; Jump to relocate routine (or not)
                        dc.l    Entry_Point-Start+2+(7*4)       ; X68000 only entry point offset
Start:
                        include "supervisor.asm"
                        lea     Var(pc),a5
                        lea     Data-Var(a5),a0                 ; start of data
Code:                   move.l  #0,d5                           ; starting code
Dest:                   lea     0,a4
                        lea     (a4),a1                         ; clear the whole dest
Max_Size:               move.l  #0,d0
Clear_Dest:             sf.b    (a1)+
                        subq.l  #1,d0
                        bgt.b   Clear_Dest
                        lea     (a1),a6                         ; probs after depacked data
                        move.w  #PROBSLEN-1,d7
Fill_Probs:             move.w  #KBITMODELTOTAL>>1,(a1)+
                        dbf     d7,Fill_Probs
                        include "depacker_common.asm"
