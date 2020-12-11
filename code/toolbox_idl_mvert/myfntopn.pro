
function myfntopn,Fn0,zgrid0,hmix0,dz0


;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Sulian THUAL 2011 Lima
;
; A partir d'un profil vertical Fn(z) sur zgrid (de 0 a -H avec H le bottom de l ocean)
; et de hmix profondeur de la couche de melange (hmix=50. en general), donne le Pn correspondant
; dz est le step utilise (1m est ok) pour faire le calcul de la derivee verticale
;
; remarque si Fn est de dim 2 on suppose que n est sur la derniere dimension 
; et on retourne tous les Pn en vecteur
;
; Badvalues NaN dans Fn
; Si Fn(z<Hgood)=NaN en entree le calcul se fait de z=0 a z=-Hgood pour l integration
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
Fn=Fn0 & zgrid=zgrid0 & hmix=hmix0 & dz=dz0
;
Fn=reform(Fn) & dim=size(Fn,/n_dimensions)
H=min(zgrid) & Hsurf=0.

if (dim gt 2) then stop

if (dim eq 1) then begin
ff=Fn
; restriction a premiere badvalue
nz=size(ff,/n_elements)
if ((where(finite(ff) eq 0))(0) ne -1) then Hg=(where(finite(ff) eq 0))(0) else Hg=nz
ff=ff(0:Hg-1) & zgrid=zgrid(0:Hg-1)
; calcul Pn
Pn=myintegral(ff,zgrid,-hmix,Hsurf,dz)/hmix/myintegral(ff*ff,zgrid,H,Hsurf,dz)
return,Pn
endif

if (dim eq 2) then begin
nz=(size(Fn,/dimensions))(0)
ncn=(size(Fn,/dimensions))(1)
Pn=fltarr(ncn)
for icn=0,ncn-1 do begin
ff=reform(Fn(*,icn))
nz=size(ff,/n_elements)
if ((where(finite(ff) eq 0))(0) ne -1) then Hg=(where(finite(ff) eq 0))(0) else Hg=nz
ff=ff(0:Hg-1) & zgrid=zgrid(0:Hg-1)
Pn(icn)=myintegral(ff,zgrid,-hmix,Hsurf,dz)/hmix/myintegral(ff*ff,zgrid,H,Hsurf,dz)
endfor
return,Pn
endif


;
end
