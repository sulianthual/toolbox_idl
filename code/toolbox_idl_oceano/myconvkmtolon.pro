function myconvkmtolon,kmlon,atlatitude,latinkm=latinkm
;
;;;;;;;;;;;;;;;
;
; Inverse de myconvlontokm : prend des km ( a latitude donnee pour chaque element de kmlon), convertit en lon
;
; Sulian Thual IMARPE IRD 2008
;
; Keyword latinkm : si la latitude de reference est precisee en km (par rapport au point 0°N), mettre cette cle
;;;;;;;;;;;;;;;;;
;
; parameters
RT=6378.; rayon terre en km
pi=3.14159265;=mypi() with definition in other function
;
;
; longitude
if keyword_set(latinkm) then atlatitude2=atlatitude/6378./3.14159265*180. else atlatitude2=atlatitude
coefflon=RT*pi/180.*cos(atlatitude2*pi/180.)
lon=kmlon/coefflon
;
return,lon
;
end

