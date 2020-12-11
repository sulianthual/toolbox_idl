Pro mylodcaputwind,fileout,taux,tauy,xgrid,ygrid,nointerpol=nointerpol
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR INTERPOLER ET ECRIRE LES VENTS EN FICHIER BINAIRE UTILISABLE PAR LODCA(Dewitte2000) 
; Sulian Thual 2011
;
; Inputs:
;
; -fileout: nom du fichier binaire (pour lodca) a ecrire
;
; -taux : tension vent zonale en N.m-2 , format (x,y,t)
;         les badvalues doivent etre en NaN !
;         REMARQUE: si le vent est mensuel, il faut MINIMUM deux pas de temps (tq lodca interpole, et car on reform dans idl)
;         REMARQUE: si le vent est a 10j, il faut MINIMUM trois pas de temps pour faire un mois
;         dans lodca on met les ANOMALIES/Clim de vent !
; 
; -tauy: tension vent meridienne en N.m-2 (format et taille identique a taux)
;         les badvalues doivent etre en NaN ! (utiliser myNaN() )
;
; -xgrid et ygrid: grille correspondante du vent en lon et lat
;
; Keyword:
;
; -nointerpol : si mis, suppose taux et tauy deja interpoles sur la grille lodca, donc pas d interpolation (peut etre plus rapide)
;               (ceci dit taux et tauy toujours en N.m-2 avec NaN ici)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Grille lodca vent
nxl=84 & xl=findgen(nxl)*2.+124.; Est=290E
nyl=30 & yl=findgen(nyl)*2.-29.
ntl=(size(taux,/dimensions))(2)
;
; Interpolation bilineaire, extrapolation hors-equateur
; Remarque : normallement il faudrait convertir les grilles en metres
;
if keyword_set(nointerpol) then begin
txl=taux
tyl=tauy
endif else begin
txl=fltarr(nxl,nyl,ntl)
tyl=fltarr(nxl,nyl,ntl)
vsxl=myvirtualsubscript(xl,xgrid)
vsyl=myvirtualsubscript(yl,ygrid)
for kt=0,ntl-1 do begin
pass=taux(*,*,kt)
txl(*,*,kt)=bilinear(reform(pass),vsxl,vsyl)
pass=tauy(*,*,kt)
tyl(*,*,kt)=bilinear(reform(pass),vsxl,vsyl)
endfor
endelse
;
;
; Conversion N.m-2 vers dyne.cm-2 (1 N.m-2=10dyne.cm-2)
; et multiplication suplementaire par 100 attendue
txl=txl*10.*100.
tyl=tyl*10.*100.
;
; Badvalues pour lodca (de NaN vers 999.)
pass=where (finite(txl) eq 0)
if (pass(0) ne -1) then txl(pass)=999.
pass=where (finite(tyl) eq 0)
if (pass(0) ne -1) then tyl(pass)=999.
;
; Concatenation
txltyl=fltarr(nxl,nyl,2,ntl)
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
for kt=0,ntl-1 do begin
txltyl(i,j,0,kt)=txl(i,j,kt)
txltyl(i,j,1,kt)=tyl(i,j,kt)
endfor
endfor
endfor
txl=0. & tyl=0.
;
; Ecriture
mywritebin,fileout,txltyl,/x
;

end








