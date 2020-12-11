function mysize,data
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; returns number of elements of array data
; Sulian THUAL IMARPE-IRD 2008
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
datasize=size(data,/n_elements)
;
return,datasize
;
end