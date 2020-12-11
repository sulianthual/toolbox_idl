function myconvlattokm,lat
;
;;;;;;;;;;;;;;;
;
; Returns Amplitude, in km of a (lat) vector, relative to 0°N reference point (latitude coordinates must be specified in degrees)
; lat is a vector, output is a vector in km with coords relative to 0°N
; Note it also works for scalars
;
; Sulian Thual IMARPE IRD 2008
;
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
return,kmlat
;
end

