function myndims,field
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; returns number of dimensions of an array
; Sulian THUAL IMARPE-IRD 2008
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
ndims=size(field,/n_dimensions)
;
return,ndims
;
end