@ ------------------------------------------
@ PackFire
@ Quite messy... and could be made smaller
@ ------------------------------------------

                        .include "lzma_constants.inc"
                        
                        .macro  LD16 register,value
                        mov     \register,\value>>8
                        lsl     \register,\register,#8
                        add     \register,\register,\value&0xff
                        .endm
                        .macro  LD162 register,value
                        mov     \register,\value>>8
                        lsl     \register,\register,#8
                        .endm
NBR_PTR                 =       (17*4)
                        .arm
Ptrs:                   .long   Packed_Size_Arm9-Header+NBR_PTR         @ 0
                        .long   Packed_Size_Arm7-Header+NBR_PTR         @ 1
                        .long   Arm9_Depacked_Address-Header+NBR_PTR    @ 2
                        .long   Arm9_Load-Header+NBR_PTR                @ 3
                        .long   Arm9_Entry-Header+NBR_PTR               @ 4
                        .long   Arm9_Length-Header+NBR_PTR              @ 5
                        .long   Arm7_Depacked_Address-Header+NBR_PTR    @ 6
                        .long   Arm7_Depacked_Offset-Header+NBR_PTR     @ 7
                        .long   Arm7_Depacked_Length-Header+NBR_PTR     @ 8
                        .long   Arm7_Load-Header+NBR_PTR                @ 9
                        .long   Arm7_Entry-Header+NBR_PTR               @ 10
                        .long   Rom_Size-Header+NBR_PTR                 @ 11
                        .long   Crc16-Header+NBR_PTR                    @ 12
                        .long   Fat_Source-Header+NBR_PTR               @ 13
                        .long   Arm9_Code-Header+NBR_PTR                @ 14
                        .long   Secure_Crc16-Header+NBR_PTR             @ 15
                        .long   Probe_Arm7_Address-Header+NBR_PTR       @ 16 (68 bytes)
Header:                 .byte   0x2e
                        .byte   0,0
                        .byte   0xea
                        .byte   0,0,0,0,0,0,0,0
                        .long   0x23232323                              @ 14 game_code
                        .byte   0,0                                     @ 16 maker_code
                        .byte   0                                       @ 18 unit_code
                        .byte   0                                       @ 19 encryption Seed Select
                        .byte   5                                       @ 20 device capacity
                        .fill   7                                       @ 21 reserved
                        .byte   0                                       @ 28 reserved
                        .byte   0                                       @ 29 region
                        .byte   0                                       @ 30 rom_version
                        .byte   0b100                                   @ 31 autostart
                        .long   (Arm9_Code-Header)                      @ 32 arm9_rom_offset
Arm9_Load:              .long   0x2000000                               @ 36 Arm9_Entry_address
Arm9_Entry:             .long   0x2000000                               @ 40 arm9_ram_address
Arm9_Length:            .long   0                                       @ 44 arm9_size
                        .long   (Arm7_Code-Header)                      @ 48 arm7_rom_offset
Arm7_Load:              .long   0x37f8000                               @ 52 Arm7_Entry_address
Arm7_Entry:             .long   0x37f8000                               @ 56 arm7_ram_address
                        .long   (End_Arm7_Code-Arm7_Code)               @ 60 arm7_size
                        .long   (FNT-Header)                            @ 64 filename_source
                        .long   1                                       @ 68 filename_size
Fat_Source:             .long   0                                       @ 72 Fat_Source (at the end of the file)
                        .long   0                                       @ 76 fat_size (0)
                        .long   0                                       @ 80 arm9_overlay_source
                        .long   0                                       @ 84 arm9_overlay_size
                        .long   0                                       @ 88 arm7_overlay_source
                        .long   0                                       @ 92 arm7_overlay_size
                        .long   0x007f7fff                              @ 96 port 40001A4h setting for normal commands
                        .long   0x203f1fff                              @ 100 port 40001A4h setting for KEY1 commands
                        .long   0                                       @ 104 icon/title offset
Secure_Crc16:           .byte   0,0                                     @ 108 secure Area Checksum
                        .short  0x051e                                  @ 110 secure Area Delay
                        .long   0                                       @ 112 ARM9 Auto Load List Hook RAM Address
                        .long   0                                       @ 116 ARM7 Auto Load List Hook RAM Address
                        .long   0,0                                     @ 120 secure area disable
Rom_Size:               .long   0                                       @ 128 total Used ROM size
                        .long   (End_Header-Header)                     @ 132 ROM Header Size
                        .byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        .byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x53,0x52,0x41,0x4d,0x5f,0x56,0x31,0x31
                        .byte	0x30,0x00,0x00,0x00,0x50,0x41,0x53,0x53,0x30,0x31,0x96,0x00,0x00,0x00,0x00,0x00
                        .byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0xc8,0x60,0x4f,0xe2,0x01,0x70,0x8f,0xe2
                        .byte	0x17,0xff,0x2f,0xe1,0x12,0x4f,0x11,0x48,0x12,0x4c,0x20,0x60,0x64,0x60,0x7c,0x62
                        .byte	0x30,0x1c,0x39,0x1c,0x10,0x4a,0x00,0xf0,0x14,0xf8,0x30,0x6a,0x80,0x19,0xb1,0x6a
                        .byte	0xf2,0x6a,0x00,0xf0,0x0b,0xf8,0x30,0x6b,0x80,0x19,0xb1,0x6b,0xf2,0x6b,0x00,0xf0
                        .byte	0x08,0xf8,0x70,0x6a,0x77,0x6b,0x07,0x4c,0x60,0x60,0x38,0x47,0x07,0x4b,0xd2,0x18
                        .byte	0x9a,0x43,0x07,0x4b,0x92,0x08,0xd2,0x18,0x0c,0xdf,0xf7,0x46,0x04,0xf0,0x1f,0xe5
                        .byte	0x00,0xfe,0x7f,0x02,0xf0,0xff,0x7f,0x02,0xf0,0x01,0x00,0x00,0xff,0x01,0x00,0x00
                        .byte	0x00,0x00,0x00,0x04,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        .byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        .byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        .byte	0x00,0x00,0x00,0x00
                        .byte   0x1a,0x9e
Crc16:                  .byte   0xe8,0x1c                               @ 350 Header Checksum, CRC-16 of [000h-15Dh]
                        @ Those seem to be unnecessary...
                        @.byte   0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
                        @.byte	0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00
End_Header:
                        .arm
Arm7_Code:              add     r0,pc,#1
                        bx      r0
                        .thumb
                        ldr     r3,Probe_Arm7_Address
                        ldr     r4,Arm7_Depacked_Address
                        ldr     r5,Arm7_Depacked_Offset
                        add     r3,r5
                        ldr     r6,Arm7_Depacked_Length
                        ldr     r0,Packed_Size_Arm7
                        @ point at the end of the depacked data
                        add     r1,r3,r6
                        @ + the end of the packed data
                        add     r1,r0
                        @ synchro probe
Wait_Depack:            ldr     r2,[r1]
                        cmp     r2,#0xaa
                        bne     Wait_Depack
                        mov     r5,r4
Copy_Arm7_Code:         ldrb    r0,[r3]
                        strb    r0,[r4]
                        add     r3,#1
                        add     r4,#1
                        sub     r6,#1
                        bne     Copy_Arm7_Code
                        @ acknowledge
                        mov     r2,#0x55
                        str     r2,[r1]
                        bx      r5
                        .arm
                        .align  4
Packed_Size_Arm7:       .long   0
Probe_Arm7_Address:     .long   0
Arm7_Depacked_Address:  .long   0
Arm7_Depacked_Offset:   .long   0
Arm7_Depacked_Length:   .long   0
End_Arm7_Code:
FNT:                    .byte   8,0,0,0
                        .byte   0,0
                        .byte   1,0
                        .byte   0,0
                        .byte   0
                        .byte   0
                        .byte   0,0
                        .align  4
Arm9_Code:              mov     r0,#0x4000000
                        @ turn upper display on
                        ldr     r1,[r0]
                        orr     r2,r1,#0x10000
                        str     r2,[r0]
                        add     r0,pc,#1
                        bx      r0
                        .thumb
                        ldr     r4,Arm9_Depacked_Address
                        adr     r1,Packed_Ptr
                        adr     r0,Packed_Data+8
                        str     r0,[r1]
                        @ depacked size
                        ldr     r1,Packed_Data
                        add     r6,r4,r1
                        @ + packed size
                        ldr     r2,Packed_Size_Arm9
                        add     r6,r2
                        @ for the acknowledgment
                        add     r6,#4
                        mov     r2,#0
Clear_Buffer:           strb    r2,[r4,r1]
                        sub     r1,#1
                        bge     Clear_Buffer
                        mov     r0,r6
                        LD16    r1,#PROBSLEN
Fill_Probs:             LD162   r2,#KBITMODELTOTAL>>1
                        strh    r2,[r0]
                        add     r0,#2
                        sub     r1,#1
                        bne     Fill_Probs
                        mov     r0,#0
                        mov     r10,r0
                        mov     r11,r0
                        mov     r12,r0
                        mov     r9,r0
                        mov     r7,#1
Depack_Loop:            mov     r3,r6
                        mov     r0,r11
                        lsl     r0,#KNUMPOSBITSMAX
                        bl      Check_Fix_Range2
                        bne     Fix_Range_1
                        LD16    r0,#(LITERAL*2)
                        add     r0,r6
                        mov     r8,r0
                        mov     r0,#1
                        mov     r10,r0
                        mov     r0,r11
                        cmp     r0,#KNUMLITSTATES
                        bmi     Max_Lit_State_2
                        mov     r0,r9
                        sub     r0,r7
                        ldrb    r1,[r4,r0]
Max_Lit_Loop_1:         add     r1,r1
                        mov     r2,r1
                        LD162   r5,#0x100
                        and     r2,r5
                        mov     r0,r2
                        add     r0,r5
                        add     r0,r0
                        mov     r5,r8
                        add     r5,r0
                        mov     r3,r5
                        bl      Check_Code_Bound
                        bne     Check_Code_Bound_1
                        cmp     r2,#0
                        bne     Max_Lit_State_2
                        b       No_Check_Code_Bound_1
Check_Code_Bound_1:     cmp     r2,#0
                        beq     Max_Lit_State_2
No_Check_Code_Bound_1:  LD162   r5,#0x100
                        cmp     r10,r5
                        bmi     Max_Lit_Loop_1
Max_Lit_State_2:        LD162   r5,#0x100
                        cmp     r10,r5
                        bhs     max_lit_state_exit
                        bl      Check_Code_Bound2
                        b       Max_Lit_State_2
max_lit_state_exit:     mov     r0,r10
                        bl      Store_Prev_Byte_2
                        adr     r2,Table_State
                        add     r2,r11
                        ldrb    r2,[r2]
                        mov     r11,r2
                        b       Continue
Fix_Range_1:            LD16    r3,#(ISREP*2)
                        bl      Check_Fix_Range3
                        bne     Check_Fix_Range_2
                        adr     r5,Rep_3
                        ldr     r2,Rep_2
                        str     r2,[r5]
                        adr     r5,Rep_2
                        ldr     r2,Rep_1
                        str     r2,[r5]
                        adr     r5,Rep_1
                        str     r7,[r5]
                        mov     r0,r11
                        mov     r5,#0
                        cmp     r0,#KNUMLITSTATES
                        bmi     Change_State_3
                        mov     r5,#3
Change_State_3:         mov     r11,r5
                        LD16    r3,#(LENCODER*2)
                        add     r3,r6
                        b       Check_Fix_Range_3
Check_Fix_Range_2:      LD16    r3,#(ISREPG0*2)
                        bl      Check_Fix_Range3
                        bne     Check_Fix_Range_4
                        LD16    r3,#(ISREP0LONG*2)
                        add     r3,r6
                        mov     r0,r11
                        lsl     r0,#KNUMPOSBITSMAX
                        bl      Check_Fix_Range2
                        bne     Check_Fix_Range_5
                        mov     r0,r11
                        mov     r5,#9
                        cmp     r0,#KNUMLITSTATES
                        bmi     Change_State_4
                        mov     r5,#11
Change_State_4:         mov     r11,r5
                        bl      Store_Prev_Byte
                        b       Continue
Check_Fix_Range_4:      LD16    r3,#(ISREPG1*2)
                        bl      Check_Fix_Range3
                        bne     Check_Fix_Range_6b
                        ldr     r1,Rep_1
                        b       Check_Fix_Range_7
Check_Fix_Range_6b:     LD16    r3,#(ISREPG2*2)
                        bl      Check_Fix_Range3
                        bne     Check_Fix_Range_8
                        ldr     r1,Rep_2
                        b       Check_Fix_Range_9
Check_Fix_Range_8:      ldr     r1,Rep_3
                        adr     r5,Rep_3
                        ldr     r2,Rep_2
                        str     r2,[r5]
Check_Fix_Range_9:      adr     r5,Rep_2
                        ldr     r2,Rep_1
                        str     r2,[r5]
Check_Fix_Range_7:      adr     r5,Rep_1
                        str     r7,[r5]
                        mov     r7,r1
Check_Fix_Range_5:      mov     r0,r11
                        mov     r5,#8
                        cmp     r0,#KNUMLITSTATES
                        bmi     Change_State_5
                        mov     r5,#11
Change_State_5:         mov     r11,r5
                        LD16    r3,#(REPLENCODER*2)
                        add     r3,r6
Check_Fix_Range_3:      mov     r8,r3
                        bl      Check_Fix_Range
                        bne     Check_Fix_Range_10
                        mov     r5,#(LENLOW+KLENNUMLOWBITS)*2
                        add     r8,r5
                        mov     r5,#0
                        mov     r10,r5
                        mov     r1,#KLENNUMLOWBITS
                        b       Check_Fix_Range_11
Check_Fix_Range_10:     mov     r3,#(LENCHOICE2*2)
                        add     r3,r8
                        bl      Check_Fix_Range
                        bne     Check_Fix_Range_12
                        LD16    r5,#(LENMID+KLENNUMMIDBITS)*2
                        add     r8,r5
                        mov     r5,#KLENNUMLOWSYMBOLS
                        mov     r10,r5
                        mov     r1,#KLENNUMMIDBITS
                        b       Check_Fix_Range_11
Check_Fix_Range_12:     LD16    r5,#(LENHIGH*2)
                        add     r8,r5
                        mov     r5,#KLENNUMLOWSYMBOLS+KLENNUMMIDSYMBOLS
                        mov     r10,r5
                        mov     r1,#KLENNUMHIGHBITS
Check_Fix_Range_11:     mov     r2,r1
                        mov     r5,#1
                        mov     r12,r5
Check_Code_Bound_Loop:  mov     r5,r10
                        mov     r10,r12
                        mov     r12,r5
                        bl      Check_Code_Bound2
                        mov     r5,r10
                        mov     r10,r12
                        mov     r12,r5
                        sub     r2,#1
                        bne     Check_Code_Bound_Loop
                        mov     r0,#1
                        lsl     r0,r1
                        mov     r2,r12
                        sub     r2,r0
                        add     r2,r10
                        mov     r12,r2
                        mov     r5,#4
                        cmp     r11,r5
                        bhs     Change_State_6
                        mov     r5,r11
                        add     r5,#KNUMLITSTATES
                        mov     r11,r5
                        mov     r0,r12
                        cmp     r0,#KNUMLENTOPOSSTATES
                        bmi     Check_Len
                        mov     r0,#KNUMLENTOPOSSTATES-1
Check_Len:              LD16    r5,#POSSLOT*2
                        add     r5,r6
                        mov     r8,r5
                        lsl     r0,#KNUMPOSSLOTBITS+1
                        add     r8,r0
                        mov     r2,#KNUMPOSSLOTBITS
                        mov     r5,#1
                        mov     r10,r5
Check_Code_Bound_Loop2: bl      Check_Code_Bound2
                        sub     r2,#1
                        bne     Check_Code_Bound_Loop2
                        mov     r5,r10
                        sub     r5,#(1<<KNUMPOSSLOTBITS)
                        mov     r10,r5
                        cmp     r5,#KSTARTPOSMODELINDEX
                        bmi     Check_PosSlot_1
                        mov     r1,r10
                        lsr     r1,#1
                        sub     r1,#1
                        mov     r0,r10
                        mov     r2,#1
                        and     r0,r2
                        add     r0,#2
                        mov     r7,r0
                        mov     r2,r10
                        cmp     r2,#KENDPOSMODELINDEX
                        bhs     Check_PosSlot_3
                        lsl     r0,r1
                        mov     r7,r0
                        LD16    r2,#SPECPOS*2
                        add     r2,r6
                        mov     r8,r2
                        mov     r2,r10
                        sub     r0,r2
                        sub     r0,#1
                        add     r0,r0
                        add     r8,r0
                        b       Check_PosSlot_4
Check_PosSlot_3:        sub     r1,#KNUMALIGNBITS
Shift_Range_Loop:       adr     r5,Range
                        ldr     r2,[r5]
                        lsr     r2,#1
                        add     r7,r7
                        str     r2,[r5]
                        adr     r0,Packed_Data+4
                        ldr     r5,[r0]
                        cmp     r2,r5
                        bhi     Check_Code
                        sub     r5,r2
                        str     r5,[r0]
                        add     r7,#1
Check_Code:             bl      Get_Code
                        sub     r1,#1
                        bne     Shift_Range_Loop
                        LD16    r2,#ALIGN*2
                        add     r2,r6
                        mov     r8,r2
                        lsl     r7,#KNUMALIGNBITS
                        mov     r1,#KNUMALIGNBITS
Check_PosSlot_4:        mov     r2,#1
                        mov     r10,r2
Check_Code_Bound_Loop3: bl      Check_Code_Bound2
                        beq     Check_Code_Bound_2
                        orr     r7,r2
Check_Code_Bound_2:     add     r2,r2                        
                        sub     r1,#1
                        bne     Check_Code_Bound_Loop3
                        b       Check_PosSlot_2
Check_PosSlot_1:        mov     r7,r10
Check_PosSlot_2:        add     r7,#1
Change_State_6:         mov     r5,r12
                        add     r5,#KMATCHMINLEN
Copy_Rem_Bytes:         bl      Store_Prev_Byte
                        sub     r5,#1
                        bne     Copy_Rem_Bytes
Continue:               ldr     r5,Packed_Data
                        cmp     r9,r5
                        bpl     Depack_Stop
                        b       Depack_Loop
Depack_Stop:
                        @ return to arm mode by launching the code
                        @ for the arm9 and the arm7
                        sub     r6,#4
                        mov     r1,#0xaa
                        str     r1,[r6]
                        mov     r0,pc
                        bx      r0
                        .arm
                        mov     r0,#0
                        MCR     P15,0,r0,C7,C5,4
                        MCR     P15,0,r0,C7,C5,6
                        MCR     P15,0,r0,C7,C5,0
                        MCR     P15,0,r0,C7,C6,0
                        MCR     P15,0,r4,C7,C10,1
                        @ synchronize both processors
wait_copy:              ldr     r2,[r6]
                        cmp     r2,#0x55
                        bne     wait_copy
                        bx      r4
                        .thumb
Store_Prev_Byte:        mov     r2,r9
                        sub     r2,r7
                        ldrb    r0,[r4,r2]
Store_Prev_Byte_2:      mov     r2,r9
                        strb    r0,[r4,r2]
                        add     r2,#1
                        mov     r9,r2
                        mov     pc,lr
Check_Code_Bound2:      mov     r3,r8
Check_Code_Bound:       add     r10,r10
                        add     r3,r10
                        push    {lr}
                        bl      Check_Fix_Range
                        bne     Lower_Bound
                        pop     {pc}
Lower_Bound:            mov     r5,r10
                        add     r5,#1
                        mov     r10,r5
                        pop     {pc}
Get_Code2:              strh    r4,[r3]
Get_Code:               push    {r0,r2,lr}
                        adr     r0,Range
                        ldr     r5,[r0]
                        mov     r2,#1
                        lsl     r2,#24
                        cmp     r5,r2
                        bhs     Top_Range
                        lsl     r5,#8
                        str     r5,[r0]
                        ldr     r5,Packed_Data+4
                        lsl     r5,#8
                        ldr     r0,Packed_Ptr
                        ldrb    r0,[r0]
                        add     r5,r0
                        @ color flash
                        @ (color 0 at 0x5000000)
                        mov     r0,#0x50
                        lsl     r0,#0x14
                        str     r5,[r0]
                        adr     r0,Packed_Data+4
                        str     r5,[r0]
                        adr     r5,Packed_Ptr
                        ldr     r0,[r5]
                        add     r0,#1
                        str     r0,[r5]
Top_Range:              pop     {r0,r2,pc}
Check_Fix_Range3:       add     r3,r6
                        mov     r0,r11
Check_Fix_Range2:       add     r0,r0
                        add     r3,r0
Check_Fix_Range:        push    {r1,r2,r4,lr}
                        ldr     r5,Range
                        lsr     r5,#11
                        ldrh    r0,[r3]
                        mov     r4,r0
                        mul     r0,r5
                        adr     r5,Range
                        ldr     r1,Packed_Data+4
                        cmp     r0,r1
                        bls     Range_Lower
                        str     r0,[r5]
                        LD162   r0,#KBITMODELTOTAL
                        sub     r0,r4
                        lsr     r0,#KNUMMOVEBITS
                        add     r4,r0
                        bl      Get_Code2
                        mov     r0,#0
                        pop     {r1,r2,r4,pc}
Range_Lower:            sub     r1,r0
                        adr     r2,Packed_Data+4
                        str     r1,[r2]
                        ldr     r2,[r5]
                        sub     r2,r0
                        str     r2,[r5]
                        ldrh    r0,[r3]
                        lsr     r0,#KNUMMOVEBITS
                        sub     r4,r0
                        bl      Get_Code2
                        mov     r0,#1
                        pop     {r1,r2,r4,pc}
                        .arm
                        .align  4
Packed_Size_Arm9:       .long   0
Arm9_Depacked_Address:  .long   0
Table_State:            .byte   0,0,0,0
                        .byte   4-3,5-3,6-3,7-3,8-3,9-3
                        .byte   10-6,11-6
                        .align  4
Range:                  .long   -1
Rep_3:                  .long   1
Rep_2:                  .long   1
Rep_1:                  .long   1
Packed_Ptr:             .long   0
Packed_Data:
