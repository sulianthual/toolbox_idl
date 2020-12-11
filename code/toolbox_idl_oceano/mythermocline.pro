function mythermocline,field,zgrid,isotemp,refine=refine

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Calcul la position de la thermocline sur temp, par interpolation bilineaire
; suppose que le champ de temperature est continu sur la verticale
; peut rechercher a la suite plusieurs isotherme (vecteur isotemp)
;
; Sulian Thual 2011

; field(*,*,*, z): field avec derniere dimension=depth sur laquelle rechercher.
; utiliser myswitch si derniere dimension=temps. Les bad values doivent etre NaN !

; zgrid: grille de depth associee (irreguliere ou non)
; isotemp : valeur a rechercher (20deg normallement)
;
; keyword refine : si mis, utilise la grille donnee par refine.
; interpole d abord le champ sur cette grille avant la recherche
; (mieux=utiliser grille reguliere genre refine=-findgen(300) )
;
; RETOURNE :
; thermocline (*,*,*,ntemp), avec ntemp taille du vecteur isotemp( nombre de valeurs a rechercher)
; si on donne une seule valeur, enleve dim degeneree et donne thermocline(*,*,*)
; 
;;;;;;;;;;;;;;;;;;;;;

; Examples :
;temp=myswitch(temp,[1,3,2])
;D20=mythermocline(temp,zgrid,20.)
;D20=mythermocline(temp,zgrid,20.,refine=-findgen(300.))
;
; Rq : on peut trouver autres applications
;
; - position de la X28 : isotherme X28 en supposant que fonction SST continue ouest en est
;   X28=mythermocline(sst,xgrid,28.)
;
; - centre de masse zonal : position depuis ouest tq compte 50% de la masse totale sur le bassin.
;   (la masse=eaux au dessus de la thermocline)
;   xpercent(i,kt)=mymean(reform(D20(0:i,kt)),/NaN)*i/(WWV(kt)*(nx-1))
;   xpercent=myswitch(xpercent,[2,1])
;   xpercent=mythermocline(xpercent,xgrid,0.5)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,depth
;
ntemp=size(isotemp,/n_elements)
;
n1=prod & nz=depth
thermocline=make_array(n1,ntemp)
;
; boucle sur chacune des isothermes recherchees
for itemp=0,ntemp-1 do begin
isotempsearch=isotemp(itemp)

for pi1=0.,n1-1. do begin
pass=reform(data(pi1,*))
; Garde partie sans NaN pour recherche
isgood=where(finite(pass) eq 1)
if (isgood(0) ne -1) then begin
passgood=pass(isgood)
zgridgood=zgrid(isgood)
; interpolation
if keyword_set(refine) then begin
zgridi=refine; choix utilisation nouvelle grille pour recherche
passgood=myinterpol(passgood,zgridgood,zgridi)
thermocline(pi1,itemp)=myinterpol(zgridi,passgood,isotempsearch)
endif else begin
thermocline(pi1,itemp)=myinterpol(zgridgood,passgood,isotempsearch); interpolation bilineaire de base
endelse
endif else begin
thermocline(pi1,itemp)=myNaN(); si aucune bonne value
endelse
; Valeurs extremes (>zgridmax ou <zgridmin) mis en NaN
if (thermocline(pi1,itemp) gt max(zgrid)) then thermocline(pi1,itemp)=myNaN()
if (thermocline(pi1,itemp) lt min(zgrid)) then thermocline(pi1,itemp)=myNaN()
endfor; pi1
;
endfor; itemp
;
; Reform
ndims=size(dims,/n_elements)
if (ndims gt 1) then begin 
;
if (ntemp eq 1) then begin
myreform2,thermocline,dims(0:ndims-2)
endif else begin
myreform2,thermocline,[dims(0:ndims-2),ntemp];
endelse
;
endif else begin
thermocline=reform(thermocline)
endelse

return,thermocline

end





