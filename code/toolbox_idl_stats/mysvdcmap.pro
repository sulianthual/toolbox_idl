function mysvdcmap,field,pcs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for calculation of correlation map of  SVD results, from previous call to mysvd.pro
;  Sulian Thual, IRD-IMARPE 2008
;
; Calculates correlation between field(len,time) and pcs(time) time serie for the SVD desired mode. 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
pc=pcs
;
ndims=size(data,/dimensions)
dims=size(data,/n_dimensions)
;
data=reform(data,product(ndims(0:dims-2)),ndims(dims-1),/overwrite)
cmap=make_array(product(ndims(0:dims-2)))
;
for pi1=0.,product(ndims(0:dims-2))-1. do begin
cmap(pi1)=correlate(data(pi1,*),pc(*))
endfor
;
cmap=reform(cmap,ndims(0:dims-2),/overwrite)
;
return,cmap
;
end