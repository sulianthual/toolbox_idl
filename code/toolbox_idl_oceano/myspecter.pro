Pro myspecter,t1,oo,pow00,period=period,cycle=cycle,keepmean=keepmean
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; compute specter of a time serie
; Sulian THUAL IRD 2009
;
; ENTRIES :
;- t1 is the entry time serie
;- procedure returns oo (frequency or period axis)
;- procedure returns pow00 (specter, adimentionalised)
;- if /period is set, oo is in period rather than frequency (and 0 frequency is converted in double of maximum period)
;- if cycle is set, then t1 is supposed to be a cycle( exemple a climatology) and is repeated the number of times
;  you specify before making specter. This is due to the FFT limitation that only gives division of size(t1,/n_elements).
;  Exemple for t1 a 10 years time series, you will get periods 10y,5y,3.3y,2.5y etc...
;  Repeat cycle to better see short periods on the outputs
;  cycle must be integer >=1.
;
;- if keepmean is set the value for time serie mean(frequ=0) is kept in outputs, else it is always removed.
;  We recommand using mean of time serie for specter.
;
; NOTE :
; - the period is relative to the one of your function t1, supposed to correspond to a 
;   regular time axis=findgen(size(t1,/n_elements)). Exemple t1 in days=> periods in days. 
;
; exemple : myspecter,cos(findgen(1000)*2.*3.14/100.),axis,specter,/period,cycle=3
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; treat entry data
t1=reform(t1)
if keyword_set(cycle) then begin
to=t1
for i=1,cycle-1 do begin
t1=[t1,to]
endfor
endif
nt=size(t1,/n_elements)

;;;spectre
h0=t1
g0=fft(h0*hanning(nt),-1)
pow0=float(g0*conj(g0))

;;calc norm
sum=0.0
for k=0,nt-1 do begin
sum=sum+pow0(k)
endfor
norm0=sum

;;;
o=[findgen(nt/2),-reverse(findgen(nt/2))]/nt; frequency axis
if keyword_set(period) then begin
for i=0,size(o,/n_elements)-1 do begin; convert frequency axis to period axis
if (o(i) ne 0.) then begin
o(i)=1./o(i)
endif else begin
o(i)=abs(max(1/o(where(o ne 0.))))*10.
endelse
endfor
endif

if keyword_set(keepmean) then begin
oo=o(0:fix((nt/2.)-1))
pow00=pow0(0:fix((nt/2.)-1))/norm0
endif else begin
oo=o(1:fix((nt/2.)-1))
pow00=pow0(1:fix((nt/2.)-1))/norm0
endelse
;
;;;;;;
if (0 eq 1) then begin; old, to plot directly
max1=max(pow0(0:fix((nt/2.)-1))/norm0)
yyrange=[0,0.001*(fix(max1*1000)+1)]
xxrange=[min(o),max(o)]

mygraph
myplot,oo,pow00,$
title0='spectrum',title1='period',title2='adim', $
yrange=yyrange,xrange=xxrange
endif

end