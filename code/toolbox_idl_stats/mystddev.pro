function mystddev,field
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne la standard deviation (sqrt de la variance)
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,*,*,time).       
;
; CALLING SEQUENCE :
;
;
;  var(x,y,....)=mystddev(field(x,y,....,t))
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
stdev(pi1)=stddev(reform(data(pi1,*)))
endfor
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,stdev,dims(0:ndims-2) else stdev=reform(stdev)

return,stdev

end