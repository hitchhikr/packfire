; ------------------------------------------
; PackFire
; ------------------------------------------

                        opt     all+
                        include "depacker_constants.inc"

                        org     0

deb:                    dc.l    code-start+2+(4*4)
                        dc.l    size-start+2+(4*4)              ; packed length
                        dc.l    max_size-start+2+(4*4)
                        dc.l    cont-start+2+(4*4)              ; depacked length
start:
                        include "supervisor.asm"
                        lea     var(pc),a5
                        lea     data-var(a5),a0                 ; start of data
size:                   move.l  #0,d0                           ; packed length
                        lea     (a0,d0.l),a6                    ; probs address (right after packed data)
code:                   move.l  #0,d5                           ; starting code
                        lea     (a6),a4
                        lea     (a4),a1                         ; clear the whole dest
max_size:               move.l  #0,d0                           ; depacked size + probs size (7990*2)
clear_dest:             sf.b    (a1)+
                        subq.l  #1,d0
                        bge.b   clear_dest
                        move.w  #PROBSLEN-1,d7
fill_probs:             move.w  #KBITMODELTOTAL>>1,(a4)+
                        dbf     d7,fill_probs
                        ; a4 = real depacking address (right after the probs)
                        include "depacker_common.asm"
