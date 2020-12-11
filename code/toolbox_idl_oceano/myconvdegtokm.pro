function myconvdegtokm,lon,lat,atlatitude
;
;;;;;;;;;;;;;;;
;
; Returns Amplitude, in km of a (lon,lat) vector (latitude coordinates must be specified in degrees)
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
; latitude
coefflat=RT*pi/180.
kmlat=coefflat*lat
;
; longitude
coefflon=RT*pi*cos(atlatitude)/180.
kmlon=coefflon*lon
;
; calculating vector amplitude in km
km=sqrt(kmlon*kmlon+kmlat*kmlat)
;
return,km
;
end

