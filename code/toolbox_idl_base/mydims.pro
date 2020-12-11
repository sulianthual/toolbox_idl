function mydims,data,onedim
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; returns dimensions of array data
; Sulian THUAL IMARPE-IRD 2008
;
; if onedim is set, returns only the corresponding dimension (starting from one !!!)
;
; example : a=findgen(2,3)
; b=mydims(a)=> [2,3]
; b=mydims(a,1)=> 2 (first dimension)
; b=mydims(a,2)=> 3 (second dimension)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
dims=size(data,/dimensions)
;
if (n_params() eq 2) then begin
if (onedim gt size(dims,/n_elements)) then begin
print,'mydims : dimension out of range, returning'
return,0
endif else begin
dims=dims(onedim-1)
endelse
endif
;
return,dims
;
end