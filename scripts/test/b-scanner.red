; name B-scanner
const   EQU 2237
init    EQU scan

scan    ADD #const, @2
        JMZ scan, @ptr      ; hit here
throw   MOV jmp_i, @ptr
ptr     MOV spl_i, <init+ptr
redo    JMN scan, scan
spl_i   SPL 0, 0
        MOV dat_i, <-1
jmp_i   JMP -1, 0
dat_i   END scan

