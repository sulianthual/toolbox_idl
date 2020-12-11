function mymean,field,NaN=NaN,keep=keep
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne le mean sur la derniere dimension du champ
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,*,*,time).       
; NaN keyword : si mis, mean seulement sur la partie sans NaN
; CALLING SEQUENCE :
;
; keyword:
;
; -keep: si mis, garde memes dimensions de la matrice, ie fill dimension time avec le mean
;
;  fieldmean=mymean(field)
; 
; NOTES :
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;
n1=prod & nt=time
fieldmean=make_array(n1)
if (size(data,/type) eq 6) then fieldmean=complexarr(n1); cas particulier complexe
;
; calcul champ mean
for pi1=0.,n1-1. do begin
pass=reform(data(pi1,*))
if keyword_set(NaN) then begin
isgood=where(finite(pass) eq 1)
if (isgood(0) ne -1) then begin
pass=pass(isgood)
endif else begin
pass=myNaN()
endelse
endif
fieldmean(pi1)=mean(temporary(pass))
endfor
;
; reform sortie, forme matrice originale ou une dimension en moins
if keyword_set(keep) then begin

for pi1=0.,n1-1. do begin
data(pi1,*)=fieldmean(pi1)
endfor
fieldmean=temporary(data)
myreform2,fieldmean,dims

endif else begin

data=0.
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,fieldmean,dims(0:ndims-2) else fieldmean=reform(fieldmean)

endelse

; return
return,fieldmean
;
end










