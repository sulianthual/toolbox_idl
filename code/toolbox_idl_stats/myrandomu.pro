function myrandomu,nens
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sulian Thual 2011
; Renvoie une distribution uniforme , avec nens elements
; on utilise un nouveau seed (assure undefined ici)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; creation distribution nens membres
distri=randomu(seedundefined,nens)
;
; RQ : seedundefined est undefined dans cette fonction, donc on est asssure d avoir une nouvelle distribution

return,distri
;
end
