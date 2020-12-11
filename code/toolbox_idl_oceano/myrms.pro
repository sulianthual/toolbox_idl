function myrms,field
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne la rms sur la derniere dimension du champ
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,*,*,time).       
;
; CALLING SEQUENCE :
;
;
;  fieldmean=myrms(field)
; 
; NOTES :
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;

n1=prod & nt=time
fieldrms=make_array(n1)
;
for pi1=0.,n1-1. do begin
fieldrms(pi1)=rms(data(pi1,*))
endfor
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,fieldrms,dims(0:ndims-2) else fieldrms=reform(fieldmean)
return,fieldrms
;
end










