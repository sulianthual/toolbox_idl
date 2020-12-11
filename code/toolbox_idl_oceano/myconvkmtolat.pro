function myconvkmtolat,kmlat
;
;;;;;;;;;;;;;;;
;
; Inverse de myconvlattokm : avec des lat, retourne des km
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
lat=kmlat/coefflat
;
return,lat
;
end

