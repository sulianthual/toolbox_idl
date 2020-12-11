function myatrend,field,trend=trend
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for suppressing trend from field of form field(*...nt) with IDL :
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,*,*,time).       
; keyword trend : If set, returns the trend instead of the detrended field
;
; CALLING SEQUENCE :
;
;
;  fieldnotrend=myatrend(field)
; 
; NOTES :
;
; - You can also remove the annual cycle, or the 2 year cycle, or the mean.
;   The commands are in the script, to be adapted.
; - PROBLEM : When puting a constant matrice (a=fltarr(2,2,212)+1) in entry,
;             output is not equal to input. 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
myreform1,data,dims,prod,time
;

n1=prod & nt=time
fieldnotrend=make_array(n1,nt)
thetrend=make_array(n1,nt)
;
for pi1=0.,n1-1. do begin
;xgradmax=fltarr(nt) & xgradmax(*)=data(pi1,*)
xgradmax=reform(data(pi1,*))

;METHODE 1 BORIS, NE MARCHE PAS
if (0 eq 1) then begin
xgradmaxrec=fltarr(nt)
vsin=fltarr(nt)
xtime=findgen(nt)
vsin(*)=xtime; for trend coefficient
; If you also want to remove mean,annual cycle, 2 years cycle.
; Note : cycle =1 year on timescale of field.
; pi=3.141592654
; vsin(*,1)=1.; for mean coefficient
; vsin(*,2)=sin(2*pi*xtime/cycle); for years cycle coefficient
; vsin(*,3)=cos(2*pi*xtime/cycle); for year cycle coefficient
; vsin(*,4)=sin(4.*pi*xtime/cycle); for 2 year cycle coefficient
; vsin(*,5)=cos(4.*pi*xtime/cycle); for 2 years cycle coefficient
coef=invert(transpose(vsin)#vsin,status)#transpose(vsin)#((xgradmax))
xgradmaxrec=coef(0)*xtime; (+coef(1) if you also want to remove mean)
if (status ne 0) then begin
print,' myatrend : invert matrice did not converge'
endif
fieldnotrend(pi1,*)=data(pi1,*)-xgradmaxrec(*)
thetrend(pi1,*)=xgradmaxrec(*)
endif
;
;METHODE 2
if (1 eq 1) then begin
truc=detrend(xgradmax,xgradmax2)
fieldnotrend(pi1,*)=xgradmax2
thetrend(pi1,*)=xgradmax2-xgradmax
endif
;
; 
endfor
;
if keyword_set(trend) then begin
myreform2,thetrend,dims
return,thetrend
endif else begin
myreform2,fieldnotrend,dims
return,fieldnotrend
endelse
;
end










