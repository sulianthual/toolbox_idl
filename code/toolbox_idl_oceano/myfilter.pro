function myfilter,field,pmin=pmin,pmax=pmax
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for low-pass or high-pass filtering of field with form field(*.. ,nt) with IDL :
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*...,time).
;
; pmin : minimum cutoff period (for lowpass filtering)
; For example if field is in month, to filter at 7 years do pmin=7. * 12. (12 month in a year).
; pmax : maximum cutoff period, relative to the field timescale. (for highpass filtering)
;      
; CALLING SEQUENCE :
;
; fieldfiltered=myfilter(field,pmin=2,pmax=4)
;
; NOTES : needs the function filter.pro
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod
;
; case lowpass
if (keyword_set(pmin) and ~keyword_set(pmax)) then begin
for pi1=0.,prod-1. do begin
data(pi1,*)=filter(data(pi1,*),pmin, /TIME, /LOWPASS)
endfor 
endif 
; case highpass
if (keyword_set(pmax) and ~keyword_set(pmin)) then begin
for pi1=0.,prod-1. do begin
data(pi1,*)=filter(data(pi1,*),pmax, /TIME, /HIGHPASS)
endfor 
endif 
; case bandpass
if (keyword_set(pmin) and keyword_set(pmax)) then begin
if (pmin gt pmax) then begin
print,'myfilter : pmin gt pmax, returning'
return,0
endif
for pi1=0.,prod-1. do begin
data(pi1,*)=filter(data(pi1,*),pmin,pmax, /TIME, /BANDPASS)
endfor 
endif
;
myreform2,data,dims
;
return,data
;
end



