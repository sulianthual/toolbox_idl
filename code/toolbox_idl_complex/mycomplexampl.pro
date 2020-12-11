function mycomplexampl,field
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne l amplitude pour un champ complexe
;  Sulian Thual 2011
;
; INPUT PARAMETERS :
;
;
;  ampl=mycomplexampl(field)
; 
; NOTES :
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

ampl=abs(field)
return,ampl

end