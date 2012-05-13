
DIST    equ 3999
b1      mov bbmb,@b2
b2      mov bbmb,@-100
        sub #6,b2
        jmp b1
bbmb    dat #DIST

