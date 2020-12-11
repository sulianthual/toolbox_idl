function mysvdrec2d,pattern,pcs,cutoff=cutoff

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Function for recomposition of 2d field from SVD results, from precedent call to mysvd2d.pro
;  Sulian Thual, IRD-IMARPE 2008
;
; pattern  =  input array containing patterns for field (lon,lat,cutoff)
; pcs   =  input array containing pcs for field (time,cutoff)
; cutoff (optionnal)=  If set, gives the number of SVDs modes to retain for recomposition. 
;                      Must be <= cutoff from precedent call to mysvd2d.pro
;                      Elsewhere cutoff is taken accordingly to size of pattern and pcs,
;                      wich must agree. 
;
; CALLING SEQUENCE :
;
; field=mysvdrec2d(pattern,pcs,cutoff)
;
; NOTES :
;
; - Note that field is of dimensions (lon,lat,time)
; - For comparison with (H.Bjornoss & S.A Venegas-A Manual for EOF and SVD analyses of Climatic Data)
;   Imagine IDL shows a matrix A(i,j) with i being the number of COLUMNS, and j the number of ROWS.
;   Therefore the usual matrix multiplication is ## instead of #.
;
; - NOTE IMPORTANTE : BUG, garde pcs1 et pattern1 en retour en les changeants.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
ndims=size(pattern,/dimensions)
n1=ndims(0)
n2=ndims(1)
nw=ndims(2)
;
ndimst=size(pcs,/dimensions)
nt=ndimst(0)
nw2=ndimst(1)
;
if keyword_set(cutoff) then begin
cuts=cutoff
if (cutoff gt nw) then begin
print,'mysvdrecompo2d : cutoff > nw(pattern), returning'
return,0
endif
if (cutoff gt nw2) then begin
print,'mysvdrecompo2d : cutoff > nw(pcs), returning'
return,0
endif
endif else begin
cuts=nw
if (nw ne nw2) then begin
print,'mysvdrecompo2d : nw(pattern) ne nw(pcs), returning'
return,0
endif
endelse
;
pattern=reform(pattern,n1*n2,nw,/overwrite)
;
pattern=pattern(*,0:cuts-1)
pcs=pcs(*,0:cuts-1)
;
; in case cutoff=1 take care degenerated dimension nw is not removed.
pattern=reform(pattern,n1*n2,cuts,/overwrite)
pcs=reform(pcs,nt,cuts,/overwrite)
; transpose (to concord with H.Bjornoss & S.A Venegas formalism)
pattern=transpose(pattern,[1,0])
pcs=transpose(pcs,[1,0])
;
field= pcs ## transpose(pattern)
field=reform(field,n1,n2,nt,/overwrite)
;
return,field
end



