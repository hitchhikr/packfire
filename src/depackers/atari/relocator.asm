; ------------------------------------------
; PackFire
; Relocate the data before anything else
; ------------------------------------------

                        org     0

start:                  move.l  #0,d0           ; long offset
                        lea     (a4,d0.l),a0    ; reloc section address
                        lea     (fin-start)(a4),a4
                        move.l  a4,d3
                        move.l  (a0)+,d0        ; Number of relocs/first pos in code
                        add.l   (a0)+,a4
                        add.l   d3,(a4)
                        moveq   #0,d2
do_reloc:               move.b  (a0)+,d2        ; first dat
                        bne.b   long_reloc_jump
                        lea     254(a4),a4
                        bra.b   done_reloc_dat
long_reloc_jump:        add.l   d2,a4
                        add.l   d3,(a4)
done_reloc_dat:         dbf     d0,do_reloc
fin: