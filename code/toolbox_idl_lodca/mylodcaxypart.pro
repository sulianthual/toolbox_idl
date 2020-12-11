function mylodcaxypart,fieldin,indomain,onlyx=onlyx
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR CHAMP lodca field(x,y,*,*,*) extrait fieldred sur indomain=[imin,imax,jmin,jmax]
; Sulian Thual 2011
;
; INPUT:
;
; filein: champ (x,y,*,*) avec deux premieres variables x et y sur grille
;         remarque on peut avoir toutes les derniers dimensions possibles
; 
; indomain: coords du domaine reduit
;
; OUTPUT:
;
; fileout: champ (x,y,*,*) avec deux premieres variables x et y sur grille reduite dans indomain (cas de SLA, HBM)
;
; KEYWORD:
;
; /onlyx: si mis alors on reduit slmt la dimension x, seul indomain(0) et indomain(1) comptent (cas de AKBM)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
if keyword_set(onlyx) then begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAS champ (x,***) mais pas dimension y presente, para exemple
;
dims=size(fieldin,/dimensions)
nx=dims(0)
ndims=size(fieldin,/n_dimensions)
nrest=ndims-1; dimensions restantes apres X
imin=myscalar(indomain(0)) & imax=myscalar(indomain(1)) & nxred=abs(imax-imin)+1
if (imin gt imax) then begin
pass=imin & imin=imax & imax=pass
endif

;
;
if (nrest eq 0) then begin; slmt X
fieldout=fieldin(imin:imax)
endif
;
if (nrest gt 0) then begin; autres dims que X 
fieldout=fieldin
fieldout=myswitch(fieldout,[indgen(nrest)+2,1]); met x a la fin
dims=[dims(1:1+nrest-1),nx]; a prioris nouvelles dimensions
fieldout=reform(fieldout,[(product(dims(0:nrest-1))),nx]); reform (*,x)
fieldout=fieldout(*,imin:imax); restreint espace
fieldout=reform(fieldout,[dims(0:nrest-1),nxred])
fieldout=myswitch(fieldout,[ndims,indgen(nrest)+1]); remet x et y au debut
endif




endif else begin
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAS champ = (x,y,****) a reduire sur x et y , par exemple
dims=size(fieldin,/dimensions)
nx=dims(0) & ny=dims(1)
ndims=size(fieldin,/n_dimensions)
nrest=ndims-2; dimensions restantes apres X et Y
imin=myscalar(indomain(0)) & imax=myscalar(indomain(1)) & nxred=abs(imax-imin)+1
if (imin gt imax) then begin
pass=imin & imin=imax & imax=pass
endif
jmin=myscalar(indomain(2)) & jmax=myscalar(indomain(3)) & nyred=abs(jmax-jmin)+1
if (jmin gt jmax) then begin
pass=jmin & jmin=jmax & jmax=pass
endif
;
;
if (nrest eq 0) then begin; slmt X et Y
fieldout=fieldin(jmin:jmax,jmin:jmax)
endif
;
if (nrest gt 0) then begin; autres dims que X et Y
fieldout=fieldin
fieldout=myswitch(fieldout,[indgen(nrest)+3,1,2]); met x et y a la fin
dims=[dims(2:2+nrest-1),nx,ny]; a prioris nouvelles dimensions
fieldout=reform(fieldout,[(product(dims(0:nrest-1))),nx,ny]); reform (*,x,y)
fieldout=fieldout(*,imin:imax,jmin:jmax); restreint espace
fieldout=reform(fieldout,[dims(0:nrest-1),nxred,nyred])
fieldout=myswitch(fieldout,[ndims-1,ndims,indgen(nrest)+1]); remet x et y au debut
endif
;
endelse

return,fieldout



end