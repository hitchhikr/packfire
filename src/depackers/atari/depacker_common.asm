; ------------------------------------------
; PackFire
; ------------------------------------------

                        moveq   #0,d3                           ; d3 = posSlot
                        moveq   #0,d4                           ; d4 = state
                        moveq   #1,d7                           ; d7 = rep 0
                        moveq   #0,d6                           ; d6 = len
                        move.l  d6,a2                           ; a2 = nowPos
depack_loop:            lea     (a6),a1                         ; probs
                        move.l  d4,d0                           ; retrieve last state
                        lsl.l   #KNUMPOSBITSMAX,d0
                        bsr.w   Check_Fix_Range2
                        bne.b   fix_range1
                        lea     (LITERAL*2)(a6),a3
                        moveq   #1,d3
                        cmp.w   #KNUMLITSTATES,d4
                        bmi.b   max_lit_state_2
                        move.l  a2,d0
                        sub.l   d7,d0
                        moveq   #0,d1
                        move.b  (a4,d0.l),d1                    ; distance = d1
max_lit_loop1:          add.l   d1,d1
                        move.l  d1,d2
                        and.l   #$100,d2
                        move.l  d2,d0
                        add.w   #$100,d0
                        add.w   d0,d0
                        lea     (a3,d0.l),a1
                        bsr.w   Check_Code_Bound
                        bne.b   Check_Code_Bound_1
                        tst.l   d2
                        bne.b   max_lit_state_2
                        bra.b   No_Check_Code_Bound_1
Check_Code_Bound_1:     tst.l   d2
                        beq.b   max_lit_state_2
No_Check_Code_Bound_1:  cmp.w   #$100,d3
                        bmi.b   max_lit_loop1
max_lit_state_2:        cmp.w   #$100,d3
                        bhs.b   max_lit_state_exit
                        bsr.w   Check_Code_Bound2
                        bra.b   max_lit_state_2
table_state:            dc.b    0,0,0,0
                        dc.b    4-3,5-3,6-3,7-3,8-3,9-3
                        dc.b    10-6,11-6
max_lit_state_exit:     move.b  d3,d0
                        bsr.w   store_prev_byte2
                        move.b  table_state(pc,d4.w),d4
                        bra.w   cont
fix_range1:             lea     (ISREP*2)(a6),a1
                        bsr.w   Check_Fix_Range3
                        bne.b   Check_Fix_Range_2
                        bsr.b   Cycle_Range
                        move.l  d4,d0
                        moveq   #0,d4
                        cmp.w   #KNUMLITSTATES,d0
                        bmi.b   change_state_3
                        moveq   #3,d4
change_state_3:         lea     (LENCODER*2)(a6),a1
                        bra.b   Check_Fix_Range_3
Check_Fix_Range_2:      lea     (ISREPG0*2)(a6),a1
                        bsr.w   Check_Fix_Range3
                        bne.b   Check_Fix_Range_4
                        lea     (ISREP0LONG*2)(a6),a1
                        move.l  d4,d0
                        lsl.l   #KNUMPOSBITSMAX,d0
                        bsr.w   Check_Fix_Range2
                        bne.b   Check_Fix_Range_5
                        move.l  d4,d0
                        moveq   #9,d4
                        cmp.w   #KNUMLITSTATES,d0
                        bmi.b   change_state_4
                        moveq   #11,d4
change_state_4:         bsr.w   store_prev_byte
                        bra.w   cont
Check_Fix_Range_4:      lea     (ISREPG1*2)(a6),a1
                        bsr.w   Check_Fix_Range3
                        bne.b   Check_Fix_Range_6b
                        move.l  rep1-var(a5),d1             ; d1 = distance
                        bsr.b   Check_Fix_Range_7
                        bra.b   Check_Fix_Range_Cont
Cycle_Range:            move.l  rep3-var(a5),d1
                        move.l  rep2-var(a5),rep3-var(a5)
Check_Fix_Range_9:      move.l  rep1-var(a5),rep2-var(a5)
Check_Fix_Range_7:      move.l  d7,rep1-var(a5)
                        rts
Check_Fix_Range_6b:     lea     (ISREPG2*2)(a6),a1
                        bsr.w   Check_Fix_Range3
                        bne.b   Check_Fix_Range_8
                        move.l  rep2-var(a5),d1             ; d1 = distance
                        bsr.b   Check_Fix_Range_9
                        bra.b   Check_Fix_Range_Cont
Check_Fix_Range_8:      bsr.b   Cycle_Range
Check_Fix_Range_Cont:   move.l  d1,d7
Check_Fix_Range_5:      move.l  d4,d0
                        moveq   #8,d4
                        cmp.w   #KNUMLITSTATES,d0
                        bmi.b   Change_State_5
                        moveq   #11,d4
Change_State_5:         lea     (REPLENCODER*2)(a6),a1
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
                        bhs.w   change_state_6
                        addq.w  #KNUMLITSTATES,d4
                        move.l  d6,d0
                        cmp.w   #KNUMLENTOPOSSTATES,d0
                        bmi.b   check_len
                        moveq   #KNUMLENTOPOSSTATES-1,d0
check_len:              lea     (POSSLOT*2)(a6),a3
                        lsl.l   #KNUMPOSSLOTBITS+1,d0
                        add.l   d0,a3
                        moveq   #KNUMPOSSLOTBITS,d2         ; i = d2
                        moveq   #1,d3
Check_Code_Bound_Loop2: bsr.w   Check_Code_Bound2
                        subq.l  #1,d2
                        bne.b   Check_Code_Bound_Loop2
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
Check_Code_Bound_Loop3: bsr.w   Check_Code_Bound2
                        beq.b   Check_Code_Bound_2
                        or.l    d2,d7
Check_Code_Bound_2:     add.l   d2,d2
                        subq.l  #1,d1
                        bne.b   Check_Code_Bound_Loop3
                        bra.b   Check_PosSlot_2
Check_PosSlot_1:        move.l  d3,d7
Check_PosSlot_2:        addq.l  #1,d7
change_state_6:         addq.l  #KMATCHMINLEN,d6
Copy_Rem_Bytes:         bsr.b   store_prev_byte
                        subq.l  #1,d6
                        bne.b   Copy_Rem_Bytes
                        move.w  d0,(VID_COLOR_0).w
cont:                   
                        cmp.l   #0,a2
                        bmi.w   depack_loop

                    IF RESTORE_USER_LEVEL == 1
                        move.w  (a7)+,(VID_COLOR_0).w
                    ENDC

                        include "user.asm"
                        jmp     (a4)

store_prev_byte:        move.l  a2,d0
                        sub.l   d7,d0
                        move.b  (a4,d0.l),d0
store_prev_byte2:       move.b  d0,(a4,a2.l)
                        addq.l  #1,a2
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
                        bhs.b   top_range
                        lsl.l   #8,d0                       ; range: xxxxxxxx > xxxxxx00
                        move.l  d0,(a5)
                        lsl.l   #8,d5
                        move.b  (a0)+,d5                    ; code: xxxxxxxx > xxxxxxyy
top_range:              moveq   #0,d0
                        rts
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
var:
Range:                  dc.l    -1
rep3:                   dc.l    1
rep2:                   dc.l    1
rep1:                   dc.l    1
data:
