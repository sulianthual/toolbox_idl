function myrunkurt,field,wind,zeroborders=zeroborders

; Sulian THUAL oct 2009
; calcule le running kurtosis de f(t), etant donn� une fenetre wind (en indices, IMPAIR)
; renvoie fm(t) le resultat en fonction du temps (attention sur les bords quand on ne considere qu'une partie de la fenetre)
; si zeroborders est specifie, fm(t) est mis a zero lorque la fenetre n'est pas complete (sur les bords)

data=field; field doit etre avec une seule dimension
data=reform(data)
nt=size(data,/n_elements)
fm=make_array(nt)
wind=fix(wind); wind doit etre un entier
if (wind eq 2*fix(wind/2)) then begin; wind doit etre  impair
print,'myrunkurt error : wind non impair,return=0'
return,0
endif
;
for kt=0,nt-1 do begin
index=indgen(wind)-fix(wind/2)+kt
index=index(where (index ge 0)); remove bords
index=index(where (index le nt-1)); remove bords
index=index(sort(index))
fm(kt)=m4(data(index)); kurtosis= moment d'ordre 4 centre reduit
if keyword_set(zeroborders) then begin
if (size(index,/n_elements) ne wind) then fm(kt)=0
endif
endfor
;
;
return,fm

end