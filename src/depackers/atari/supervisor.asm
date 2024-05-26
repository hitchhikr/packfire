                        clr.l   -(a7)                           ; supervisor level
                        move.w  #32,-(a7)
                        trap    #1
                        addq.l  #6,a7
                        IF RESTORE_USER_LEVEL == 1
                            move.l  d0,-(a7)
                            move.w  sr,-(a7)
                        ENDC
                        move.w  #$2700,sr                       ; disable interrupts
