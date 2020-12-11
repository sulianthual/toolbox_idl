function mygridy
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for defining axis y (latitude) from SODA_1.4.2 with IDL :
;  Sulian Thual, IRD-IMARPE 2008
;
; NO INPUTS
;
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
gridy=0.5*findgen(46)-11.25
;
return,gridy
end