function myday,field,period,cycle=cycle
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for changing time scale (using mean on time) ,on field of form field(*,... ,nt) with IDL :
; Here use of interpolation to pass from month to day (new period Pnew < initial period Pini)
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,...,time).
; period : new time period desired for the field. For example, if time variable for field is every month(30 days),
;          set period=30 to put time variable in days (1 month = 30 days )
;          Note that period MUST BE POSTIVE INTEGER.
;          The initials time steps (month) are centered relative to new times steps : for example if entry is 
;          in month and output in days than we suppose month time step is on the 15th of the month.
; cycle : if keyword set, extends period like a cycle, interpolates and returns the middle period. 
;         This is VERY IMPORTANT
;         if you have a cycle (example a climatology), as the interpolation at beginning and end of period must 
;         be related (example on a year: conditons on december depends on conditions from january).
;         cycle=10 means you take 10 more points at beginning and end, verifiy cycle  < nt
;
; NOTES : the output field starts on same point as initial point, but additional points are added after the end 
;         (they are asociated to the last time step of initial field). 
;
; CALLING SEQUENCE :
;
; fieldday=myday(field,6)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;
n1=prod
nt=time & nt_day=nt*period
;
if keyword_set(cycle) then begin
tmonth3=findgen(nt+2*cycle)*period
tday3=findgen(nt_day+2*cycle*period)
fieldday=make_array(n1,nt_day)
for p1=0.,n1-1. do begin
temp=reform(data(p1,*))
temp3=[temp(nt-cycle:nt-1),temp,temp(0:cycle-1)]
temp4=interpol(temp3,tmonth3,tday3,/spline)
fieldday(p1,*)=temp4(period*cycle:period*cycle+nt_day-1)
endfor
;
endif else begin
tmonth=findgen(nt)*period+period/2.
tday=findgen(nt_day)
fieldday=make_array(n1,nt_day)
for p1=0.,n1-1. do begin
temp=reform(data(p1,*))
fieldday(p1,*)=interpol(temp,tmonth,tday,/spline)
endfor
endelse
;
if (size(dims,/n_elements) eq 1) then begin
fieldday=reform(fieldday); gets out degenerated dimension of clima
endif else begin
myreform2,fieldday,[dims(0:size(dims,/n_elements)-2),nt_day]
endelse
;
return,fieldday
;
end




