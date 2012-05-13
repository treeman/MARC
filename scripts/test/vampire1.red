;name Vampire 1

const   EQU 2365

loc     MOV ptr, ptr
        ADD #const, ptr
        SUB #const, loc
        JMP loc

ptr     JMP @0, trap

trap    SPL 1, -100
        MOV bomb, <-1
        JMP trap
bomb    DAT #0

