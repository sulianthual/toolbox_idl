function mean2,in
;
if ((where(finite(in,/NAN)))(0) ne -1) then begin
if ((where(finite(in)))(0) eq -1) then begin
;only NaN values
;print,'function mean : only NaN values, returning NaN'
mmm=myNaN()
endif else begin
; remove NaN values in data
;print,'function mean : detected NaN values, mean on finite part'
mmm=total(in(where(finite(in))))/n_elements(in(where(finite(in))))
endelse
endif else begin
; normal case, no NaN values
mmm=total(in)/n_elements(in)
endelse
;
return,mmm
end
