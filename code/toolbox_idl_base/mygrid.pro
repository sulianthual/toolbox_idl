function mygrid,dxstep,xmin,xmax
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Cree une grille en x rapidement (en float)
; Sulian Thual 2011
;
; INPUT:
; - dxstep: le step de la grille
; - xmin,xmax qui definit le min et max. La grille part de xmin et s arrete AVANT de depasser xmax
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; params de grille
nx=fix((xmax-xmin)/dxstep)+1

; grille (en float)
xgrid=findgen(nx)*dxstep+xmin

return,xgrid

end