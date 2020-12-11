function myrmsmap,field


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for calculation of rms map of  field with form field(*,*,time)
;  Sulian Thual, IRD-IMARPE 2008
;
; NOTE : rms is done relative to last variable of field (supposed to be time)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
ndims=size(data,/dimensions)
dims=size(data,/n_dimensions)
;
data=reform(data,product(ndims(0:dims-2)),ndims(dims-1),/overwrite)
rmsmap=make_array(product(ndims(0:dims-2)))
;
for pi1=0.,product(ndims(0:dims-2))-1. do begin
rmsmap(pi1)=rms(data(pi1,*))
endfor
;
rmsmap=reform(rmsmap,ndims(0:dims-2),/overwrite)
;
return,rmsmap
;
end