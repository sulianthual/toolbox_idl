function mysavgol,field,dx,dh,order,degree
;
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; filtre de Savitzky-Golay sur un vecteur : pour filtrer le bruit ou deriver
;
; Sulian THUAL IMARPE-IRD 2008
;
; field : field(y,z,....x) : le filtre est effectue sur la derniere dimension de field
; dx : step de la grille xgrid de la derniere dimension de field. xgrid DOIT ETRE REGULIER
; dh : taille de la fenetre de filtrage (relativement a xgrid). Cette fenetre est centree, tandis qu'avec IDL
;      on peut alternativement choisir le nombre de points a droite/a gauche (voir savgol.pro)
; order : ordre du filtre. ordre=0 pour filtrer le bruit. ordre=1 pour calculer la derivee d'ordre 1. 
;         ordre=n pour la derivee d'ordre n (avec degree et la fenetre suffisamment grands)
; degree : ordre du polynome fité utilisé. degree=3 est une valeur typique, <3 smooth mais avec des 
;          biais possibles, >3 reduit les biais mais avec une resultat plus bruite
;          (doit etre <nleft+nright+1 ie taille de la fenetre dh)
;
;
; NOTES :
; - xgrid DOIT ETRE UNE GRILLE REGULIERE (interpoler sur une grille reguliere si necessaire)
; -field N'ACCEPTE PAS DE NaN VALUES
;
; EXEMPLE :
; field_sg=mysavgol(field,mygridstep(xgrid),mygridstep(xgrid)*20,0,3); filtre de field
; deriv_sg=mysavgol(field,mygridstep(xgrid),mygridstep(xgrid)*20,1,3); derivee de field a l ordre 1
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;
n1=prod & nt=time
data_sg=make_array(n1,nt)
;
if (finite(dx) eq 0) then begin
print,'mysavgol : dx=myNaN()'
return,myNaN()
endif
;
nleft=fix(dh/dx/2.) & nright=nleft
coeffs=savgol(nleft,nright,order,degree)
coeffs=coeffs*factorial(order)/(dx^order)
;
for pi1=0.,n1-1. do begin
data_sg(pi1,*)=convol(reform(data(pi1,*)),coeffs,/edge_truncate)
endfor
;
myreform2,data_sg,dims
return,data_sg
;
end