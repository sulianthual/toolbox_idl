function mycorremap,field1,field2

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for calculation of correlation map
;  Sulian Thual, IRD-IMARPE 2008
;
; Calculates time correlation between field(len,time) and field(len2,time) 
; time must be the last dimension
; field1 and field2 must be of same size and dimensions
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data1=field1
data2=field2
;
ndims=size(data1,/dimensions)
dims=size(data1,/n_dimensions)
data1=reform(data1,product(ndims(0:dims-2)),ndims(dims-1),/overwrite)
data2=reform(data2,product(ndims(0:dims-2)),ndims(dims-1),/overwrite)
;
cmap=make_array(product(ndims(0:dims-2)))
;
for pi1=0,product(ndims(0:dims-2))-1 do begin
cmap(pi1)=correlate(data1(pi1,*),data2(pi1,*))
endfor
;
cmap=reform(cmap,ndims(0:dims-2),/overwrite)
;
return,cmap
;
end