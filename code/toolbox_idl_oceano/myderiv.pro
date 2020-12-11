function myderiv,field0,xgrid0,dx0
;
; ATTENTION SURTOUT NE PAS UTILISER LE SPLINE (DEGEULASSE !). A ENLEVER
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sulian Thual, 2011, Lima
;
; Retourne la derivee d un champ field sur xgrid,sachant que pour ameliorer
; le calcul de la derivee on definit un step dx fin. Le programme se fait par les etaps:
; - interpolation de field de xgrid vers une grille reguliere (de step dx)
; - derivation sur la grille reguliere
; - reinterpolation sur xgrid
;
; field et xgrid doivent etre reguliers
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; eventuelles erreurs
field=field0 & xgrid=xgrid0 & dx=dx0 
field=reform(field) & xgrid=reform(xgrid) & dx=abs(dx)
;
; define grille reg
nxr=float((max(xgrid)-min(xgrid))/dx)+3
xr=findgen(nxr)*dx+min(xgrid)-dx
;
; interpolation (spline optionnel)
ifield=myinterpol(field,xgrid,xr)
;
; derivation
difield=deriv(xr,ifield)
;
; reinterpolation (sans spline)
dfield=myinterpol(difield,xr,xgrid)



return,dfield
;
end