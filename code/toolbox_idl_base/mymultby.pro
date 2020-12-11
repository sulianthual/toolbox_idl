function mymultby,field,coefficient

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; On veut juste multiplier tous les elements d un champ par un coefficient
; Seulement quelque fois le coefficient est un vecteur dim 1 dans IDL, et dans ce cas IDL fait un produit matriciel
; Ce programme fait tout simplement la multiplication en evitant ce probleme

;  Sulian Thual, mai 2010
;
;; entre : field(*,*,*,*,...) 
;         coefficient (1 element, dimension quelquonque
; sortie : fieldmutl(*,*,*,*,*...)=field *coefficient         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
data=field
coeff=coefficient
for ii=0,size(data,/n_elements)-1 do begin
data(ii)=data(ii)*coefficient
endfor

return,data
















end


