;name Suck on this!
;description A clever vampire which will make you bomb for it, and it will start bombing itself as well. Will also change stuff in memory to screw your code.

decoy   EQU 1337                ; fill mem with random numbers
step    EQU 211
mem     EQU start - 2000        ; we will change B op in memory with DJN from here

start   SPL 0                   ; process generator, necessary for we will go into
                                ; our trap sometimes
vamp    MOV ptr, @ptr           ; lay our fang
        ADD stepp, ptr          ; add in offset
        DJN vamp, <mem          ; DJN bomb

ptr     JMP trap, ptr

trap    SPL 1, -100             ; suck the life out of them
        MOV bomb, <trap         ; make them bomb for us
        JMP trap                ; forever...

bomb    DAT #decoy,#-decoy      ; lay out decoys to defeat anti-vampires
stepp   DAT #step,#step

