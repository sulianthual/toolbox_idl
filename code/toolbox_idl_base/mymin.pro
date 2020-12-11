function mymin,in
compile_opt hidden
; Sulian THUAL IRD 2009
; pour pouvoir faire un min sur une serie avec des badvalues NaN
;
if ((where(finite(in,/NAN)))(0) ne -1) then begin
if ((where(finite(in)))(0) eq -1) then begin
;only NaN values
;print,'function max : only NaN values, returning NaN'
mmx=myNaN()
endif else begin
; remove NaN values in data
;print,'function mean : detected NaN values, mean on finite part'
mmx=min(in(where(finite(in))))
endelse
endif else begin
; normal case, no NaN values
mmx=min(in)
endelse
;
return,mmx
end
