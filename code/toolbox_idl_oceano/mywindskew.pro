function mywindskew,field,period,badval
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; fonction pour averager la skewness d un champ sur sa derniere dimension (le temps) dans une fenetre 
; d'average : example faire une moving-window a 10 ans sur 50 ans de datas
;  Sulian Thual, IRD-IMARPE 2010
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,...,time).Sur le temps le champ doit etre regulier
; (ie le temps est une droite)
; period : taille de la fenetre d'average (en indice).
; Doit etre impair car la fenetre est centree.Si pair le programme retient period=period+1
;  Le champ retourne sera le meme avec
; une fenetre d'average sur le temps.Le champ de sortie sera de meme dimension (nt) que 
; celui en entree mais sur les premiers et derniers pas de temps o� on ne peut effectuer 
; la fenetre d'average, les valeurs seront badval
; badval :remplit les extremes (debut et fin) avec cette valeur
;
; CALLING SEQUENCE :
;
; fieldinwindow=mywindvar(field,period)
;=> donne la running variance
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
data=field
myreform1,data,dims,prod,time
;
n1=prod
nt=time
fieldwindavg=make_array(n1,nt)
;
for kt=0,nt-1 do begin
iavgmin=kt-fix(period/2.)
iavgmax=kt+fix(period/2.)
if (iavgmin lt 0) then fieldwindavg(*,kt)=badval
if (iavgmax gt nt-1) then fieldwindavg(*,kt)=badval
if ((iavgmin ge 0) and (iavgmax le nt-1)) then begin
fieldwindavg(*,kt)=myskewness(data(*,iavgmin:iavgmax))
endif
endfor
;
if (size(dims,/n_elements) eq 1) then begin
fieldwindavg=reform(fieldwindavg); gets out degenerated dimension of clima
endif else begin
myreform2,fieldwindavg,dims
endelse
;
return,fieldwindavg
;
end




