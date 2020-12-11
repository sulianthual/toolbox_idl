function mycovariance,field1,field2
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne la covariance
;  Sulian Thual 2011
;
; INPUT PARAMETERS :
;
; field1 : input field, with form field(*,*,*,time).       
; field2 : input field, forme field(time) meme dim pour le time
; 
; OUPUT: retourne covar(*,*,*) des dims de field1, auquel on a fait covarier avec la serie field2
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

data1=field1
myreform1,data1,dims,prod,time
data2=field2 & data2=reform(data2)
mdata2=mean(data2)
;
n1=prod & nt=time
covariatee=make_array(n1)
;
for pi1=0.,n1-1. do begin
pass=reform(data1(pi1,*))
mdata1=mean(pass)
covariatee(pi1)=mean( (pass-mdata1)*(data2-mdata2)   )
endfor
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,covariatee,dims(0:ndims-2) else covariatee=reform(covariatee)

return,covariatee


end