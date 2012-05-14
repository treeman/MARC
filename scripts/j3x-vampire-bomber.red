;name Vampire bomber
;author Jesper Tingvall
;description Same as vampire but splits in start to cage, making this DAT 0 0 and JMP at the same time per default.

        SPL VAMP, 0
        JMP CAGE1, 0
        DAT 0,0
CAGE1   MOV -1, <-1
CAGE2   DJN CAGE1, -2
VAMP    ADD STEP, PTR
        SUB STEP, BOMB
        MOV BOMB, @PTR
        JMP VAMP, 0
PTR     JMP 150,150
STEP    DAT 5,5
BOMB    JMP CAGE1-148, 0