
cnt     EQU lst-src     ; number of code in paper

src     DAT #cnt        ; source pointer
dst     DAT #3000       ; destination pointer
pap     MOV #cnt, src   ; #cnt is number of lines to be copied
        MOV <src, <dst  ; copy a code...
        JMN -1, src     ; once at a time and
                        ; loop back until all lines copied
        SPL @dst        ; split the process to a new copy
        SUB #23, dst    ; give more distance to the next copy
        JMP pap         ; make other copies
lst END pap

