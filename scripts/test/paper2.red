;name Paper 2
cnt EQU lst-src ; number of code in paper

src MOV #cnt, 0 ; source pointer 
    MOV <src, <dst ; copy the code... 
    JMN -1, src ; once at a time 
dst SPL @0, 1222 ; destination pointer 
    SUB #23, dst ; give more distance to next copy 
    JMZ src, src ; redo 
lst END src

