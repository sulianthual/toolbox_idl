function mynino3,field,xgrid,ygrid
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne indice nino3 de field
;  Sulian Thual 2011
;
; INPUT PARAMETERS :
;
; field : input field, with form field(.....,x,y): utiliser myswitch eventuellemt tq x,y dernieres dims
; xgrid et ygrid axis de field en deg lon et deg lat
;

; retourne n3(...) gardant les autres dims
; 
; RQ: si field a des NaN values elles seront detectees et enlevees du calcul de moyenne
; rq: peut aussi utiliser myswitch, myfindcoord(/between) et mymean(/NaN) pour faire cette operation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
imin=myfindcoord(210.,xgrid) & imax=myfindcoord(270.,xgrid)
if (imin gt imax) then begin
pass1=imin & pass2=imax
imin=pass2 & imax=pass1
endif
;
jmin=myfindcoord(-5.,ygrid) & jmax=myfindcoord(5.,ygrid)
if (jmin gt jmax) then begin
pass1=jmin & pass2=jmax
jmin=pass2 & jmax=pass1
endif
;
ndims=size(field,/n_dimensions)
nrest=ndims-2; dimensions restantes apres X et Y
;
if (nrest lt 0) then begin; erreur
print,'mynino3 field doit etre dim 2 min'
stop
endif
;
if (nrest eq 0) then begin; slmt X et Y
n3field=field(imin:imax,jmin:jmax)
n3field=mymean(n3field,/NaN);avg Y
n3field=mymean(n3field,/NaN);avg X
endif
;
if (nrest gt 0) then begin; autres dims que X et Y
n3field=field
myreform1,n3field,dims,prod,dimy; met forme (****,y)
ndims=size(dims,/n_elements) 
n3field=mymean(n3field(*,jmin:jmax),/NaN); avg Y
n3field=reform(n3field,[product(dims(0:ndims-3)),dims(ndims-2)]); met forme (*****,X)
;ndims=size(dims,/n_elements) & myreform2,n3field,dims(0:ndims-2); met forme (*,*,*,X)
;myreform1,n3field,dims,prod,dimx; met forme (*****,x)
n3field=mymean(n3field(*,imin:imax),/NaN); avg X
myreform2,n3field,dims(0:ndims-3); met forme (*,*,*)
endif

return,n3field
;
end










