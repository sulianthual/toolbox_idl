function myisfinite,data
;
;;;;;;;;;;;;;;;;;;
;
; Returns 1 if data is entirely finite (no NaN values), 0 if not, with print of indice where not finite
; Sulian Thual IMARPE-IRD 2008
;
;;;;;;;;;;;;;;;;;;;;;
;
dims=size(data,/dimensions)
;
isfinite=finite(data)
wherenofinite=where(isfinite eq 0)
nnf=size(wherenofinite,/n_elements)
;
; if all finite
if (wherenofinite(0) eq -1) then begin
return,1
endif else begin
; if NaN values
;print,'myisfinite, NaN values'
return,0
endelse
;
end
