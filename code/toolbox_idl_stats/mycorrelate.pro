function mycorrelate,field1,field2
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne la correlation
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field1 : input field, with form field(*,*,*,time).       
; field2 : input field, memes dimensions que field1
;
; CALLING SEQUENCE :
;
;
;  varexpl(x,y,....)=mymean(field1(x,y,....,t),field2(x,y,....,t))
; 
; NOTES :
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;

data1=field1
myreform1,data1,dims,prod,time
data2=field2
myreform1,data2,dims,prod,time
;
n1=prod & nt=time
correlation=make_array(n1)
;
for pi1=0.,n1-1. do begin
correlation(pi1)=correlate(reform(data1(pi1,*)),reform(data2(pi1,*)))
endfor
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,correlation,dims(0:ndims-2) else correlation=reform(correlation)

return,correlation


end







