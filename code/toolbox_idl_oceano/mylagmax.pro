function mylagmax,input_time1,input_time2,lags
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function for lag-correlation, but returns only the maximum lag followed by the lag(s) where it is encountered
;  Sulian Thual, IRD-IMARPE 2008
;
; inputs :
; -time1 : first time serie
; -time2 : second time serie (must have same size as time1
; lags :array of lags at wich lag-correlation is computed (indices of the time array, not time dimension !)
;
; output :
; - on retourne le vecteur suivant (ATTENTION A LA FORME) :
;      [ lagmax, wmax ] avec lagmax le lag maximum et wmax la (ou les) valeur(s) de lags où on rencontre lagmax
;
; NOTE : We compare time1 to time2, wich mean if lag is positive,
;        then time1 should be in advance, and time2 more late.
;;   - Use lags wich are pairs, as an impar one is the ;      same as for its close pair.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
lagco=mylagco(input_time1,input_time2,lags)
lagmax=max(lagco)
wmax=lags(where(lagco eq max(lagco)))
;
return,[lagmax,wmax]
;
;
end