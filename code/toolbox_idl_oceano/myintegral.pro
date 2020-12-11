function myintegral,field0,xgrid0,minx0,maxx0,dx0
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sulian Thual, 2011, Lima
;
; Retourne l integrale d un champ field sur xgrid,sachant que pour ameliorer
; le calcul de l integrale on definit un step dx fin. Le programme se fait par les etaps:
; - interpolation de field de xgrid vers une grille reguliere (de step dx)
;   note la grille reguliere est seulement definie entre minx-maxx et commence a minx
; - integrale sur la grille reguliere
;
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; eventuelles erreurs
field=field0 & xgrid=xgrid0 & minx=minx0 & maxx=maxx0 & dx=dx0 
field=reform(field) & xgrid=reform(xgrid) & dx=abs(dx)
;
; define grille reg (entre min et max) 
nxr=float((maxx-minx)/dx)+1
xr=dindgen(nxr)*dx+minx
if (xr(nxr-1) lt maxx) then xr=[xr,maxx]
;xr=xr(sort(xr))
;
; interpolate
ifield=myinterpol(field,xgrid,xr)
;
; integration
intifield=int_tabulated(xr,ifield,/double)
;


return,intifield
;
end