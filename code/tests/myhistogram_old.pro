 Pro myhistogram,field,histo,xhisto,choosex=choosex,topdf=topdf
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Cree un histogramme (ou pdf) sur une distribution 
; Sulian Thual 2011
;
; INPUT:
;
; field: le champ en entree (une serie temporelle par exemple...)
;
; OUTPUT:
;
; histo: histogramme en sortie (ne pas modifier)
;
; Si /choosex mis, alors xhisto est l axe a utiliser en abcisse pour compter
;
; Si /choosex non mis, alors xhisto est le nombre de points entre le min et le max de field
;
; KEYWORD:
; -topdf: normalise tq donne la probability density function en fait
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Calcul histogramme
if ~keyword_set(choosex) then begin
; xhisto non choisi par utilisateur: on fait entre le min et le max
; 
;
minf=min(field) & maxf=max(field) 
print,minf,maxf
npoints=10; par defaut si xhisto non defini
xhisto=(maxf-minf)/float((npoints-1))*findgen(npoints)+minf
nbins=npoints
histo=histogram(field,locations=xhisto,min=minf,max=maxf,nbins=nbins); en fait xhisto est retourne ici !

endif else begin
; xhisto choisi par utilisateur: Attention doit etre regulier !
xmin=min(xhisto)
xmax=max(xhisto)
nbins=size(xhisto,/n_elements)
histo=histogram(field,locations=xtest,min=xmin,max=xmax,nbins=nbins); xhisto est retourne ici
;
; problemes de differences xhisto et xtest ? pourtant ce sont a prioris les memes
isdiff=min(xtest eq xhisto); test: xtest=xhisto
isdiff=1; pour ne pas faire ce test
if (isdiff eq 0) then begin
print,'myhistogram: xhisto_in ne xhisto_out !'; peut arriver si xhisto non regulier 
print,'xtest',xtest(where(xtest ne xhisto))
print,'xhisto',xhisto(where(xtest ne xhisto))
print,'xhisto_in=',min(xhisto),max(xhisto),size(xhisto,/n_elements)
print,'xhisto_out=',min(xtest),max(xtest),size(xtest,/n_elements)
endif
;
xhisto=xtest; normallement ce sont les memes, donc xhisto_out remplace xhisto_in
;
endelse

;print,'   xhisto'
;print,xhisto
;print,' histo'
;print,histo
;nx=size(field,/n_elements)
;print,nx

; Calcul pdf au lieu de histogramme par normalization
if keyword_set(topdf) then begin
;
; utilisation trapez pour integration:
;http://www.astro.washington.edu/docs/idl/cgi-bin/getpro/library21.html?TRAPEZ
nxh=size(histo,/n_elements)
;
if (nxh eq 1) then begin; cas une seule valeur histogramme !
histo=1.; 
endif else begin
df=fltarr(nxh)
df(1) = ( histo(1:*) + histo ) * ( xhisto(1:*) - xhisto )
trapez=0.5*total(df)
histo=histo/trapez
endelse
;
;
endif
;











end