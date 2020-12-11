function myimonth,field,periods
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for changing time scale (using mean on time) ,on field of form field(*,... ,nt) with IDL :
; Here use of mean to pass from days to month (new period Pnew > initial period Pini)
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,...,time).
; periods : ici on donne un vecteur donnant le nombre de points sur lequels moyenner :
;          si period=[6,6,6,...,7] on moyenne sur les 6 premiers pas de temps, les 6 suivants...
;          puis a la fin sur les 7 derniers pas de temps
;
; CALLING SEQUENCE :
;
; fieldmonth=myimonth(field,[6,6,6,6,7])
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;
n1=prod
nt=time 
n_month=size(periods,/n_elements)
fieldmonth=make_array(n1,n_month)
;
for n=0,n_month-1 do begin
ndays=periods(n)
if (n gt 0) then nanteriors=total(periods(0:n-1)) else nanteriors=0
onemonth=make_array(n1,ndays)
for pip=0,ndays-1 do begin
onemonth(*,pip)=data(*,nanteriors+pip)
endfor
for pi1=0.,n1-1. do begin
fieldmonth(pi1,n)=mean(onemonth(pi1,*))
endfor
endfor
;
if (size(dims,/n_elements) eq 1) then begin
fieldmonth=reform(fieldmonth); gets out degenerated dimension of clima
endif else begin
myreform2,fieldmonth,[dims(0:size(dims,/n_elements)-2),n_month]
endelse
;
return,fieldmonth
;
end




