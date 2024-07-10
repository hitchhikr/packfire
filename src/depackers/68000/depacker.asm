; ------------------------------------------
; PackFire
; ------------------------------------------

                        opt     all+
                        include "depacker_constants.inc"

                        org     0

Ptrs:                   dc.l    Code-Start+2+(4*4)
                        dc.l    Size-Start+2+(4*4)              ; packed length
                        dc.l    Max_Size-Start+2+(4*4)          ; depacked length to clear
                        dc.l    Continue-Start+2+(4*4)          ; depacked length
Start:
                        include "supervisor.asm"
                        lea     Var(pc),a5
                        lea     Data-Var(a5),a0                 ; start of data
Size:                   move.l  #0,d0                           ; packed length
                        lea     (a0,d0.l),a6                    ; probs address (right after packed data)
Code:                   move.l  #0,d5                           ; starting code
                        lea     (a6),a4
                        lea     (a4),a1                         ; clear the whole dest
Max_Size:               move.l  #0,d0                           ; depacked size + probs size (7990*2)
Clear_Dest:             sf.b    (a1)+
                        subq.l  #1,d0
                        bge.b   Clear_Dest
                        move.w  #PROBSLEN-1,d7
Fill_Probs:             move.w  #KBITMODELTOTAL>>1,(a4)+
                        dbf     d7,Fill_Probs
                        ; a4 = real depacking address (right after the probs)
                        include "depacker_common.asm"
