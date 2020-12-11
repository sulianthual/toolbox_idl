function myscalar,val
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; lorsque val vient d un array il peut rester en array de dimension 1
; ici prend le premier element de maniere scalaire
; Sulian THUAL IMARPE-IRD 2008
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=val[0]
;
return,data
;
end