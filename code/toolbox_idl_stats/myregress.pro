function myregress,variable,field,byrms=byrms,back=back;,withbad=withbad
compile_opt hidden

; Sulian THUAL mai 2011
; regresse le champ field sur la variable
; entree : variable(t)
;          field(x,y,...,t)
; sortie : regression regfield(x,y,....); (enleve la dimension temps)
;
; clef : si byrms on, alors multiplie regression map par standard deviation (rms) de la variable !
;       si back on, alors divise par variance locale de field (et si byrms mult par stddev locale du champ)
;     

; NOTE : on enleve le mean sur les deux series
;
; NOTE : Si field a des badvalues NaN (a mettre en entree !), elles sont mises a zero
;        Elle auront donc une contribution nulle sur la regression
; 
; EN CHANTIER, PAS FINI .....
;        Par defaut on restreint la regression aux values non NaN de variable
;        Si withbad est non specifie, les badvalues de variable sont mises a zero 
;        L une ou autre methode peut fausser la regression, selon ce qui est attendu, bien choisir !
;        manque une partie a faire....

; REMARQUE IMPORTANTE : une regression doit toujours etre accompagne d un test de student
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Lecture entrees
data=field
myreform1,data,dims,prod,time
n1=prod & nt=time
vardat=variable
vardat=reform(vardat); doit etre une seule dimension temps
;
;;;;; cas general (desactiver option withbad pour ce traitement) 
;
; Restreint analyses aux temps avec variable non NaN (sauf si withbad mis)
isgood=where(finite(vardat) eq 1)
if (isgood(0) ne -1) then begin
vardat=vardat(isgood)
data=data(*,isgood)
endif 
;
; Calcul anomalies au mean
vardat=myamean(vardat); direct car pas de badvalues
for pi1=0,n1-1 do begin; pour field necessaire de ne pas considerer les badvalues de field
pass=reform(data(pi1,*))
isgood=where(finite(pass) eq 1)
if (isgood(0) ne -1) then begin
passgood=pass(isgood)
data(pi1,*)=data(pi1,*)-mean(passgood)
endif
endfor
; autre cas= que des badvalues en pi1, mais dans ce cas seront mis a zero de toute facon
;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;; cas withbad EN CHANTIER 
;if (0 eq 1) then begin
;; Badvalues treatment withbad option: NaN mis a zero pour variable
;if keyword_set(withbad) then begin
;isbad=where(finite(vardat) eq 0)
;if (isbad(0) ne -1) then vardat(isbad)=0.
;endif 
; Calcul anomalies au mean ; cas avec withbad
;if keyword_set(withbad) then begin
; .....
;endif
;endif
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; tous les cas (wwithbad ou non)
;
; Badvalues treatment: NaN mis a zero pour field 
isbad=where(finite(data) eq 0)
if (isbad(0) ne -1) then data(isbad)=0.
;
; regression
regressfield=make_array(n1)
stdvardat0=mystddev(vardat)
stdvardat=mystddev(vardat*vardat)
for pi1=0.,n1-1. do begin
fieldserie=reform(data(pi1,*))
if keyword_set(back) then begin
stdfield=mystddev(fieldserie*fieldserie); attention si valeurs 0, non comptees !
regressfield(pi1)=mystddev(vardat*fieldserie)/stdfield
endif else begin
regressfield(pi1)=mystddev(vardat*fieldserie)/stdvardat
endelse
if keyword_set(byrms) then begin
if keyword_set(back) then begin
stdfield0=mystddev(fieldserie)
regressfield(pi1)=regressfield(pi1)*stdfield0
endif else begin
regressfield(pi1)=regressfield(pi1)*stdvardat0
endelse
endif
endfor
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then myreform2,regressfield,dims(0:ndims-2) else regressfield=reform(regressfield)
;
return,regressfield

end