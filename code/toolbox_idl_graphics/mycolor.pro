Pro mycolor,newcolor,white=white,background=background
compile_opt hidden
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


; mycolor: choisit la couleur des plots ou des backgrounds
; Sulian Thual 2011


; si newcolor en entree, fait !p.color=newcolor : (newcolor doit etre entre 0 et 260 ?)
; si /white, fait newcolor=16777215 pour le blanc
; si /background, alors applique le changement de color au background

; si pas arguments en entree, fait du noir !p.color=0 pour le trace et du blanc pour le background
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;
if (n_params() eq 0) then begin
;
if keyword_set(white) then begin; special si veut obtenir le blanc
if keyword_set(background) then !p.background=16777215 else !p.color=16777215
endif else begin
!p.color=0
!p.background=16777215; par defaut sans arguments et sans keywords

endelse

endif else begin

if keyword_set(background) then !p.background=newcolor else !p.color=newcolor

endelse
;







end