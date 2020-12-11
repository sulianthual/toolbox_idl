function mylodcaxyback,fieldin,fieldmodif0,indomain,onlyx=onlyx,tampon=tampon
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; POUR UN CHAMP domaine complet non modifie et un champ modifie sur domaine interieur reduit 
; renvoie le champ domaine complet avec le domaine interieur reduit modifié
; Rq on peut eventuellement faire du nudging pour harmoniser les conditionshors domaine interieur reduit

; Sulian Thual 2011
;
; INPUT:
;
; fieldin: champ non modifie (x,y,*,*) avec deux premieres variables x et y sur grille domaine complet
;         remarque on peut avoir toutes les derniers dimensions possibles
;
; fieldmodif0: champ modifie (xin,yin,*,*) avec deux premieres variables x et y sur grille domaine interieur reduit
;         remarque on peut avoir toutes les derniers dimensions possibles, mais doivent correspondre a fieldin
;
; indomain: donne les coords du domaine reduit [imin,imax,jmin,jmax] dans le domaine complet
;
; OUTPUT:
;
; fieldout: champ (x,y,****) domaine complet avec les modifications effectuees
;
; KEYWORD:
; 
; /onlyx: pour faire slmt sur x, ie champ (x,*,*) et (xin,*,*) en entree, champ (x,*,*) en sortie
;
; tampon=[imint,imaxt,jmint,jmaxt]: si mis, donne une zone (plus petite que indomain) pour definir la zone 
;        tampon. A l interieur de tampon on met fieldmodif0, et a l interieur de indomain (et outside tampon)
;        on fait un nudging, le coefficient alpha de nudging etait 1 a la frontiere de tampon et 0 a la frontiere
;        de indomain.
;
; BEWARE: ne pas mettre de champ (x,y,1) ou (x,y,1,*,*) car le reform va les endommager !!!!!
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
if keyword_set(onlyx) then begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAS AKBM (79?***)=(x,***) mais pas dimension y presente
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
if (nrest eq 0) then begin; slmt X
fieldout=fieldin
fieldout(imin:imax)=fieldmodif0
; nudging ici ...
endif
;
if (nrest gt 0) then begin; autres dims que X 
fieldout=fieldin
fieldmodif=fieldmodif0
fieldout=myswitch(fieldout,[indgen(nrest)+2,1]); met x a la fin
fieldmodif=myswitch(fieldmodif,[indgen(nrest)+2,1]); met x a la fin
dims=[dims(1:1+nrest-1),nx]; a prioris nouvelles dimensions fieldout
fieldout=reform(fieldout,[(product(dims(0:nrest-1))),nx]); reform (*,x)
fieldmodif=reform(fieldmodif,[(product(dims(0:nrest-1))),nxred]); reform (*,x)
fieldout(*,imin:imax)=fieldmodif(*,*); modifie partie interieure
fieldmodif=0.; memory
fieldout=reform(fieldout,[dims(0:nrest-1),nx])
fieldout=myswitch(fieldout,[ndims,indgen(nrest)+1]); remet x au debut
endif




endif else begin

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAS HBM (79,116,***) = (x,y,****) en sortie
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
fieldout=fieldin
fieldout(imin:imax,jmin:jmax)=fieldmodif0(*,*)
; nudging ici ...
endif
;
if (nrest gt 0) then begin; autres dims que X et Y
fieldout=fieldin
fieldmodif=fieldmodif0
fieldout=myswitch(fieldout,[indgen(nrest)+3,1,2]); met x et y a la fin
fieldmodif=myswitch(fieldmodif,[indgen(nrest)+3,1,2]); met x et y a la fin
dims=[dims(2:2+nrest-1),nx,ny]; a prioris nouvelles dimensions fieldout
fieldout=reform(fieldout,[(product(dims(0:nrest-1))),nx,ny]); reform (*,x,y)
fieldmodif=reform(fieldmodif,[(product(dims(0:nrest-1))),nxred,nyred]); reform (*,x,y)
fieldout(*,imin:imax,jmin:jmax)=fieldmodif(*,*,*); modifie la partie au milieu
fieldmodif=0.; memory
; nudging ici ...
fieldout=reform(fieldout,[dims(0:nrest-1),nx,ny])
fieldout=myswitch(fieldout,[ndims-1,ndims,indgen(nrest)+1]); remet x et y au debut
endif
;
endelse

return,fieldout



end