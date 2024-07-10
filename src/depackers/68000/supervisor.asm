                    IFD ATARI
                        clr.l   -(a7)                           ; supervisor level
                        move.w  #32,-(a7)
                        trap    #1
                        addq.l  #6,a7
                        IFD RESTORE_USER_LEVEL
                            move.l  d0,-(a7)
                            move.w  sr,-(a7)
                            move.w  (VID_COLOR_0).w,-(a7)
                        ENDC
                        move.w  #$2700,sr                       ; disable interrupts
                    ENDC
                    IFD X68000
                        clr.l   -(a7)
                        dc.w    _SUPER                          ; previous SSP will be located in the stack
                        lea     MFP_IERA,a0
                        IFD RESTORE_USER_LEVEL
                            move.b  (a0),d0
                            move.w  d0,-(a7)
                            move.b  2(a0),d0
                            move.w  d0,-(a7)
                            move.w  (SPR_PAL0_DTA-MFP_IERA)(a0),-(a7)
                        ENDC
                        move.b  #%11110,(a0)
                        move.b  #%00001000,2(a0)
                    ENDC
