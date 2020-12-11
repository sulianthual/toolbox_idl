function myamean,field
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; retourne les anos au  mean (qui est sur la derniere dimension du champ)
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,*,*,time).       
;
; CALLING SEQUENCE :
;
;
;  fieldmean=myamean(field)
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
;
for pi1=0.,n1-1. do fieldmean(pi1)=mean(data(pi1,*))
for pit=0.,nt-1 do data(*,pit)=data(*,pit)-fieldmean
fieldmean=0
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,data,dims else data=reform(data)
return,data
;
end










