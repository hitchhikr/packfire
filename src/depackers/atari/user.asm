                    IF RESTORE_USER_LEVEL == 1
                        move.w  (a7)+,sr
                        move.w  #32,-(a7)
                        trap    #1
                        addq.l  #6,a7
                    ENDC
