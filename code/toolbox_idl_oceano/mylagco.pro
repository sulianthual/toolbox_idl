function mylagco,input_time1,input_time2,lags
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function for lag-correlation
;  Sulian Thual, IRD-IMARPE 2008
;
; inputs :
; -time1 : first time serie
; -time2 : second time serie (must have same size as time1
; lags :array of lags at wich lag-correlation is computed(integers, can be negative, they are relative to the indices of the time series)
; Note the output is an array with same size as lags.
;
; output :
; -lagco (nlags) : correlations calculated at point from lags.
;
; NOTE : We compare time1 to time2, wich mean if lag is positive,
;        then time1 should be in advance, and time2 more late.
;;   - Use lags wich are pairs, as an impar one is the ;      same as for its close pair.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; remove degenerated values
time1=input_time1
time2=input_time2
time1=reform(time1)
time2=reform(time2)
;
nt=size(time1,/n_elements)
nlags=size(lags,/n_elements)
;
if (nt ne size(time2,/n_elements)) then begin
print,'mylagco : nt(time1) ne nt(time2), returning'
return,0
endif
;
if (max(lags) gt nt-1) then begin
print,'mylagco : max(lags) gt nt-1, returning'
return,0
endif
;
if (min(lags) lt 1-nt) then begin
print,'mylagco : min(lags) lt 1-nt, returning'
return,0
endif
;
lagco=make_array(nlags)
for plag=0,nlags-1 do begin
lag=lags(plag)
if (lag ge 0) then begin 
lagco(plag)=correlate(time1(0:nt-1-lag),time2(lag:nt-1))
endif else begin
lag=-lag
lagco(plag)=correlate(time2(0:nt-1-lag),time1(lag:nt-1))
endelse
endfor
;
return,lagco
;
;
end