function rms,in
; note : change by sulian 2008: m=mean before loop
; note : change by sulian 2009 : ne procede pas les NaN values
;
if ((where(finite(in,/NAN)))(0) ne -1) then begin
if ((where(finite(in)))(0) eq -1) then begin
;only NaN values
;print,'function mean : only NaN values, returning NaN'
s=myNaN()
endif else begin
; remove NaN values in data
;print,'function mean : detected NaN values, rms on finite part'
newin=in(where(finite(in)))
n=n_elements(newin)
m=mean(newin)
s=0
for i=0.,n-1. do s=s+(newin(i)-m)^2
s=sqrt(s/n)
;
endelse
endif else begin
; normal case, no NaN values
n=n_elements(in)
m=mean(in)
s=0
for i=0.,n-1. do s=s+(in(i)-m)^2
s=sqrt(s/n)
endelse
;
return,s
end