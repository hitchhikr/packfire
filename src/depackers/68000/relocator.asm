; ------------------------------------------
; PackFire
; - Process the relocation data
; - Flush the caches
; ------------------------------------------

                        org     0
                        include "depacker_constants.inc"

                        ; a4 = Start
Start:                  move.l  #0,d0                   ; relocs section offset (fixed by packer)
                        lea     (a4,d0.l),a0            ; reloc section address
                        lea     (Fin-Start)(a4),a4
                        move.l  a4,d3                   ; base address
                    IFD ATARI
                        move.l  (a0)+,d0                ; Number of relocs/first pos in code
                        add.l   (a0)+,a4
                        add.l   d3,(a4)
                        moveq   #0,d2
Do_Reloc:               move.b  (a0)+,d2                ; first dat
                        bne.b   Long_Reloc_Jump
                        lea     254(a4),a4
                        bra.b   Done_Reloc_Dat
Long_Reloc_Jump:        add.l   d2,a4
                        add.l   d3,(a4)
Done_Reloc_Dat:         subq.l  #1,d0
                        bne.b   Do_Reloc
                    ENDC
                    IFD X68000
                        move.l  (a0)+,d0                ; size of relocs
                        lea     (a0,d0.l),a1
Do_Reloc:               moveq   #0,d2
                        move.w  (a0)+,d2
                        cmp.w   #1,d2
                        bne.b   Long_Reloc_Jump
                        move.l  (a0)+,d2
Long_Reloc_Jump:        add.l   d2,a4
                        add.l   d3,(a4)
                        cmp.l   a1,a0
                        bne.b   Do_Reloc
                    ENDC
                        ; flush the caches
                        jsr     (a5)
                        lea     Fin(pc),a4
                        rts
Fin:
