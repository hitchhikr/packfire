; ------------------------------------------
; PackFire
; Jump to original entry point
; ------------------------------------------

                        org     0

                    IFD X68000
Start:
                        add.l   #0,a4           ; entry point offset
                        jmp     (a4)
                    ENDC
