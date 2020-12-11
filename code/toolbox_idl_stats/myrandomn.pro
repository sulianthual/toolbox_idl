function myrandomn,nens
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sulian Thual 2011
; Renvoie une distribution gaussienne de mean 0 et variance 1, avec nens elements
; on utilise un nouveau seed (assure undefined ici)
;
;distri=myrandomn(nens)=> distri gaussienne mean=0 et variance=1 avec nens elements
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; creation distribution nens membres
distri=randomn(seedundefined,nens)
;
; RQ : seedundefined est undefined dans cette fonction, donc on est asssure d avoir une nouvelle distribution

return,distri
;
end