; ------------------------------------------
; PackFire
; - Switch to user mode
; - Jump to the depacked code
; ------------------------------------------

                        ; restore interrupts
                        move.w  (a7)+,sr
                    IFD ATARI
                        move.w  (a7)+,(VID_COLOR_0).w
                        move.w  #32,-(a7)
                        trap    #1
                        addq.l  #6,a7
                    ENDC
                    IFD X68000
                        DOS     _SUPER
                        addq.l  #4,a7
                    ENDC
                        movem.l (a7)+,d0-a3/a5/a6
