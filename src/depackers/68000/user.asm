                    IFD ATARI
                        IFD RESTORE_USER_LEVEL
                            move.w  (a7)+,(VID_COLOR_0).w
                            move.w  (a7)+,sr
                            move.w  #32,-(a7)
                            trap    #1
                            addq.l  #6,a7
                        ENDC
                    ENDC
                    IFD X68000
                        IFD RESTORE_USER_LEVEL
                            lea     MFP_IERA,a0
                            move.w  (a7)+,(SPR_PAL0_DTA-MFP_IERA)(a0)
                            move.w  (a7)+,d0
                            move.b  d0,2(a0)
                            move.w  (a7)+,d0
                            move.b  d0,(a0)
                            dc.w    _SUPER
                            addq.l  #4,a7
                        ENDC
                    ENDC
