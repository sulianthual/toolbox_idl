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
; CAS champ (x,***) mais pas dimension y presente
;
dims=size(fieldin,/dimensions)
nx=dims(0)
ndims=size(fieldin,/n_dimensions)
nrest=ndims-1; dimensions restantes apres X
imin=myscalar(indomain(0)) & imax=myscalar(indomain(1)) & nxred=abs(imax-imin)+1
;
; calcul coefficient alpha(nx) pour le nudging dans le domain total
if keyword_set(tampon) then begin; coeff nuding=coeff alpha(x,y) dans indomain
imint=myscalar(tampon(0)) & imaxt=myscalar(tampon(1)) & nxt=abs(imaxt-imint)+1
alphacoeff=fltarr(nx); coefficient de nuding dans le domain total
alphacoeff(imint:imaxt)=1.; dans zone tampon (< indomain)
alphacoeff(imin:imint)=findgen(imint-imin+1)/float(imint-imin); gauche
alphacoeff(imaxt:imax)=1.-findgen(imax-imaxt+1)/float(imax-imaxt); droite
endif else begin; pas de zona tampon, alpha=1 dans indomain, 0 ailleurs
alphacoeff=fltarr(nx); coefficient de nuding dans le domain total
alphacoeff(imin:imax)=1.; dans indomain 
endelse
;
if (nrest eq 0) then begin; slmt X
fieldout=fieldin
fieldout(imin:imax)= $
alphacoeff(imin:imax)*fieldmodif0 + $
(1.-alphacoeff(imin:imax))*fieldout(imin:imax)
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
ipass=(size(fieldout,/dimensions))(0)
for ii=0,ipass-1 do begin
fieldout(ii,imin:imax)= $
alphacoeff(imin:imax)*fieldmodif(ii,*) + $
(1.-alphacoeff(imin:imax))*fieldout(ii,imin:imax)
endfor
fieldmodif=0.; memory
fieldout=reform(fieldout,[dims(0:nrest-1),nx])
fieldout=myswitch(fieldout,[ndims,indgen(nrest)+1]); remet x au debut
endif




endif else begin

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAS champ (x,y,****) en sortie
dims=size(fieldin,/dimensions)
nx=dims(0) & ny=dims(1)
ndims=size(fieldin,/n_dimensions)
nrest=ndims-2; dimensions restantes apres X et Y
imin=myscalar(indomain(0)) & imax=myscalar(indomain(1)) & nxred=abs(imax-imin)+1
jmin=myscalar(indomain(2)) & jmax=myscalar(indomain(3)) & nyred=abs(jmax-jmin)+1
;
; calcul coefficient alpha(nx,ny) pour le nudging dans le domain total
if keyword_set(tampon) then begin; coeff nuding=coeff alpha(x,y) dans indomain
imint=myscalar(tampon(0)) & imaxt=myscalar(tampon(1)) & nxt=abs(imaxt-imint)+1
jmint=myscalar(tampon(2)) & jmaxt=myscalar(tampon(3)) & nyt=abs(jmaxt-jmint)+1
alphacoeff=fltarr(nx,ny)
alphacoeff(imint:imaxt,jmint:jmaxt)=1.; dans zone tampon (< indomain)
for j=jmint,jmaxt do alphacoeff(imin:imint,j)=findgen(imint-imin+1)/float(imint-imin); gauche
for j=jmint,jmaxt do alphacoeff(imaxt:imax,j)=1.-findgen(imax-imaxt+1)/float(imax-imaxt); droite
for i=imint,imaxt do alphacoeff(i,jmin:jmint)=findgen(jmint-jmin+1)/float(jmint-jmin); bas
for i=imint,imaxt do alphacoeff(i,jmaxt:jmax)=1.-findgen(jmax-jmaxt+1)/float(jmax-jmaxt); haut
for i=imin,imint do begin; coins a gauche
apass=alphacoeff(i,jmint) & alphacoeff(i,jmin:jmint)=apass*findgen(jmint-jmin+1)/float(jmint-jmin); bas-gauche
apass=alphacoeff(i,jmaxt) & alphacoeff(i,jmaxt:jmax)=apass*(1.-findgen(jmax-jmaxt+1)/float(jmax-jmaxt)); haut-gauche
endfor
for i=imaxt,imax do begin; coins a droite
apass=alphacoeff(i,jmint) & alphacoeff(i,jmin:jmint)=apass*findgen(jmint-jmin+1)/float(jmint-jmin); bas-droite
apass=alphacoeff(i,jmaxt) & alphacoeff(i,jmaxt:jmax)=apass*(1.-findgen(jmax-jmaxt+1)/float(jmax-jmaxt)); haut-droite
endfor
endif else begin; pas de zona tampon, alpha=1 partour dans indomain
alphacoeff=fltarr(nx,ny); coefficient de nuding dans le domain total
alphacoeff(imin:imax,jmin:jmax)=1.; dans indomain 
endelse
;
if (nrest eq 0) then begin; slmt X et Y
fieldout=fieldin
fieldout(imin:imax,jmin:jmax)= $
alphacoeff(imin:imax,jmin:jmax)*fieldmodif0 + $
(1.-alphacoeff(imin:imax,jmin:jmax))*fieldout(imin:imax,jmin:jmax)
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
ipass=(size(fieldout,/dimensions))(0)
for ii=0,ipass-1 do begin
fieldout(ii,imin:imax,jmin:jmax)= $
alphacoeff(imin:imax,jmin:jmax)*fieldmodif(ii,*,*) + $
(1.-alphacoeff(imin:imax,jmin:jmax))*fieldout(ii,imin:imax,jmin:jmax)
endfor
fieldmodif=0.; memory
; nudging ici ...
fieldout=reform(fieldout,[dims(0:nrest-1),nx,ny])
fieldout=myswitch(fieldout,[ndims-1,ndims,indgen(nrest)+1]); remet x et y au debut
endif
;
endelse

return,fieldout



end