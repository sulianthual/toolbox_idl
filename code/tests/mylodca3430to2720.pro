function mylodca3430to2720,fieldin
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR PASSER CHAMP sur grille technique du modele (34,30) a grille physique (27,20)
; c est le cas de la SLA, SST, etc... en sortie dans les history (attention 34,30 est pour x,y) 
; Sulian Thual 2011
;
; INPUT:
;
; filein: champ (x,y,*,*) avec deux premieres variables x et y sur grille (34,30)
;         remarque on peut avoir toutes les derniers dimensions possibles
;
; OUTPUT:
;
; fileout: champ (x,y,*,*) avec deux premieres variables x et y sur grille (27,20)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; grille technique
;xgridl=findgen(34)*11.25/2.+101.25 & nxl=34
;ygridl=findgen(30)*2.-29. & nyl=30; 

; grille physique restreinte
;xgridr=findgen(27)*5.625+101.25+5.625*5 & nxr=27
;ygridr=findgen(20)*2-19 & nyr=20
;
dims=size(fieldin,/dimensions)
ndims=size(fieldin,/n_dimensions)
nrest=ndims-2; dimensions restantes apres X et Y
;
;
if (nrest eq 0) then begin; slmt X et Y
fieldout=fieldin(5:5+27-1,5:5+20-1)
endif
;
if (nrest gt 0) then begin; autres dims que X et Y
fieldout=fieldin
fieldout=myswitch(fieldout,[indgen(nrest)+3,1,2]); met x et y a la fin
dims=[dims(2:2+nrest-1),34,30]; a prioris nouvelles dimensions
fieldout=reform(fieldout,(product(dims(0:nrest-1))),34,30); reform (*,x,y)
fieldout=fieldout(*,5:5+27-1,5:5+20-1); restreint espace
fieldout=reform(fieldout,[dims(0:nrest-1),27,20])
fieldout=myswitch(fieldout,[ndims-1,ndims,indgen(nrest)+1]); remet x et y au debut
endif


return,fieldout



end