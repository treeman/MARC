;name Cancer Vampire
;author Jesper Tingvall
;description Proof of concept Vampire, bombs memory forward with JMP instructions that traps PCs in a cage that DAT 0 0 bombs the memory backwards. Vampin' is slow a f***.

JMP     VAMP,          0
        DAT 0,         0
        DAT 0,         0
CAGE1   MOV -2,        <-2
CAGE    SPL 0,         <-3
        JMP CAGE1,     <-3
VAMP    ADD STEP,      PTR
        SUB STEP,      BOMB
        MOV BOMB,      @PTR
        JMP VAMP,      0
PTR     JMP 150,       150
STEP    DAT 5,         5
BOMB    JMP CAGE1-149, 0
