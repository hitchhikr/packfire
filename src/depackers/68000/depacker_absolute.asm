; ------------------------------------------
; PackFire
; ------------------------------------------

                        opt     all+
                        include "depacker_constants.inc"

                        org     0

deb:                    dc.l    code-start+2+(5*4)
                        dc.l    size-start+2+(5*4)              ; depacked length to clear
                        dc.l    max_size-start+2+(5*4)          ; depacked length to clear
                        dc.l    cont-start+2+(5*4)              ; depacked length
                        dc.l    dest-start+2+(5*4)              ; absolute address
start:                  
                        include "supervisor.asm"
                        lea     var(pc),a5
                        lea     data-var(a5),a0                 ; start of data
size:                   move.l  #0,d0                           ; packed length
                        lea     (a0,d0.l),a6                    ; probs address (right after packed data)
code:                   move.l  #0,d5                           ; starting code
dest:                   lea     0,a4
                        lea     (a4),a1
max_size:               move.l  #0,d0
clear_dest:             sf.b    (a1)+
                        subq.l  #1,d0
                        bge.b   clear_dest
                        lea     (a6),a1                         ; probs
                        move.w  #PROBSLEN-1,d7
fill_probs:             move.w  #KBITMODELTOTAL>>1,(a1)+
                        dbf     d7,fill_probs
                        include "depacker_common.asm"
