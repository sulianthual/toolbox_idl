function myloopfunc,funcname,vecfunc,p1in,p2in,p3in,p4in,p5in, _EXTRA=exkeys
;
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; loop une fonction sur des dimensions aditionnelles avec un wrapper
; Sulian Thual 2011
;
; INPUT:
;
; funcname: la fonction a appliquer
;
; vecfunc: vecteur de la taille du nombre arguments (de p1 a pn..) de forme  =nextra*[1,1,0,1,0]
;          [1,1,0,1,0] determine si les arguments p1 a pn sont field (avec extra dim) ou param (sans extra dim)
;          nextra est le nombre de dims en plus des field, 
;          toujours les dernieres dimensions (use myswitch pour adapter les fields)
;
; p1,...pn: les arguments (field et/ou parametres) de funcname: attention le nombre des arguments doit 
;           correspondre a la taille de vecfunc
;
; OUTPUT:
;
; le resultat de funcname, avec les dimensions additionnelles traitees (les dernieres dimensions)
;
; EXEMPLE:
;
; fieldi=onefunction(field1,x1,y1,x2,y2,/key1): onefunction is for example an interpolation from
; the 2D field field1 to fieldi, with grids param1-param2 to param3-param4 needded. Now suppose field1(x1,y1) has 
; extra dimensions depth z and time t and we want fieldi(x2,y2,z,t) with those dimensions. This wrapper just avoids escribing
; a loop on time and depth (which is like 6 lines of codes but soooo repetitive when done like five times every 
; day in climate sciences...). Just put: 
;
; fieldi=myloopfunc('onefunction',[2,0,0,0,0],field1,x1,y1,x2,y2,/key1)
;
; Here we just add [2,0,0,0,0] which means that first argument field1 has two extra (last) dimensions, 
; but the grids x1,y1,x2,y2 do not. Also keywords key1 can be passed directly.
; 
; RQ: voulait mettre keyword temporary pour enlever champs en entree, mais pas sur que ce soit correct 
; (temporary peut etre utiliser par funcname appele)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Reform des arguments de la fonction a appeler avec les dimensions field(product(p1bas),product(p1ex))
; les dimensions de chaque argument sont separables (p1bas,p1ex) avec p1bas les dimensions usuelles,
; et p1ex les dimensions extra. p1bas est different pour chaque argument (et =0 pour les scalaires), 
; en revanche p1ex est identique pour tous les argumenst field (avec extra dims) 
; et =0 pour tout les parametres (sans extra dims)
;
nargs=size(vecfunc,/n_elements)
;
; proceed p1
if (nargs ge 1) then begin
;if keyword_set(temporary) then p1=temporary(p1in) else p1=p1in; ajout possible ?
p1=p1in
p1dims=size(p1,/dimensions) & p1ndims=size(p1dims,/n_elements)
if(vecfunc(1-1) ne 0) then begin; if is a field with extra dims
nextra=vecfunc(1-1)
if (nextra ne p1ndims) then begin; if usual dims is vector
p1bas=p1dims(0:p1ndims-1-nextra) & p1ex=p1dims(p1ndims-nextra:p1ndims-1)
p1=reform(p1,[fix(product(p1bas)),fix(product(p1ex))],/overwrite)
dimex=p1ex; (re)set vector of extra dims
endif else begin; if usual dims is scalar
p1bas=0 & p1ex=p1dims(0:p1ndims-1)
p1=reform(p1,fix(product(p1ex)),/overwrite)
dimex=p1ex; (re)set vector of extra dims
endelse
endif 
endif
;
; proceed p2
if (nargs ge 2) then begin
p2=p2in
p2dims=size(p2,/dimensions) & p2ndims=size(p2dims,/n_elements)
if(vecfunc(2-1) ne 0) then begin; if is a field with extra dims
nextra=vecfunc(2-1)
if (nextra ne p2ndims) then begin; if usual dims is vector
p2bas=p2dims(0:p2ndims-1-nextra) & p2ex=p2dims(p2ndims-nextra:p2ndims-1)
p2=reform(p2,[fix(product(p2bas)),fix(product(p2ex))],/overwrite)
dimex=p2ex; (re)set vector of extra dims
endif else begin; if usual dims is scalar
p2bas=0 & p2ex=p2dims(0:p2ndims-1)
p2=reform(p2,fix(product(p2ex)),/overwrite)
dimex=p2ex; (re)set vector of extra dims
endelse
endif 
endif
;
; proceed p3
if (nargs ge 3) then begin
p3=p3in
p3dims=size(p3,/dimensions) & p3ndims=size(p3dims,/n_elements)
if(vecfunc(3-1) ne 0) then begin; if is a field with extra dims
nextra=vecfunc(3-1)
if (nextra ne p3ndims) then begin; if usual dims is vector
p3bas=p3dims(0:p3ndims-1-nextra) & p3ex=p3dims(p3ndims-nextra:p3ndims-1)
p3=reform(p3,[fix(product(p3bas)),fix(product(p3ex))],/overwrite)
dimex=p3ex; (re)set vector of extra dims
endif else begin; if usual dims is scalar
p3bas=0 & p3ex=p3dims(0:p3ndims-1)
p3=reform(p3,fix(product(p3ex)),/overwrite)
dimex=p3ex; (re)set vector of extra dims
endelse
endif 
endif
;
; proceed p4
if (nargs ge 4) then begin
p4=p4in
p4dims=size(p4,/dimensions) & p4ndims=size(p4dims,/n_elements)
if(vecfunc(4-1) ne 0) then begin; if is a field with extra dims
nextra=vecfunc(4-1)
if (nextra ne p4ndims) then begin; if usual dims is vector
p4bas=p4dims(0:p4ndims-1-nextra) & p4ex=p4dims(p4ndims-nextra:p4ndims-1)
p4=reform(p4,[fix(product(p4bas)),fix(product(p4ex))],/overwrite)
dimex=p4ex; (re)set vector of extra dims
endif else begin; if usual dims is scalar
p4bas=0 & p4ex=p4dims(0:p4ndims-1)
p4=reform(p4,fix(product(p4ex)),/overwrite)
dimex=p4ex; (re)set vector of extra dims
endelse
endif 
endif
;
; proceed p5
if (nargs ge 5) then begin
p5=p5in
p5dims=size(p5,/dimensions) & p5ndims=size(p5dims,/n_elements)
if(vecfunc(5-1) ne 0) then begin; if is a field with extra dims
nextra=vecfunc(5-1)
if (nextra ne p5ndims) then begin; if usual dims is vector
p5bas=p5dims(0:p5ndims-1-nextra) & p5ex=p5dims(p5ndims-nextra:p5ndims-1)
p5=reform(p5,[fix(product(p5bas)),fix(product(p5ex))],/overwrite)
dimex=p5ex; (re)set vector of extra dims
endif else begin; if usual dims is scalar
p5bas=0 & p5ex=p5dims(0:p5ndims-1)
p5=reform(p5,fix(product(p5ex)),/overwrite)
dimex=p5ex; (re)set vector of extra dims
endelse
endif 
endif
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Loop sur elements additionnels pour application de la fonction
;
; loop on each extra elements 

ndimex=product(dimex); size dim extra

for iex=0,ndimex-1 do begin
;
;;;;;;;;;;;;;;;;;;;;;
; Dans la loop, Reform des arguments de la fonction a appeler avec les dimensions usuelles

; proceed p1 in loop
if (nargs ge 1) then begin
if(vecfunc(1-1) ne 0) then begin
if (p1bas(0) ne 0) then p1i=reform(p1(*,iex),p1bas) else p1i=p1(iex); usual dims is vector or scalar
endif else begin
p1i=p1
endelse
endif
;
; proceed p2 in loop
if (nargs ge 2) then begin
if(vecfunc(2-1) ne 0) then begin
if (p2bas(0) ne 0) then p2i=reform(p2(*,iex),p2bas) else p2i=p2(iex); usual dims is vector or scalar
endif else begin
p2i=p2
endelse
endif
;
; proceed p3 in loop
if (nargs ge 3) then begin
if(vecfunc(3-1) ne 0) then begin
if (p3bas(0) ne 0) then p3i=reform(p3(*,iex),p3bas) else p3i=p3(iex); usual dims is vector or scalar
endif else begin
p3i=p3
endelse
endif
;
; proceed p4 in loop
if (nargs ge 4) then begin
if(vecfunc(4-1) ne 0) then begin
if (p4bas(0) ne 0) then p4i=reform(p4(*,iex),p4bas) else p4i=p4(iex); usual dims is vector or scalar
endif else begin
p4i=p4
endelse
endif
;
; proceed p5 in loop
if (nargs ge 5) then begin
if(vecfunc(5-1) ne 0) then begin
if (p5bas(0) ne 0) then p5i=reform(p5(*,iex),p5bas) else p5i=p5(iex); usual dims is vector or scalar
endif else begin
p5i=p5
endelse
endif
;
;;;;;;;;;;;;;;;;;;;;;
; Appel a la procedure 
;
if (n_elements(exkeys) eq 0) then begin
if (nargs eq 1) then fieldi=call_function(funcname,p1i); args=p1
if (nargs eq 2) then fieldi=call_function(funcname,p1i,p2i); args=p1,p2
if (nargs eq 3) then fieldi=call_function(funcname,p1i,p2i,p3i); args=p1,p2,p3
if (nargs eq 4) then fieldi=call_function(funcname,p1i,p2i,p3i,p4i); args=p1,p2,p3,p4
if (nargs eq 5) then fieldi=call_function(funcname,p1i,p2i,p3i,p4i,p5i); args=p1,p2,p3,p4,p5
endif else begin
if (nargs eq 1) then fieldi=call_function(funcname,p1i,_STRICT_EXTRA=exkeys); args=p1
if (nargs eq 2) then fieldi=call_function(funcname,p1i,p2i,_STRICT_EXTRA=exkeys); args=p1,p2
if (nargs eq 3) then fieldi=call_function(funcname,p1i,p2i,p3i,_STRICT_EXTRA=exkeys); args=p1,p2,p3
if (nargs eq 4) then fieldi=call_function(funcname,p1i,p2i,p3i,p4i,_STRICT_EXTRA=exkeys); args=p1,p2,p3,p4
if (nargs eq 5) then fieldi=call_function(funcname,p1i,p2i,p3i,p4i,p5i,_STRICT_EXTRA=exkeys); args=p1,p2,p3,p4,p5
endelse
p1i=0 & p2i=0 & p3i=0 & p4i=0 & p5i=0; memory
;
;;;;;;;;;;;;;;;;;;;;;
; Concatene results on field
dimfieldi=size(fieldi,/dimensions) 
if (dimfieldi(0) eq 0) then dimfieldi=1
npdimfieldi=fix(product(dimfieldi))
fieldi=reform(fieldi,npdimfieldi,/overwrite)
if (iex eq 0) then begin
field=make_array(npdimfieldi,ndimex)
field(*,iex)=temporary(fieldi)
endif else begin
field(*,iex)=temporary(fieldi)
endelse

endfor; iex loop
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

field=reform(field,[dimfieldi,dimex],/overwrite)
field=reform(field,/overwrite); remove degenerate dimensions

return,field

end