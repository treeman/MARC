;name Vampire 2

const   EQU 2365

        SPL 0
vamp    MOV ptr, @ptr
        ADD data, ptr
        DJN vamp, <2339

ptr     JMP trap, ptr

trap    SPL 1, -100
        MOV data, <-1
        JMP -2
data    DAT #const, #-const

