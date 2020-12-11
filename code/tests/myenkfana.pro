function myenkfana,xensf,yobs,HH,keepin=keepin
compile_opt hidden
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Etape analyse filtre Kalman Ensemble, avec methode Evensen 2003
; Sulian 2011
;
;
; NOTE: il fautdrait aussi coder la methode pas pour large m (cout m^2 au lieu de mN)
;
; Analyse avec methode evensen 2003 (page 353, 4.3.2, alternative solution large m)
; observations perturbees,  on suppose HA'Gt=0 i.e. erreurs modele-obs non correlees
; 
; INPUTS:
;
; -xensf(nvec,nens): membres forecast du modele ( nens=nombre de membres)
;
; -yobs(mvec,nens): observations (perturbees,verifiant mean(perturb)=0)
;                   avec cette methode, inutile de specifier R
; 
; -HH(nvec,mvec) : matrix tel que y=Hx (ici en convention IDL, H est transpose)
;                  peut etre obtenu par getHinterp2d pour cas interpolation 2d
; OUTPUTS: 
;
; -xensa(nvec,nens): membres analyses du modele
;
; KEYWORDS:
;
; -keepin: ne modifie pas les inputs (donc les recalcule a la fin du script)
;          par defaut xensf et yobs sont ecrases
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; dimensions
pass=size(xensf,/dimensions)
nvec=pass(0) & nens=pass(1)
pass=size(yobs,/dimensions)
mvec=pass(0) & pass=0.;memory
;
; Matrix A, A', D, D', G
AA=transpose(xensf); transpose cf matrix convention in IDL 
xensf=0.;memory
AAp=AA - AA ## (fltarr(nens,nens)+1.)/nens; anomalies to ensemble mean
PPe=AAp ## transpose(AAp) /(1.-nens)
DD=transpose(yobs); transpose cf matrix convention in IDL 
yobs=0.;memory
GG=DD - DD ## (fltarr(nens,nens)+1.)/nens
RRe=GG ## transpose(GG) /(1.-nens)
DDp=DD - HH ## AA
;
; Solve SVD: (HA'+G)=U WW Vt
Matsolve=HH ## AAp + GG
GG=0;memory
SVDC,Matsolve,WW,UU,VV,/double
VV=0. & Matsolve=0.; memory
;
; Sort eigenvalues WW(nens),and UU(nens,mvec) 
eindex=reverse(sort(WW))
WW=WW(eindex)
for i1=0.,mvec-1. do UU(*,i1)=UU(eindex,i1)
eindex=0.;memory

; Compute eigenvalues: (HA'+G)(HA'+G)t=U WWt Ut
WWt=WW^2
WW=0.;memory

; Retain 99% variance (p <= nens) with WWt(p), and UU(p, mvec) 
totvar=total(WWt)
pervar=fltarr(nens)
for iens=0,nens-1 do pervar(iens)=total(WWt(0:iens))/totvar
iretain=where(pervar le 0.99)
totvar=0. & pervar=0.;memory
WWt=WWt(iretain)
UU=UU(iretain,*)
iretain=0;memory
;
; Update for analysed state
XX1= diag_matrix(1./WWt) ## transpose(UU)
WWt=0;memory
XX2=XX1 ## DDp
XX1=0;memory
DDp=0;memory
XX3= UU ## XX2
XX2=0;memory
UU=0;memory
XX4=transpose(HH ## AAp) ## XX3
XX3=0; memory
if ~keyword_set(keepin) then HH=0;memory
xensa=AA + AAp ## XX4
XX4=0; memory
AAp=0;memory
;
xensa=transpose(xensa); transpose cf matrix convention in IDL 
if keyword_set(keepin) then begin
xensf=transpose(AA); Si necessaire en sortie
yobs=transpose(DD); Si necessaire en sortie
endif
;
return,xensa

end