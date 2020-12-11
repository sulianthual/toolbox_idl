function myinterpol2d,field,xgrid,ygrid,xinterp,yinterp
compile_opt hidden
;
;;;;;;;;;;;;;;;
; Sulian Thual IRD-LEGOS-IMARPE janvier 2010
;
; interpole field(x,y) sur le point(x,y); methode bilineaire 
; field : champ (x,y) de dimension 2D sur grille x et y
; x : grille x, doit etre reguliere
; y : grille y, doit etre reguliere
; xinterp : point ou points des positions desirees sur la grille x
; yinterp : point ou points des positions desirees sur la grille y
;
; ; Retourne la valeur de field � la position(les positions) (xinterp,yinterp)
;
; REMARQUE :
; Pour ne pas traiter les badvalues les mettre avec NaN
;
; Sulian Thual IMARPE IRD 2008
;;;;;;;;;;;;;;;;;
; 
;
vsx=myvirtualsubscript(xinterp,xgrid)
vsy=myvirtualsubscript(yinterp,ygrid)
;
data=field & data=reform(data)
result=bilinear(data,vsx,vsy)
return,result






end