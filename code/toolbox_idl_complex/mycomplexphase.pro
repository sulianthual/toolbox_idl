function mycomplexphase,field,deg=deg
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne la phase pour un champ complexe
;  Sulian Thual 2011
;
; INPUT PARAMETERS :
;
; si keyword deg mis, retourne en degres
;
;  phase=myphase(field)
; 
; NOTES :
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
pi=mypi()
;phase=atan(imaginary(field),real_part(field)); faux pour domaine de atan !
phase=atan(field,/phase)

if keyword_set(deg) then phase=phase/pi*180.
return,phase

end