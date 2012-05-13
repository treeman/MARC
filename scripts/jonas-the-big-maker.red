;name The big maker
;description A vampire which spawns dwarfs and an imp.
;author Jonas Hietala

bombstep    EQU 4

firstdwarf  EQU 2431
dwarfstep   EQU 793

pitbomb     EQU dwarf - 100
djnbomb     EQU vamp - 1
impstart    EQU decoy + 10

            JMP boot

; description of a dwarf
dwarf       ADD #bombstep, bomb
            MOV bomb, @bomb
            JMP dwarf
bomb        DAT #1,#1

; an imp!
imp         MOV 0,1

; decoy
            DAT #1,#1
            DAT #1,#1
            DAT #1,#1
            DAT #1,#1
            DAT #1,#1
            DAT #1,#1

; launch out 3 dwarfs
boot        MOV bomb, <dwarfcp1     ; launch out a dwarf
            MOV bomb-1, <dwarfcp1
            MOV bomb-2, <dwarfcp1
            MOV bomb-3, <dwarfcp1

            MOV bomb, <dwarfcp2     ; launch out a dwarf
            MOV bomb-1, <dwarfcp2
            MOV bomb-2, <dwarfcp2
            MOV bomb-3, <dwarfcp2

            MOV bomb, <dwarfcp3     ; launch out a dwarf
            MOV bomb-1, <dwarfcp3
            MOV bomb-2, <dwarfcp3
            MOV bomb-3, <dwarfcp3

; launch an imp
            MOV imp, impstart
            SPL @0, impstart

; add processes to dwarfs
dwarfcp1    SPL @0, firstdwarf
dwarfcp2    SPL @0, firstdwarf + dwarfstep
dwarfcp3    SPL @0, firstdwarf + 2 * dwarfstep

            SPL 0                   ; process generator

; vampire bomber
vamp        MOV fang, @fang
            ADD fangstep, fang
            DJN vamp, <djnbomb
fang        JMP pit, fang

fangstep    DAT #-3*bombstep, #-3*bombstep

pit         SPL 1, pitbomb          ; trap processes here
            MOV decoy, <pit         ; make them bomb for us
            JMP pit

decoy       DAT #1,#1

end

