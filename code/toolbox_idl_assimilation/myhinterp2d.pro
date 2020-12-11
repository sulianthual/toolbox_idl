function myhinterp2d,xgrid,ygrid,xgridm,ygridm,maskm
compile_opt hidden
; 
; get function H for 2d interpolation (ENKF)
; Sulian 2011
;
; getHinterp2d : retourne matrice H de y=Hx, qui est une interpolation de grille 2d vers grille 2d restreinte
; On suppose x defini sur xgrid, ygrid sans badvalues (X=champ(nx,ny) reforme en nx*ny)
; On suppose y defini sur xgridm,ygridm mais avec certains elements badvalues non utilises
;
; Inputs:
; -xgrid: grille x de X (modele): on suppose X=champ(nx,ny) qui est reforme pour analyse en nx*ny
; -ygrid: grille y de X( modele)
; -xgridm: grille x de Y (obs): on suppose Y=champ(nxm,nym) avec des badvalues 
; -ygridm: grille y de Y (obs)
; -maskm: mask (nxm,nym) (=.. good, =NaN bad) pour les elements de Y a garder: 
;         dans analyse on reforme Y en mvec <= nxm*nym enlevant les badvalues
;
; Output:
;
; -retourne H(mvec,nvec) avec nvec=nx*ny, mvec <=nxm*nym selon le nombre de badvalues
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; grille X
nx=size(xgrid,/n_elements)
ny=size(ygrid,/n_elements)
nvec=nx*ny
;
; grille Y (complete)
nxm=size(xgridm,/n_elements)
nym=size(ygridm,/n_elements)
mgood=where(finite(maskm) ne 0)
mvec=size(mgood,/n_elements)
;
; Precompute virtual suscripts
vsx=myvirtualsubscript(xgridm,xgrid)
vsy=myvirtualsubscript(ygridm,ygrid)
;
; Calcul H pour grille Y complete
HH=fltarr(mvec,nvec)
for ivec=0,nvec-1 do begin
; yi=sumj ( hij * xj )
; donc hiJ=(H*XJ)i avec XJ=0 si j.ne.J, 1 si j=J
XJ=fltarr(nvec) & XJ(ivec)=1.; interpolation valeur 1. et 0. autour
XJ=reform(XJ,[nx,ny])
YJ=bilinear(XJ,vsx,vsy)
YJ=reform(YJ,nxm*nym)
; garde slmt elmts good
YJ=YJ(mgood)
HH(*,ivec)=YJ
endfor
;
HH=transpose(HH); TRANSPOSE CF MATRIX CONVENTION IDL
;
return,HH


end