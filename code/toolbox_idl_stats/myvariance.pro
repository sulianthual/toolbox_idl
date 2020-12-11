function myvariance,field
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne la variance 
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,*,*,time).       
;
; CALLING SEQUENCE :
;
;
;  var(x,y,....)=myvar(field(x,y,....,t))
; 
; NOTES :
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;
n1=prod & nt=time
vari=make_array(n1)
;
for pi1=0.,n1-1. do begin
vari(pi1)=variance(reform(data(pi1,*)))
endfor
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,vari,dims(0:ndims-2) else vari=reform(vari)

return,vari

end