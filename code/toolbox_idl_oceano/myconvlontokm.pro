function myconvlontokm,lon,atlatitude
;
;;;;;;;;;;;;;;;
;
; Returns Amplitude, in km of a lon vector (latitude coordinates must be specified in degrees)
; lon is a vector, atlatitude a vector (same size), returns vector of same size with coords in km from 0°E
; lon in degrees °W, lat in degrees °N 
; Note it also works for scalars
;
; Sulian Thual IMARPE IRD 2008
;
; NOTE : returns the amplitude at given latitude, by supposing latitude variations are small
;        for big latitude variations, you must rather make an intergration along latitude.
;;;;;;;;;;;;;;;;;
;
; parameters
RT=6378.; rayon terre en km
pi=3.14159265;=mypi() with definition in other function
;
;
; longitude
coefflon=RT*pi/180.*cos(atlatitude*pi/180.)
kmlon=coefflon*lon
;
return,kmlon
;
end

