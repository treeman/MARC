;name Earthworm Jim
;description Will setup a length 3 imp worm. Gogo!
;author Jonas Hietala

start   SPL second
        SPL third
        JMP imp
third   JMP imp+1
second  SPL fourth
        JMP imp+2
fourth  JMP imp+3
imp     MOV 0,1

end

