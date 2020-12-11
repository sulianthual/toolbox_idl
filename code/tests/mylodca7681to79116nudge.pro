function mylodca7681to79116nudge,fieldin,fieldmodif0,akbm=akbm
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; POUR UN CHAMP (79,116) non modifie et un champ (76,81) a l interieur modifie, renvoie le champ (79,116) avec 
; les conditions modifies. Pour la zone de (79,116),hors de (76,81) on peut eventuellement faire du nudging pour
; minimiser le choix de la modification avec les keywords

; Sulian Thual 2011
;
; INPUT:
;
; fieldin: champ non modifie (79,116,*,*) avec deux premieres variables x et y sur grille (79,116)
;         remarque on peut avoir toutes les derniers dimensions possibles
;
; fieldmodif0: champ modifie (76,81,*,*) avec deux premieres variables x et y sur grille (76,81)
;         remarque on peut avoir toutes les derniers dimensions possibles, mais doivent correspondre a fieldin
;
; OUTPUT:
;
; fieldout: champ (79,116,*,*)=(x,y,****) avec les modifications optimales 
;
; KEYWORD:
;
; nudgey=... : pour faire nudging en y (attention nudging en x semble difficile, on a slmt 3 points a gauche-droite)
; 
; /akbm: pour faire slmt sur x, ie champ (79,*,*) et (76,*,*) en entree, champ (79,*,*) en sortie
;
; BEWARE: ne pas mettre de champ (79,116,1,*) car le reform va les endommager !!!!!
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
if (nrest eq 0) then begin; slmt X
fieldout=fieldin
fieldout(2:77)=fieldmodif0
; nudging ici ...
endif
;
if (nrest gt 0) then begin; autres dims que X 
fieldout=fieldin
fieldmodif=fieldmodif0
fieldout=myswitch(fieldout,[indgen(nrest)+2,1]); met x a la fin
fieldmodif=myswitch(fieldmodif,[indgen(nrest)+2,1]); met x a la fin
dims=[dims(1:1+nrest-1),79]; a prioris nouvelles dimensions fieldout
fieldout=reform(fieldout,[(product(dims(0:nrest-1))),79]); reform (*,x)
fieldmodif=reform(fieldmodif,[(product(dims(0:nrest-1))),76]); reform (*,x)
fieldout(*,2:77)=fieldmodif(*,*); modifie partie interieure
fieldmodif=0.; memory
fieldout=reform(fieldout,[dims(0:nrest-1),79])
fieldout=myswitch(fieldout,[ndims,indgen(nrest)+1]); remet x au debut
endif




endif else begin

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CAS HBM (79,116,***) = (x,y,****) en sortie
dims=size(fieldin,/dimensions)
ndims=size(fieldin,/n_dimensions)
nrest=ndims-2; dimensions restantes apres X et Y
;
;
if (nrest eq 0) then begin; slmt X et Y
fieldout=fieldin
fieldout(2:77,18:98)=fieldmodif0(*,*)
; nudging ici ...
endif
;
if (nrest gt 0) then begin; autres dims que X et Y
fieldout=fieldin
fieldmodif=fieldmodif0
fieldout=myswitch(fieldout,[indgen(nrest)+3,1,2]); met x et y a la fin
fieldmodif=myswitch(fieldmodif,[indgen(nrest)+3,1,2]); met x et y a la fin
dims=[dims(2:2+nrest-1),79,116]; a prioris nouvelles dimensions fieldout
fieldout=reform(fieldout,[(product(dims(0:nrest-1))),79,116]); reform (*,x,y)
fieldmodif=reform(fieldmodif,[(product(dims(0:nrest-1))),76,81]); reform (*,x,y)
fieldout(*,2:77,18:98)=fieldmodif(*,*,*); modifie la partie au milieu
fieldmodif=0.; memory
; nudging ici ...
fieldout=reform(fieldout,[dims(0:nrest-1),79,116])
fieldout=myswitch(fieldout,[ndims-1,ndims,indgen(nrest)+1]); remet x et y au debut
endif
;
endelse

return,fieldout



end