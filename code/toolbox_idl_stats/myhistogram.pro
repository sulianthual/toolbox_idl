 Pro myhistogram,field,xhisto,histo,nint=nint,choosex=choosex,topdf=topdf
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Cree un histogramme (ou pdf) sur une distribution 
; Sulian Thual 2011
;
; METHODE:
;
; On considere nint intervalles (donc n+1 points) pour axe abcisses, dans lequel on compte le nombre de points
; a travers la loi min_i <= Y < max_i
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; INPUT:
;
; field: le champ en entree (une serie temporelle par exemple...)
;   
; OUTPUT:
;
; xhisto: axe de la position des bords gauches (min_i) des intervalles utilises pour compter min_i <= Y < max_i
;         Attention le dernier point min_nx compte  min_nx <= Y < infinity
;         si choosex et nint non-specifies, xhisto est cree entre de min(field) et max(field) pour 
;         compter 10 intervalles. 
; 
; histo: histogramme en sortie (meme size que xhisto)
;
; KEYWORD:
;
; -nint=100 : si specifie (ex:nint=100), specifie le nombre de intervalles  pour xhisto (defaut=10)
;          dans ce cas xhisto est cree entre min(field)-max(field) pour 
;          compter nint intervalles. 
;          note est dummy si choosex est specifie. Note si nint<4 on force nint=4 (minimum requis)
;
; -/choosex: si mis alors xhisto est impose en entree. Attention si xhisto est non-regulier il sera modifie
;            pour etre regulier en sortie
; 

;
; - /topdf: normalise tq donne la probability density function en fait
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
; cas par defaut
ninterv=10
maxf=max(field)
minf=min(field)
;
if keyword_set(nint) then ninterv=nint

if keyword_set(choosex) then begin
maxf=max(xhisto)
minf=min(xhisto)
ninterv=size(xhisto,/n_elements)
endif
;
; Compute histogram (il faut donner le min,max et le nombre intervalles voulus)
histo=histogram(field,locations=xout,min=minf,max=maxf,nbins=ninterv)
;
xhisto=xout
;
; Calcul pdf au lieu de histogramme par normalization
if keyword_set(topdf) then begin
; utilisation trapez pour integration:
;http://www.astro.washington.edu/docs/idl/cgi-bin/getpro/library21.html?TRAPEZ
nxh=size(histo,/n_elements)
if (nxh eq 1) then begin; cas une seule valeur histogramme !
histo=1.; 
endif else begin
df=fltarr(nxh)
df(1) = ( histo(1:*) + histo ) * ( xhisto(1:*) - xhisto )
trapez=0.5*total(df)
histo=histo/trapez
endelse
endif

end