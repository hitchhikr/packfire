; ------------------------------------------
; PackFire
; - Disable interrupts
; - Switch the processor into supervisor mode
; ------------------------------------------

                        org     0
            
                        movem.l d0-a3/a5/a6,-(a7)
                    IFD ATARI
                        clr.l   -(a7)                           ; supervisor level
                        move.w  #32,-(a7)
                        trap    #1
                        addq.l  #6,a7
                        move.l  d0,-(a7)
                        move.w  (VID_COLOR_0).w,-(a7)
                    ENDC
                    IFD X68000
                        clr.l   -(a7)
                        DOS     _SUPER                          ; previous SSP will be located in the stack
                        move.l  d0,(a7)
                    ENDC
                        move.w  sr,-(a7)
                        move.w  #$2700,sr                       ; disable interrupts (& stay in supervisor mode)
