; ------------------------------------------
; PackFire
; ------------------------------------------

                        moveq   #0,d3                           ; d3 = posSlot
                        moveq   #0,d4                           ; d4 = state
                        moveq   #1,d7                           ; d7 = rep 0
                        moveq   #0,d6                           ; d6 = len
                        move.l  d6,a2                           ; a2 = nowPos
Depack_Loop:            lea     (a6),a1                         ; probs
                        move.l  d4,d0                           ; retrieve last state
                        lsl.l   #KNUMPOSBITSMAX,d0
                        bsr.w   Check_Fix_Range2
                        bne.b   Fix_Range_1
                        lea     (LITERAL*2)(a6),a3
                        moveq   #1,d3
                        cmp.w   #KNUMLITSTATES,d4
                        bmi.b   Max_Lit_State_2
                        move.l  a2,d0
                        sub.l   d7,d0
                        moveq   #0,d1
                        move.b  (a4,d0.l),d1                    ; distance = d1
Max_Lit_Loop_1:         add.l   d1,d1
                        move.l  d1,d2
                        and.l   #$100,d2
                        move.l  d2,d0
                        add.w   #$100,d0
                        add.w   d0,d0
                        lea     (a3,d0.l),a1
                        bsr.w   Check_Code_Bound
                        bne.b   Check_Code_Bound_1
                        tst.l   d2
                        bne.b   Max_Lit_State_2
                        bra.b   No_Check_Code_Bound_1
Check_Code_Bound_1:     tst.l   d2
                        beq.b   Max_Lit_State_2
No_Check_Code_Bound_1:  cmp.w   #$100,d3
                        bmi.b   Max_Lit_Loop_1
Max_Lit_State_2:        cmp.w   #$100,d3
                        bhs.b   Max_Lit_State_Exit
                        bsr.w   Check_Code_Bound2
                        bra.b   Max_Lit_State_2
Table_State:            dc.b    0,0,0,0
                        dc.b    4-3,5-3,6-3,7-3,8-3,9-3
                        dc.b    10-6,11-6
Max_Lit_State_Exit:     move.b  d3,(a4,a2.l)
                        addq.l  #1,a2
                        move.b  Table_State(pc,d4.w),d4
                        bra.w   Continue
Table_State_2:          dc.b    0,0,0,0,0,0,0
                        dc.b    3,3,3,3,3
Fix_Range_1:            lea     (ISREP*2)(a6),a1
                        bsr.w   Check_Fix_Range3
                        bne.b   Check_Fix_Range_2
                        bsr.b   Cycle_Range
                        move.b  Table_State_2(pc,d4.w),d4
                        lea     (LENCODER*2)(a6),a1
                        bra.w   Check_Fix_Range_3
Table_State_3:          dc.b    9,9,9,9,9,9,9
                        dc.b    11,11,11,11,11
Check_Fix_Range_2:      lea     (ISREPG0*2)(a6),a1
                        bsr.w   Check_Fix_Range3
                        bne.b   Check_Fix_Range_4
                        lea     (ISREP0LONG*2)(a6),a1
                        move.l  d4,d0
                        lsl.l   #KNUMPOSBITSMAX,d0
                        bsr.w   Check_Fix_Range2
                        bne.b   Check_Fix_Range_5
                        move.b  Table_State_3(pc,d4.w),d4
                        move.l  a2,d0
                        sub.l   d7,d0
                        move.b  (a4,d0.l),(a4,a2.l)
                        addq.l  #1,a2
                        bra.w   Continue
Check_Fix_Range_4:      lea     (ISREPG1*2)(a6),a1
                        bsr.w   Check_Fix_Range3
                        bne.b   Check_Fix_Range_6b
                        move.l  Rep_1-Var(a5),d1             ; d1 = distance
                        bsr.b   Check_Fix_Range_7
                        bra.b   Check_Fix_Range_Cont
Cycle_Range:            move.l  Rep_3-Var(a5),d1
                        move.l  Rep_2-Var(a5),Rep_3-Var(a5)
Check_Fix_Range_9:      move.l  Rep_1-Var(a5),Rep_2-Var(a5)
Check_Fix_Range_7:      move.l  d7,Rep_1-Var(a5)
                        rts
Check_Fix_Range_6b:     lea     (ISREPG2*2)(a6),a1
                        bsr.w   Check_Fix_Range3
                        bne.b   Check_Fix_Range_8
                        move.l  Rep_2-Var(a5),d1             ; d1 = distance
                        bsr.b   Check_Fix_Range_9
                        bra.b   Check_Fix_Range_Cont
Table_State_4:          dc.b    8,8,8,8,8,8,8
                        dc.b    11,11,11,11,11
Check_Fix_Range_8:      bsr.b   Cycle_Range
Check_Fix_Range_Cont:   move.l  d1,d7
Check_Fix_Range_5:      move.b  Table_State_4(pc,d4.w),d4
                        lea     (REPLENCODER*2)(a6),a1
Check_Fix_Range_3:      lea     (a1),a3
                        bsr.w   Check_Fix_Range
                        bne.b   Check_Fix_Range_10
                        lea     (LENLOW*2)+(KLENNUMLOWBITS*2)(a3),a3
                        moveq   #0,d3
                        moveq   #KLENNUMLOWBITS,d1          ; d1 = distance
                        bra.b   Check_Fix_Range_11
Check_Fix_Range_10:     lea     (LENCHOICE2*2)(a3),a1
                        bsr.w   Check_Fix_Range
                        bne.b   Check_Fix_Range_12
                        lea     (LENMID*2)+(KLENNUMMIDBITS*2)(a3),a3
                        moveq   #KLENNUMLOWSYMBOLS,d3
                        moveq   #KLENNUMMIDBITS,d1          ; d1 = distance
                        bra.b   Check_Fix_Range_11
Check_Fix_Range_12:     lea     (LENHIGH*2)(a3),a3
                        moveq   #KLENNUMLOWSYMBOLS+KLENNUMMIDSYMBOLS,d3
                        moveq   #KLENNUMHIGHBITS,d1         ; d1 = distance
Check_Fix_Range_11:     move.l  d1,d2
                        moveq   #1,d6
Check_Code_Bound_Loop:  exg.l   d6,d3
                        bsr.w   Check_Code_Bound2
                        exg.l   d6,d3
                        subq.l  #1,d2
                        bne.b   Check_Code_Bound_Loop
                        moveq   #1,d0
                        lsl.l   d1,d0
                        sub.l   d0,d6
                        add.l   d3,d6
                        cmp.w   #4,d4
                        bhs.w   Change_State_6
                        addq.w  #KNUMLITSTATES,d4
                        move.l  d6,d0
                        cmp.w   #KNUMLENTOPOSSTATES,d0
                        bmi.b   Check_Len
                        moveq   #KNUMLENTOPOSSTATES-1,d0
Check_Len:              lea     (POSSLOT*2)(a6),a3
                        lsl.l   #KNUMPOSSLOTBITS+1,d0
                        add.l   d0,a3
                        moveq   #1,d3
                        REPT    KNUMPOSSLOTBITS
                            bsr.w   Check_Code_Bound2
                        ENDR
                        sub.w   #(1<<KNUMPOSSLOTBITS),d3
                        cmp.w   #KSTARTPOSMODELINDEX,d3
                        bmi.b   Check_PosSlot_1
                        move.l  d3,d1
                        lsr.l   #1,d1
                        subq.l  #1,d1                       ; distance = d1
                        move.l  d3,d0
                        moveq   #1,d7
                        and.l   d7,d0
                        addq.l  #2,d0
                        move.l  d0,d7
                        cmp.w   #KENDPOSMODELINDEX,d3
                        bhs.b   Check_PosSlot_3
                        lsl.l   d1,d0
                        move.l  d0,d7
                        lea     (SPECPOS*2)(a6),a3
                        sub.l   d3,d0
                        subq.l  #1,d0
                        add.l   d0,d0
                        add.l   d0,a3
                        bra.b   Check_PosSlot_4
Check_PosSlot_3:        subq.l  #KNUMALIGNBITS,d1
Shift_Range_Loop:       move.l  (a5),d0                     ; a5 = range
                        lsr.l   #1,d0
                        add.l   d7,d7
                        move.l  d0,(a5)
                        cmp.l   d5,d0
                        bhi.b   Check_Code
                        sub.l   d0,d5
                        addq.l  #1,d7
Check_Code:             bsr.w   Get_Code
                        subq.l  #1,d1
                        bne.b   Shift_Range_Loop
                        lea     (ALIGN*2)(a6),a3
                        lsl.l   #KNUMALIGNBITS,d7
                        moveq   #KNUMALIGNBITS,d1           ; distance = d1
Check_PosSlot_4:        moveq   #1,d2
                        moveq   #1,d3
Check_Code_Bound_Loop3: bsr.b   Check_Code_Bound2
                        beq.b   Check_Code_Bound_2
                        or.l    d2,d7
Check_Code_Bound_2:     add.l   d2,d2
                        subq.l  #1,d1
                        bne.b   Check_Code_Bound_Loop3
                        bra.b   Check_PosSlot_2
Check_PosSlot_1:        move.l  d3,d7
Check_PosSlot_2:        addq.l  #1,d7
Change_State_6:         addq.l  #KMATCHMINLEN,d6
                        move.l  a2,d0
                        sub.l   d7,d0
                        lea     (a4,d0.l),a3
                        add.l   a4,a2
Copy_Rem_Bytes:         move.b  (a3)+,(a2)+
                        subq.l  #1,d6
                        bne.b   Copy_Rem_Bytes
                        sub.l   a4,a2
Continue:               cmp.l   #0,a2
                        bmi.w   Depack_Loop
                        include "user.asm"
                        jmp     (a4)
; prob in a1
Check_Code_Bound2:      lea     (a3),a1
Check_Code_Bound:       add.l   d3,d3                       ; needed for the index
                        lea     (a1,d3.l),a1
                        bsr.b   Check_Fix_Range
                        beq.b   Lower_Bound
                        addq.l  #1,d3
Lower_Bound:            rts
Range_Lower:            sub.l   d0,(a5)
                        sub.l   d0,d5
                        move.w  (a1),d0
                        lsr.w   #KNUMMOVEBITS,d0
                        sub.w   d0,(a1)
                        bsr.b   Get_Code
                        moveq   #1,d0
                        rts
; prob in a1
Check_Fix_Range3:       move.l  d4,d0
Check_Fix_Range2:       add.l   d0,d0
                        add.l   d0,a1
Check_Fix_Range:        move.l  (a5),d0                     ; get range
                        lsr.l   #8,d0
                        lsr.l   #3,d0                       ; >> 11
                        move.l  d1,-(a7)
                        move.l  d0,d1
                        swap    d1
                        mulu.w  (a1),d0                     ; range * prob data
                        mulu.w  (a1),d1
                        swap    d1
                        add.l   d1,d0
                        move.l  (a7)+,d1
                        cmp.l   d5,d0                       ; result < code ?
                        bls.b   Range_Lower
                        move.l  d0,(a5)                     ; store new range
                        move.w  #KBITMODELTOTAL,d0
                        sub.w   (a1),d0
                        lsr.w   #KNUMMOVEBITS,d0            ; take 6 upper bits
                        add.w   d0,(a1)
; a0 = buffer
Get_Code:               move.l  (a5),d0
                        cmp.l   #KTOPVALUE,d0
                        bhs.b   Top_Range
                        lsl.l   #8,d0                       ; range: xxxxxxxx > xxxxxx00
                        move.l  d0,(a5)
                        lsl.l   #8,d5
                        move.b  (a0)+,d5                    ; code: xxxxxxxx > xxxxxxyy
                        ; color flash
                    IFD ATARI
                        move.w  d5,(VID_COLOR_0).w
                    ENDC
                    IFD X68000
                        move.w  d5,SPR_PAL0_DTA
                    ENDC
Top_Range:              moveq   #0,d0
                        rts
Var:
Range:                  dc.l    -1
Rep_3:                  dc.l    1
Rep_2:                  dc.l    1
Rep_1:                  dc.l    1
Data:
