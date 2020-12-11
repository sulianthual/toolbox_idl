function mymonth,field,period
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
; period : new time period desired for the field. For example, if time variable for field is every 5 days,
;          set period=6 to put time variable in month (1 month = 30 days = period * 5-days= 6 * 5-days).
;          Note that period is positive integer normally.
;
; CALLING SEQUENCE :
;
; fieldmonth=mymonth(field,6)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;
n1=prod
nt=time & n_month=fix(nt/period)
;
if (period gt nt) then begin
print,'mymonth : period > nt, returning'
return,0
endif
;
onemonth=make_array(n1,period)
fieldmonth=make_array(n1,n_month)
;
for n=0,n_month-1 do begin
for pip=0,period-1 do begin
onemonth(*,pip)=data(*,n*period+pip)
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




