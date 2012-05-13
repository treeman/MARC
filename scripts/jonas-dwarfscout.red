;name Dwarf Scout
;description Will dwarf bomb, and flee if it spots any changes.
;author Jonas Hietala

dist        EQU start-160               ; how for ahead of us will the carpet be laid
csize       EQU 8                       ; carpet size
copydist    EQU 3783                    ; when we flee, how far?
length      EQU last-start
bombstep    EQU 3

start       MOV watcher, watch          ; reset watch vector
            MOV #csize, len1
laycarp     MOV carpet,<watch           ; lay a carpet to watch
len1        DJN laycarp,#csize

            MOV bombloc,bombjmp         ; restore jmp vector for bomber
            SPL bomber                  ; split out a dwarf bomber

scan        MOV watcher, watch          ; reset watch vector
            MOV #csize, len2            ; reset cmp for loop
scancarp    CMP carpet, <watch          ; check for intruders
            JMP evacuate                ; something happened!!
len2        DJN scancarp, #csize        ; keep checking the length of carpet
            JMP scan

evacuate    MOV last, bombjmp           ; kill our bomber, we're running out of time!
            MOV #0, last                ; reset last pointer
            MOV #last + copydist, new   ; reset new pointer
            MOV #length, len3           ; reset prog length
            MOV @last, @new             ; copy over whole program
copy        MOV <last, <new
len3        DJN copy, #length

new         SPL @0,last + copydist      ; and split there (acts as a jump)

bomber      MOV #last+1,bomb            ; setup bomb vector
dobomb      ADD #bombstep, bomb         ; add in bombstep
            MOV bomb, @bomb             ; bomb
bombjmp     JMP dobomb                  ; continue to bomb

bombloc     JMP -2                      ; bomb jmp backup
bomb        DAT #0,#last+1              ; bomb

carpet      DAT #237,#986               ; our inique id to lay down
watcher     DAT #dist,#dist             ; where to place our carpet
watch       DAT #0,#0                   ; where are we watching?

last        DAT #0

