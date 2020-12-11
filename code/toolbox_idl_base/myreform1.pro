Pro myreform1,field,dimensions,product,time
compile_opt hidden
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for reforming any field with form field(A,time), where
; A is the product of the first dimensions
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : field to be reformed
;
; OUTPUTS :
; dimensions : initial dimensions of field, to save for future call to myreform2.pro
; product : product of (n-1) first dimensions of field, ie size of new dimension A
; time : size of last dimensions time.
;
; NOTE ; if field is an array, it is reformed with form field(0,time).
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
ndims=size(field,/n_dimensions)
dimensions=size(field,/dimensions)
;
if (ndims eq 0) then begin
print,'myreform1 : field is scalar, returning'
return
endif
;
if (ndims eq 1) then begin
field=reform(field,1,dimensions(0),/overwrite)
product=1
time=dimensions(0)
endif else begin
field=reform(field,product(dimensions(0:ndims-2)),dimensions(ndims-1),/overwrite)
product=product(dimensions(0:ndims-2))
time=dimensions(ndims-1)
endelse
;
end
