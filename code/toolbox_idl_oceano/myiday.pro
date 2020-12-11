function myiday,field,timeaxis,ntimeaxis,cycle=cycle
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
; timeaxis : l'axe des temps du champ de depart (en jours , irreguliers par exemple en appelant myimonth avant)
; ntimeaxis : le nouvel axe des temps desire pour le champs (en jours)
; cycle : is ce parametre est precise, on considere le champ de depart un cycle (idem pour le champ d'arrive).
;         dans ce cas cycle precise la duree du cycle, ainsi que le nombre de points 
;         (sur timeaxis et ntimeaxis) a rajouter 
;         au debut et a la fin des champs pour faire l'interpolation.
;         cycle=[360,3,6] : considere 360 jours de cycle, rajoute 3 points au timeaxis pour interpoler
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
nt=size(timeaxis,/n_elements)
nt_day=size(ntimeaxis,/n_elements)
;
if keyword_set(cycle) then begin
dre=cycle(0)
ptsupm=cycle(1)
tmonth3=[timeaxis(nt-ptsupm:nt-1)-dre,timeaxis,timeaxis(0:ptsupm-1)+dre]
tday3=ntimeaxis
fieldday=make_array(n1,nt_day)
for p1=0.,n1-1. do begin
temp=reform(data(p1,*))
temp3=[temp(nt-ptsupm:nt-1),temp,temp(0:ptsupm-1)]
fieldday(p1,*)=interpol(temp3,tmonth3,ntimeaxis,/spline)
endfor
;
endif else begin
tmonth=timeaxis
tday=ntimeaxis
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




