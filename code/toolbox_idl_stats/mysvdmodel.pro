function mysvdmodel,field1,pattern1,pattern2,pcs1,pcs2,cutoff=cutoff

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Function for recomposition of field using entry file and SVD model, 
;computed from precedent call to mysvd2d.pro
;  Sulian Thual, IRD-IMARPE 2008
;
; field1 = input field (assumed to be (len1,time) ), on a new time period.
; pattern1  = patterns of SVD model (len1,cutoff), on the field entry side.
; pattern2  = patterns of SVD model (len2,cutoff), on the field output side.
; pcs1  =  pcs of SVD model (time,cutoff), on the field entry side.
; pcs2  =  pcs of SVD model (time,cutoff), on the field output side.
; cutoff (optionnal)=  If set, gives the number of SVDs modes to retain for recomposition. 
;                      Must be <= cutoff from precedent call to mysvd2d.pro
;                      Elsewhere cutoff is taken accordingly to size of pattern and pcs,
;                      wich must agree. 
;
; CALLING SEQUENCE :
;
; field2=mysvdmodel(field1,pattern1,pattern2,pcs1,pcs2,cutoff)
;
; NOTES :
;
; - For comparison with (H.Bjornoss & S.A Venegas-A Manual for EOF and SVD analyses of Climatic Data)
;   Imagine IDL shows a matrix A(i,j) with i being the number of COLUMNS, and j the number of ROWS.
;   Therefore the usual matrix multiplication is ## instead of #.
; - Amelioration : field1, pattern1 & pattern2 ne doivent plus etre forcements de dimensions 2d.
;                  la routine fait un reform.
; - Il faut s'assurer que le cutoff est le meme pour tous les champs (le nombre de modes), A moins 
;   que l'on definisse un nouveau cutoff qui soit inferieur aux precedents.
; - Il faut s'assurer que pcs1 et pcs2 ont memes dimension en temps.
; - Il faut s'assurer que le temps est la derniere variable dans l'ordre des dimensions.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; pass data to other variables
data1=field1 
pat1=pattern1
pat2=pattern2
pc1=pcs1
pc2=pcs2
;
; reform data
dims1=size(data1,/n_dimensions)
ndims1=size(data1,/dimensions)
if (dims1 gt 2) then begin
data1=reform(data1,product(ndims1(0:dims1-2)),ndims1(dims1-1),/overwrite)
endif
;
dims1x=size(pat1,/n_dimensions)
ndims1x=size(pat1,/dimensions)
if (dims1x gt 2) then begin
pat1=reform(pat1,product(ndims1x(0:dims1x-2)),ndims1x(dims1x-1),/overwrite)
endif
;
dims2x=size(pat2,/n_dimensions)
ndims2x=size(pat2,/dimensions)
if (dims2x gt 2) then begin
pat2=reform(pat2,product(ndims2x(0:dims2x-2)),ndims2x(dims2x-1),/overwrite)
endif
;
; definition of cutoff
if keyword_set(cutoff) then begin
cuts=cutoff
endif else begin
cuts=ndims1x(dims1x-1)
endelse
;
; controls on dimensions ( a faire plus tard)
;
; cutoff
pat1=pat1(*,0:cuts-1)
pat2=pat2(*,0:cuts-1)
pc1=pc1(*,0:cuts-1)
pc2=pc2(*,0:cuts-1)
;
; computing standard deviations of pcs1,pcs2
stddev1=make_array(cuts)
for pin=0,cuts-1 do begin
stddev1(pin)=stddev(pc1(*,pin))
endfor
stddev2=make_array(cuts)
for pin=0,cuts-1 do begin
stddev2(pin)=stddev(pc2(*,pin))
endfor
;
; expansion coefficients from new field1 (by projecting on basis pattern1 of SVD model)
expand1=transpose(data1) # pat1
;
; Passing from basis pattern1 to basis pattern2 of SVD model with stddev factors:
; (You must make the hipothesis of high correlation between pcs1 and pcs2).
for pin=0,cuts-1 do begin
if (stddev1(pin) ne 0.) then begin
expand1(*,pin)=stddev2(pin)/stddev1(pin)*expand1(*,pin)
endif else begin
print,' mysvdmodel : warning, sttdev1=0 for nw=',pin+1
endelse
endfor
;
; reconstruction of field2 :
field2=transpose(expand1) ## pat2

;
; reform of field2 (if previously reformed, see beginning) 
dims2=size(field2,/dimensions)
nt2=dims2(1)
field2=reform(field2,[ndims2x(0:dims2x-2),nt2],/overwrite)
;
print,'      '
print,'MYSVDMODEL :'
print,'nt2=  ',nt2
if (1 eq 1) then begin
print,'field1 range',min(data1),max(data1)
print,'size field1',size(data1,/dimensions)
print,'field2 range',min(field2),max(field2)
print,'size field2',size(field2,/dimensions)
print,'pat1 range',min(pat1),max(pat1)
print,'size pat1',size(pat1,/dimensions)
print,'pat2 range',min(pat2),max(pat2)
print,'size pat2',size(pat2,/dimensions)
print,'pc1 range',min(pc1),max(pc1)
print,'size pc1',size(pc1,/dimensions)
print,'pc2 range',min(pc2),max(pc2)
print,'size pc2',size(pc2,/dimensions)
print,'expand1 range',min(expand1),max(expand1)
print,'size expand1', size(expand1,/dimensions)
endif

;
return,field2
;
end



