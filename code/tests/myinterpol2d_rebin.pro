function myinterpol2d_rebin,field,x,y,point,dorebin=dorebin
;
;;;;;;;;;;;;;;;
;
; interpole field(x,y) sur le point(x,y) 
; ; Retourne la valeur de field à la position point=[xpoint,ypoint]
; REMARQUE : x et y sont des champs 2D x(i,j) et y(i,j), avec field(i,j)
; Pour ne pas traiter les badvalues les mettre avec NaN
;
; Sulian Thual IMARPE IRD 2008
;;;;;;;;;;;;;;;;;
;
; methode du rebin : on augmente le nombre de points de x,y
; puis on prend la valeur la plus proche pour point
if keyword_set(dorebin) then begin
nx=(size(x,/dimensions))(0)
ny=(size(y,/dimensions))(1)
xr=rebin(x,dorebin*nx,dorebin*ny)
yr=rebin(y,dorebin*nx,dorebin*ny)
; Determination du point les plus proches(avec la grille(x,y) irreguliere, methode d²=min)
dcf1=(xr-point(0)) & dcf2=(yr-point(1)) & dist=dcf1*dcf1+dcf2*dcf2

mygraph
mycontour,dcf1
stop
xi=(array_indices([dorebin*nx,dorebin*ny], (where(dist eq min(dist)))(0),/dimensions))(0); first closest point taken
yi=(array_indices([dorebin*nx,dorebin*ny], (where(dist eq min(dist)))(0),/dimensions))(1); first closest point taken
print,xr(xi,yi)
print,yr(xi,yi)
; Copie des datas sur le point le plus proche
fieldr=rebin(field,dorebin*nx,dorebin*ny)
returnvalue=fieldr(xi,yi)
return,returnvalue
endif










end