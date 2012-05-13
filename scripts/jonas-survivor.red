;name Survivor
;description Will lay a carpet of data and if someone changes it the program will copy itself away and flee!
;author Jonas Hietala

dist        EQU start-100               ; how for ahead of us will the carpet be laid
csize       EQU 8                       ; carpet size
copydist    EQU 4000                    ; when we flee, how far?
length      EQU last-start

start       MOV watcher, watch          ; reset watch vector
            MOV #csize, len1
laycarp     MOV carpet,<watch           ; lay a carpet to watch
len1        DJN laycarp,#csize

scan        MOV watcher, watch          ; reset watch vector
            MOV #csize, len2            ; reset cmp for loop
scancarp    CMP carpet, <watch          ; check for intruders
            JMP evacuate                ; something happened!!
len2        DJN scancarp, #csize        ; keep checking the length of carpet
            JMP scan


evacuate    MOV #0, last                ; Reset last pointer
            MOV #last + copydist, new   ; Reset new pointer
            MOV #length, len3           ; Reset prog length
            MOV @last, @new             ; Copy over whole program
copy        MOV <last, <new
len3        DJN copy, #length

new         SPL @0,last + copydist      ; And split there (acts as a jump)

carpet      DAT #237,#986
watcher     DAT #dist,#dist
watch       DAT #0,#0

last        DAT #0

