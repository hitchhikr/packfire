; ------------------------------------------
; PackFire
; Process the relocation data before jumping to the depacked code
; ------------------------------------------

                        org     0

                    IFD ATARI
Start:                  move.l  #0,d0                   ; relocs offset
                        lea     (a4,d0.l),a0            ; reloc section address
                        lea     (Fin-Start)(a4),a4
                        move.l  a4,d3                   ; base address
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
Start:                  move.l  #0,d0                   ; relocs offset
                        lea     (a4,d0.l),a0            ; reloc section address
                        lea     (Fin+8-Start)(a4),a3    ; +8 for entry point patch (can be "depatched" by packer)
                        move.l  a3,d3                   ; base address
                        move.l  (a0)+,d0                ; size of relocs
                        lea     (a0,d0.l),a1
Do_Reloc:               moveq   #0,d2
                        move.w  (a0)+,d2
                        cmp.w   #1,d2
                        bne.b   Long_Reloc_Jump
                        move.l  (a0)+,d2
Long_Reloc_Jump:        add.l   d2,a3
                        add.l   d3,(a3)
                        cmp.l   a1,a0
                        bne.b   Do_Reloc
                    ENDC
Fin:
