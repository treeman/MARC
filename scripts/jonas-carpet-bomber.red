;name carpet bomber
;author Jonas Hietala

step    EQU -31

start   ADD #step,scan
scan    JMZ start,-100

bombit  MOV bomb, @scan
        MOV loop, <scan
        MOV move, <scan
        SPL @scan
        JMP start

move    MOV bomb, <bomb
loop    DJN move, bomb
bomb    DAT #0,#move

