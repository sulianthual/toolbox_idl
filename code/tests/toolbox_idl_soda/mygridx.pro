function mygridx,dgw=dgw,info=info
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for defining axis x (longitude) from SODA_1.4.2 with IDL :
;  Sulian Thual, IRD-IMARPE 2008
;
; NO INPUTS
;
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
gridx=2.5*findgen(66)+119.75
if keyword_set(info) then print,'mygridx, longitude grid from soda_1.4.2'
if keyword_set(dgw) then gridx(where(gridx gt 180.))=gridx(where(gridx gt 180.))-360.; set to degrees west
;
return,gridx
end