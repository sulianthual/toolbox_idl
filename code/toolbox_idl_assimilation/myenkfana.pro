function myenkfana,xensf,yobs,HH,keepin=keepin,debug=debug,yensf=yensf,$
         donothing=donothing,dombymsvd=dombymsvd
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
;                 Si HH est un string, il defini la fonction Y=H(X) qui sera appelee !
;  si /yensf est mis, au lieu de HH mettre Yf=HXf directement
; OUTPUTS: 
;
; -xensa(nvec,nens): membres analyses du modele
;
; KEYWORDS:
;
; -keepin: ne modifie pas les inputs (donc les recalcule a la fin du script)
;          par defaut xensf et yobs sont ecrases
;
; -debug: mettre des messages
;
; -donothing: analyse=forecast, ne fait donc rien (pour tests de script uniquements)
;
; -dombymsvd: plutot que de calculer et tronquer la SVD de (HAp+G), calcule la SVD de 
;             (HPH^T + R)
; 
; RQ: Pour une simple interpolation 2d avec bavalues dans Y, H dans le cas matriciel 
;     peut etre obtenu par getHinterp2d
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; check: H est une matrice ou un string(fonction a appeler)
htype=size(HH,/type)
if (htype eq 7) then begin
hisfunc=1
endif else begin
hisfunc=0
endelse
;
; dimensions
pass=size(xensf,/dimensions)
nvec=pass(0) & nens=pass(1)
pass=size(yobs,/dimensions)
mvec=pass(0) & pass=0.;memory
;
; Matrix A, A', D, D', G
AA=transpose(temporary(xensf)); transpose cf matrix convention in IDL 
AAp=AA - AA ## (fltarr(nens,nens)+1.)/nens; anomalies to ensemble mean
;PPe=AAp ## transpose(AAp)/(1.-nens); size (nvec,nvec) (inutile de le calculer)
DD=transpose(temporary(yobs)); transpose cf matrix convention in IDL 
GG=DD - DD ## (fltarr(nens,nens)+1.)/nens
;RRe=GG ## transpose(GG) /(1.-nens);(mvec,mvec) (inutile de le calculer)
if (hisfunc eq 1) then begin
pass=call_function(HH,transpose(AA))
DDp=DD -transpose(pass)
pass=0.;memory
endif else begin
if keyword_set(yensf) then begin
YF=transpose(HH); ici HH est Yf=H Xf
DDp=DD- temporary(YF)
endif else begin
DDp=DD - HH ## AA
endelse
endelse
if ~keyword_set(keepin) then DD=0.;memory


; method 1: Solve SVD:(HPHt+R)=U WW^2 Vt, cout en mxm
if keyword_set(dombymsvd) then begin
if (hisfunc eq 1) then begin
pass=call_function(HH,transpose(AAp))
YFp=transpose(temporary(pass))
Matsolve=YFp ## transpose(YFp) + GG ## transpose(GG); (mvec,N)
YFp=0. & GG=0.;memory
endif else begin
if keyword_set(yensf) then begin
YF=transpose(HH); ici HH est Yf=H Xf
YFp=YF - YF ## (fltarr(nens,nens)+1.)/nens; anomalies to ensemble mean
YF=0.; memory
Matsolve=YFp ## transpose(YFp) + GG ## transpose(GG); (mvec,N)
YFp=0. & GG=0.;memory
endif else begin
YFp=HH ## AAp
Matsolve=YFp ## transpose(YFp) + GG ## transpose(GG); (mvec,N)
GG=0.;memory
endelse
endelse
if keyword_set(debug) then print,'myenkfana=start svd solve'
SVDC,Matsolve,WWt,UU,VV,/double
if keyword_set(debug) then print,'myenkfana=end svd solve'
VV=0 & Matsolve=0; memory
endif else begin 

; method 2: for large m (m>N) evensen 2003, cout en mxN
; Solve plutot SVD: (HA'+G)=U WW Vt puis deduit SVD:(HPHt+R)=U WW^2 Vt
if (hisfunc eq 1) then begin
pass=call_function(HH,transpose(AAp))
Matsolve=transpose(temporary(pass)) + temporary(GG); (mvec,N)
endif else begin
if keyword_set(yensf) then begin
YF=transpose(HH); ici HH est Yf=H Xf
YFp=YF - YF ## (fltarr(nens,nens)+1.)/nens; anomalies to ensemble mean
YF=0.; memory
Matsolve=temporary(YFp) + temporary(GG); (mvec,N)
endif else begin
Matsolve=HH ## AAp + temporary(GG); (mvec,N)
endelse
endelse
if keyword_set(debug) then print,'myenkfana=start svd solve'
SVDC,Matsolve,WW,UU,VV,/double
if keyword_set(debug) then print,'myenkfana=end svd solve'
VV=0 & Matsolve=0; memory
; Compute eigenvalues: (HA'+G)(HA'+G)t=U WWt Ut
WWt=temporary(WW)^2
endelse


; cut 99.9% cov sur decreasing WWt (necessaire de le faire)
; Rq si cut sur increasing WWt ou ne cut pas les resultats sont faux
if (1 eq 1) then begin
; Sort eigenvalues decreasing WWt 
eindex=reverse(sort(WWt))
WWt=WWt(eindex)
for i1=0.,mvec-1. do UU(*,i1)=UU(eindex,i1)
eindex=0.;memory
; Cut at 99.9% cov
totvar=total(WWt)
pervar=fltarr(nens)
for iens=0,nens-1 do pervar(iens)=total(WWt(0:iens))/totvar
iretain=where(pervar le 0.999)
if (iretain(0) eq -1) then iretain=0; peut etre le premier point
if keyword_set(debug) then print,'myenkfana, Nsvd modes for 0.999 percent=',size(iretain,/n_elements)
totvar=0. & pervar=0.;memory
WWt=WWt(iretain)
UU=UU(iretain,*)
iretain=0;memory
endif
;
; Update for analysed state
XX1= diag_matrix(1./temporary(WWt)) ## transpose(UU)
XX2=temporary(XX1) ## temporary(DDp)
XX3= temporary(UU) ## temporary(XX2)
if (hisfunc eq 1) then begin
pass=call_function(HH,transpose(AAp))
XX4=temporary(pass) ## temporary(XX3)
endif else begin
if keyword_set(yensf) then begin
YF=transpose(HH); ici HH est Yf=H Xf
YFp=YF - YF ## (fltarr(nens,nens)+1.)/nens; anomalies to ensemble mean
YF=0.; memory
XX4=transpose(temporary(YFp)) ## temporary(XX3)
endif else begin
XX4=transpose(HH ## AAp) ## temporary(XX3)
endelse
if ~keyword_set(keepin) then HH=0;memory
endelse
xensa=AA + temporary(AAp) ## temporary(XX4)
;
if keyword_set(donothing) then begin; ne fait rien, analyse=forecast
print,'myenkfana : donothing'
xensa=transpose(temporary(AA))
endif else begin
if ~keyword_set(keepin) then AA=0.;memory
xensa=transpose(xensa); transpose cf matrix convention in IDL 
endelse
;
if keyword_set(keepin) then begin
xensf=transpose(temporary(AA)); Si necessaire en sortie
yobs=transpose(temporary(DD)); Si necessaire en sortie
endif
;
;
return,xensa

end