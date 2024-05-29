; ------------------------------------------
; PackFire
; Relocate the data before anything else
; ------------------------------------------

                        org     0

                    IFD ATARI
start:                  move.l  #0,d0                   ; relocs offset
                        lea     (a4,d0.l),a0            ; reloc section address
                        lea     (fin-start)(a4),a4
                        move.l  a4,d3                   ; base address
                        move.l  (a0)+,d0                ; Number of relocs/first pos in code
                        add.l   (a0)+,a4
                        add.l   d3,(a4)
                        moveq   #0,d2
do_reloc:               move.b  (a0)+,d2                ; first dat
                        bne.b   long_reloc_jump
                        lea     254(a4),a4
                        bra.b   done_reloc_dat
long_reloc_jump:        add.l   d2,a4
                        add.l   d3,(a4)
done_reloc_dat:         subq.l  #1,d0
                        bne.b   do_reloc
                    ENDC
                    IFD X68000
start:                  move.l  #0,d0                   ; relocs offset
                        lea     (a4,d0.l),a0            ; reloc section address
                        lea     (fin+8-start)(a4),a3    ; +8 for entry point patch
                        move.l  a3,d3                   ; base address
                        move.l  (a0)+,d0                ; size of relocs
                        lea     (a0,d0.l),a1
do_reloc:               moveq   #0,d2
                        move.w  (a0)+,d2
                        cmp.w   #1,d2
                        bne.b   long_reloc_jump
                        move.l  (a0)+,d2
long_reloc_jump:        add.l   d2,a3
                        add.l   d3,(a3)
                        cmp.l   a1,a0
                        bne.b   do_reloc
                    ENDC
fin:
