function mylagmaxabs,input_time1,input_time2,lags
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function for lag-correlation, but returns only the maximum correlation encountered (negative or positive)
; along with the values at which they are encountered
;  Sulian Thual, IRD-IMARPE 2008
;
; NOTE : on retourne la correlation maximum en valeur absolue, elle peut etre negative !
; 
; inputs :
; -time1 : first time serie
; -time2 : second time serie (must have same size as time1
; lags :array of lags at wich lag-correlation is computed (indices of the time array, not time dimension !)
;
; output :
; - on retourne le vecteur suivant (ATTENTION A LA FORME) :
;      [ lagmaxmin, wmax ] avec lagmaxmin la corre maximum (en valeur absolue)
;    et wmax la (ou les) valeur(s) de lags ou on rencontre lagmaxmin
;
; NOTE : We compare time1 to time2, wich mean if lag is positive,
;        then time1 should be in advance, and time2 more late.
;;   - Use lags wich are pairs, as an impar one is the ;      same as for its close pair.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
lagmax=mylagmax(input_time1,input_time2,lags)
lagmin=mylagmin(input_time1,input_time2,lags)
comax=lagmax(0)
comin=lagmin(0)
if (abs(comax) ge abs(comin)) then begin
return,lagmax
endif else begin
return,lagmin
endelse
;
;
end