; ------------------------------------------
; PackFire
; ------------------------------------------

                        opt     all+
                        include "depacker_constants.inc"

                        org     0

Ptrs:                   dc.l    Code-Start+2+(5*4)
                        dc.l    Size-Start+2+(5*4)              ; packed length
                        dc.l    Max_Size-Start+2+(5*4)          ; depacked length to clear
                        dc.l    Continue-Start+2+(5*4)          ; depacked length
                        dc.l    Dest-Start+2+(5*4)              ; absolute address
Start:
                        include "supervisor.asm"
                        lea     Var(pc),a5
                        lea     Data-Var(a5),a0                 ; start of data
Size:                   move.l  #0,d0                           ; packed length
                        lea     (a0,d0.l),a6                    ; probs address (right after packed data)
Code:                   move.l  #0,d5                           ; starting code
Dest:                   lea     0,a4
                        lea     (a4),a1
Max_Size:               move.l  #0,d0
Clear_Dest:             sf.b    (a1)+
                        subq.l  #1,d0
                        bge.b   Clear_Dest
                        lea     (a6),a1                         ; probs
                        move.w  #PROBSLEN-1,d7
Fill_Probs:             move.w  #KBITMODELTOTAL>>1,(a1)+
                        dbf     d7,Fill_Probs
                        include "depacker_common.asm"
