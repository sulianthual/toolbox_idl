function myisofrommap,field,xgrid,ygrid,iso,doexact=doexact
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Retourne coordonnnees des points d un isocontour  d un champ 2d
; Sulian Thual 2011
;
; input: 
; -field(i,j): le champ 2d
; -xgrid,ygrid: grille de field
; -iso: la valeur de l isocontour desire
; -keyword doexact: methode mass center pour position point dans carre grille (sinon methode simple=mis au centre)
;
; output: X=(x,y) de dimension n pour n points trouves. x et y sont les coords des points trouves.
;
; methode: 
;- premierement on cherche iso en chaque point exactement: si oui on a un point n.
;-puis, sur chaque carre de grille, on cherche si l isocontour passe a l interieur. 
;- Si c est le cas on aura un point (x,y) dans ce carre dans la position est a approximer
;-Pour voir cela,on regarde si iso est present sur les 4 segments (ex: x1<iso<x2 sur un segment).
;  Attention, cela ne peut pas etre egal a x1 ou x2 sinon on a deja trouve la position
;-on peut avoir de 1 a 4 presences, mais certains cas sont impossibles. 
;-il y a 1 cas special, avec 4 presences on a deux points dans le carre de grille
; -puis on interpole: La methode est tres approximee, si on trouve un point (ou deux)
;  il est mis au milieu du carre. Si on veut des valeurs plus precises il faut une grille plus raffinee.
; -on peut utiliser la methode de mass center avec doexact keyword !
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
nx=size(xgrid,/n_elements)
ny=size(ygrid,/n_elements)
xexact=transpose(fltarr(2)+myNaN()); vecteur (x,y) initialisation

; Recherche des points iso exactement sur la grille
; et Extension du vecteur des points isocontour
isexact=where(field eq iso)
if (isexact(0) ne -1) then begin
nexact=size(isexact,/n_elements)
for ie=0,nexact-1 do begin
ixy=array_indices([nx,ny],isexact(ie),/dimensions)
ix=xgrid(ixy(0)) & iy=ygrid(ixy(1))
xexact=[ [xexact] , transpose([ix,iy]) ]
endfor
endif

; Recherche des segments traverses par l isocontour
; utiliser une grille intercalee nx-1,ny et une grille intercalee nx,ny-1
; si existe, on met sa coordonnee tout simplement au milieu du carre (possible de raffiner ce script ensuite)
fieldxm=field(0:nx-2,*) & fieldxp=field(1:nx-1,*) & fieldxseg=intarr(nx-1,ny)
xcross=where( ((fieldxm lt iso) and (fieldxp gt iso)) or ((fieldxm gt iso) and (fieldxp lt iso)) ); segments horizontaux
fielxm=0. & fielxp=0. & if (xcross(0) ne -1) then fieldxseg(xcross)=1
fieldym=field(*,0:ny-2) & fieldyp=field(*,1:ny-1) & fieldyseg=intarr(nx,ny-1)
ycross=where( ((fieldym lt iso) and (fieldyp gt iso)) or ((fieldym gt iso) and (fieldyp lt iso)) ); segments verticaux
fielym=0. & fielyp=0. & if (ycross(0) ne -1) then fieldyseg(ycross)=1
;mycontour,fieldxseg,levels=[-0.5,0.5,1.5]

; Compte nombre de segments traverses pour un carre de grille:
;verif toujours 2 ou 4 segments; segcount=nombre de segments coupes par isocontour sur carre de grille
segcount=intarr(nx-1,ny-1)
segcount=segcount+fieldxseg(*,0:ny-2)+fieldxseg(*,1:ny-1)
segcount=segcount+fieldyseg(0:nx-2,*)+fieldyseg(1:nx-1,*)
;mycontour,segcount,levels=[-0.5,0.5,1.5,2.5,3.5,4.5]

; Check nombre segments traverses=0,2 ou 4 car autres cas impossibles
isbad=where( (segcount eq 1) or (segcount eq 3) ); ne peut avoir 1 ou 3 segments !, isocontour doit rentrer et sortir !
if (isbad(0) ne -1) then print,'myisofrom2d: mauvais carres de grilles a 1 ou 3 segments traverses par isocontour'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; trouve coords x et y : methode quick ou mass center
;
; methode quick
if ~keyword_set(doexact) then begin
; Extension du vecteur des points isocontour: point au centre de grille
isinside=where( (segcount eq 2) or (segcount eq 4) ) ;carres de grille traverses par isocontour
if (isinside(0) ne -1) then begin
ninside=size(isinside,/n_elements)
for ie=0,ninside-1 do begin
; get coords x-y du carre de grille
ixy=array_indices([nx-1,ny-1],isinside(ie),/dimensions)
; point au milieu du carre de grille
ix=0.5*( xgrid(ixy(0))+xgrid(ixy(0)+1) )
iy=0.5*( ygrid(ixy(1))+ygrid(ixy(1)+1) )
; extension vecteur points
xexact=[ [xexact] , transpose([ix,iy]) ]
endfor
endif
;
;method mass center
endif else begin

; masse center local sur 4 points de grille
; Extension du vecteur des points isocontour: point au centre de grille
isinside=where( (segcount eq 2) or (segcount eq 4) ) ;carres de grille traverses par isocontour
if (isinside(0) ne -1) then begin
ninside=size(isinside,/n_elements)
for ie=0,ninside-1 do begin
; get coords x-y du carre de grille
ixy=array_indices([nx-1,ny-1],isinside(ie),/dimensions)
; mass center sur 4 points  de 1/abs(field-iso)
fcarre=1./abs( field(ixy(0):ixy(0)+1,ixy(1):ixy(1)+1) - iso)
xcarre=xgrid(ixy(0):ixy(0)+1)
ycarre=ygrid(ixy(1):ixy(1)+1)
isoxycarre=mymasscenter(fcarre,xcarre,ycarre)
xexact=[ [xexact] , transpose( mymasscenter(fcarre,xcarre,ycarre) ) ]
endfor
endif

endelse
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Enleve les deux premiers points NaN
nexact=(size(xexact,/dimensions))(0)
if (nexact gt 1) then begin
xexact=xexact(1:nexact-1,*)
endif



return,xexact

end