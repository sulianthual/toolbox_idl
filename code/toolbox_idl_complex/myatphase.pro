function myatphase,field,phase
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Pour un champ complexe et une phase donnee, retourne la projection du champ a la phase donnee.
; Si le champ est a la phase donnee, on trouve son amplitude. 
;
; Pour W=A+iB=r*exp(is) voulu a la phase o, je retourne Re ( W*exp(-io) )
; Pour o=0, on trouve Re(W)
; Pour o=90(deg), on trouve Im(W)
; Pour o=180, on trouve -Re(W)
; Pour o=270, on trouve -Im(W)
; si s=o, je retourve Re(r) qui est l amplitude du champ
;
; field: le champ complexe
; phase requise: phase (donnee par exemple par mycomplexphase.pro)
; sortie: la projection du champ a la phase donnee (reel)
;
;  Sulian Thual 2011
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
jj=complex(0,1); le nombre complexe
;
data=field
for ii=0,size(data,/n_elements)-1 do begin
data(ii)=data(ii)*exp(-jj*phase)
endfor
data=real_part(data)

return,data

end