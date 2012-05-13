;name Paper 3

cnt  EQU dt - src

init SPL 1
     MOV -1, 0
     SPL 1          ; Create 6 on-line processes

src MOV #cnt, 0

    MOV <src, <dst
dst SPL @0, #1222
    MOV dt, <-1
    JMZ src, src
    MOV 0, -1
dt  END init

