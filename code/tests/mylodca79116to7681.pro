function mylodca79116to7681,fieldin,akbm=akbm
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR PASSER CHAMP sur grille technique du modele (79,116) a grille physique (76,81)
; c est le cas de AKBM et HBM dans les history: note la grille "physique" est celle qui est "juste suffisante"
; pour reconstruire la SLA (27,20) par interpolation...
; Sulian Thual 2011
;
; INPUT:
;
; filein: champ (x,y,*,*) avec deux premieres variables x et y sur grille (79,116)
;         remarque on peut avoir toutes les derniers dimensions possibles
;
; OUTPUT:
;
; fileout: champ (x,y,*,*) avec deux premieres variables x et y sur grille (76,81)
;
; KEYWORD:
;
; /akbm: si mis alors champ entree est (x,***) sur (79,***) et on met en sortie champ (x,***) sur (76,***)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; grille technique
;xgridlp=findgen(79)*2.+124. & nxpl=79
;ygridlp=findgen(116)*0.5-28.75 & nypl=116

; grille physique restreinte
; NOTE: xgridrp=xgridlp(2:77) et ygridrp=ygridpl(18:98)
;xgridrp=findgen(76)*2.+128. & nxpr=76
;ygridrp=findgen(81)*0.5-19.75 & nypr=81
;

if keyword_set(akbm) then begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAS AKBM (79?***)=(x,***) mais pas dimension y presente
;
dims=size(fieldin,/dimensions)
ndims=size(fieldin,/n_dimensions)
nrest=ndims-1; dimensions restantes apres X
;
;
if (nrest eq 0) then begin; slmt X
fieldout=fieldin(2:77)
endif
;
if (nrest gt 0) then begin; autres dims que X 
fieldout=fieldin
fieldout=myswitch(fieldout,[indgen(nrest)+2,1]); met x a la fin
dims=[dims(1:1+nrest-1),79]; a prioris nouvelles dimensions
fieldout=reform(fieldout,[(product(dims(0:nrest-1))),79]); reform (*,x)
fieldout=fieldout(*,2:77); restreint espace
fieldout=reform(fieldout,[dims(0:nrest-1),76])
fieldout=myswitch(fieldout,[ndims,indgen(nrest)+1]); remet x et y au debut
endif




endif else begin
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAS HBM (79,116,***) = (x,y,****) a reduire sur x et y 
dims=size(fieldin,/dimensions)
ndims=size(fieldin,/n_dimensions)
nrest=ndims-2; dimensions restantes apres X et Y
;
;
if (nrest eq 0) then begin; slmt X et Y
fieldout=fieldin(2:77,18:98)
endif
;
if (nrest gt 0) then begin; autres dims que X et Y
fieldout=fieldin
fieldout=myswitch(fieldout,[indgen(nrest)+3,1,2]); met x et y a la fin
dims=[dims(2:2+nrest-1),79,116]; a prioris nouvelles dimensions
fieldout=reform(fieldout,[(product(dims(0:nrest-1))),79,116]); reform (*,x,y)
fieldout=fieldout(*,2:77,18:98); restreint espace
fieldout=reform(fieldout,[dims(0:nrest-1),76,81])
fieldout=myswitch(fieldout,[ndims-1,ndims,indgen(nrest)+1]); remet x et y au debut
endif
;
endelse

return,fieldout



end