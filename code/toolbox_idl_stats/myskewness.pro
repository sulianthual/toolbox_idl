function myskewness,field
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne la weighted skewness =m3/m2
;  Sulian Thual, IRD-IMARPE 2008
;
; cf article Dewitte Thual 2009 pour la definition
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,*,*,time).       
;
; CALLING SEQUENCE :
;
;
;  var(x,y,....)=myskewness(field(x,y,....,t))
; 
; NOTES :
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;
n1=prod & nt=time
stdev=make_array(n1)
if (size(data,/type) eq 6) then stdev=complexarr(n1); cas particulier complexe
;
for pi1=0.,n1-1. do begin
aa=reform(data(pi1,*))
m2a=m2(aa)
m3a=m3(aa)
stdev(pi1)=m3a/m2a
endfor
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,stdev,dims(0:ndims-2) else stdev=reform(stdev)

return,stdev

end