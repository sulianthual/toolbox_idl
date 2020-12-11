Pro mylodcagetwind,filein,ntr,txl,tyl
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR LIRE LES VENTS DANS UN FICHIER BINAIRE UTILISABLE PAR LODCA(Dewitte2000) 
; Sulian Thual 2011
;
; Inputs:
;
; -filein: nom du fichier binaire (pour lodca) a lire
;
; -ntr : taille du fichier a lire (DOIT ETRE CONNU, et ne pas depasser la fin du binary)
;
; -taux : tension vent zonale
;         on la reconvertit en N.m-2, et met des badvalues NaN() la ou 999
;         il seront en revanche definis sur la grille lodca de vents
; 
; -tauy: tension vent meridienne 
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Rappel: grilles lodca
;xgridl=findgen(34)*11.25/2.+101.25
;ygridl=findgen(30)*2.-29.; (attention fichier history sur grille differente)
;xgridlwind=findgen(84)*2.+124.; Est=290E
;ygridlwind=findgen(30)*2.-29.

; Lecture
if (ntr le 1) then begin
txltyl=myreadbin(filein,[84,30,2])
endif else begin
txltyl=myreadbin(filein,[84,30,2],x=ntr)
endelse
ndims=size(txltyl,/n_dimensions); check si temps disparu
;
; Separation
if (ndims eq 3) then begin
txl=reform(txltyl(*,*,0)) & tyl=reform(txltyl(*,*,1))
endif else begin
txl=reform(txltyl(*,*,0,*)) & tyl=reform(txltyl(*,*,1,*))
endelse

; badvalues inverse
pass=where (finite(txl) eq 999.)
if (pass(0) ne -1) then txl(pass)=myNaN()
pass=where (finite(tyl) eq 999.)
if (pass(0) ne -1) then tyl(pass)=myNaN()

; Conversion inverse vers N.m-2
txl=txl/10./100.
tyl=tyl/10./100.
;

end








