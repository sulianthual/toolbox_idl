function myenkfrep,xensf,yobs,HH,Robs,keepin=keepin,rnodiag=rnodiag,$
         dolu=dolu,dochol=dochol,docramer=docramer
compile_opt hidden
;
; Etape analyse filtre Kalman Ensemble, avec methode Representeurs (echevin2000JPO), H=Identity
; Sulian 2011
;
; Methode: 
; Xa=Xf+ sum(j=1,m): bj*rj pour un membre a analyser
; rj=columns of Pf*Ht
; b= solution du systeme de Cramer: (H Pf Ht + R) b = (yo - H Xf) par Cholesky matrix
;
;;;;;;;;;;;;;;;;;;;;;;;
;
; INPUTS:
;
; -xensf(nvec,nens): membres forecast du modele ( nens=nombre de membres)
;
; -yobs(mvec): observation 
;
; -HH(nvec,mvec) : matrix tel que y=Hx (ici en convention IDL, H est transpose)
;                  peut etre obtenu par getHinterp2d pour cas interpolation 2d
;
; -Robs(mvec): matrice covariance erreurs des observations (en general diagonal)
;              si keyrowrd /rnodiag mis alors definir Robs(mvec,mvec)
; OUTPUTS:
;
; -xensa(nvec,nens) les membres analyses
; 
; -repre: la matrice des representeurs
;
; KEYWORDS:
;
; -dochol,docramer,dolu: pour changer methode de resolution du systeme lineaire
; la methode par default est la decomposition SVD, les autres marchent assez mal
;
; -keepin: mettre pour ne pas erase les champs en entrees (ils sont recalcules a la fin)
;          par defaut xensf est ecrase, et Robs si non diagonal
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; methode de resolution du systeme lineaire
; 0=SVD factorisation (defaut)
; 1=Lu decomposition
; 2=Cholesky factorisation 
; 3=Cramer
lsmethod=0; default SVD
if keyword_set(dolu) then lsmethod=1
if keyword_set(dochol) then lsmethod=2
if keyword_set(docramer) then lsmethod=3
;
; dimensions
pass=size(xensf,/dimensions)
nvec=pass(0) & nens=pass(1)
pass=size(yobs,/dimensions)
mvec=pass(0) & pass=0.;memory
;
; Matrix: Pf
AA=transpose(xensf); transpose cf matrix convention in IDL 
xensf=0; memory
AAp=AA - AA ## (fltarr(nens,nens)+1.)/nens; anomalies to ensemble mean
PPe=AAp ## transpose(AAp) /(1.-nens)
AAp=0;memory
;
; Matrix A: H Pf Ht + R
if ~keyword_set(rnodiag) then begin
Matsolve=HH ## PPe ## transpose(HH); transpose cf matrix convention in IDL
for ivec=0,mvec-1 do Matsolve(ivec,ivec)=Matsolve(ivec,ivec)+Robs(ivec)
endif else begin
Matsolve=HH ## PPe ## transpose(HH) + transpose(Robs); transpose cf matrix convention in IDL
if ~keyword_set(keepin) then Robs=0;memory
endelse
;
; Now Solve the System, find bj so that: A##bj=B for each member
;
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Prepare Matrix A: ;;;;;;;;;;;;;;;;;;;;
; Resolution SVD (par defaut)
if (lsmethod eq 0) then begin
SVDC,Matsolve,WW,UU,VV
Matsolve=0;memory
err=where (WW le 1e-8) & if (err(0) ne -1) then WW(err)=0.; remove modes faibles, a faire ?
endif
; Resolution LU
if (lsmethod eq 1) then begin
LUDC,Matsolve,luindex
endif
; Resolution Cholesky
if (lsmethod eq 2) then begin
;Matsolve(where (Matsolve le 1e-8))=0.; mise a zero des valeurs proches de erreur machine
CHOLDC,Matsolve,diags,/double; ne marche pas forcement
endif 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Calcul Analyse
bbens=fltarr(nens,mvec)
for iens=0,nens-1 do begin
; Vector B (for each member)
Vect=transpose(yobs)- HH ## AA(iens,*); transpose cf matrix convention in IDL
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Solve linear system:;;;;;;;;;;;;;;;;;;;
if (lsmethod eq 0) then bb=SVSOL(UU,WW,VV,transpose(Vect)); Methode SVD
if (lsmethod eq 1) then bb=LUSOL(Matsolve,luindex,transpose(Vect)); Methode LU
if (lsmethod eq 2) then bb=CHOLSOL(Matsolve,diags,transpose(Vect)); Methode Cholesky
if (lsmethod eq 3) then bb=CRAMER(Matsolve,Vect,zero=1e-8); Methode CRAMER
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
bbens(iens,*)=bb
endfor
bb=0;memory
;
;;;;;;;;;;;;;;;
; Echevin: Xa=Xf+sum(j-m): bj*rj avrc b=(..bj..)T et rj=column PfHt, m nombre obs
; PAR PARTIE OU EN BLOC
if (0 eq 1) then begin
;
; FORME PAR PARTIES: 
xensa=transpose(AA);xensa(nvec,nens)=xensf
print,size(xensa)
Mat=PPe ## transpose(HH); Mat(mvec,nvec)
for iens=0,nens-1 do begin; membres
for jvec=0,mvec-1 do begin; obs
xensa(*,iens)=xensa(*,iens)+bbens(iens,jvec)*reform(Mat(jvec,*))
endfor
endfor
Mat=0.;memory

endif else begin
;
; FORME EN BLOC: 
; Je trouve a partir de Echevin: Xa = Xf + (Pf Ht) b ?
xensa=AA + (PPe ## transpose(HH)) ## bbens
xensa=transpose(xensa); cf convention IDL des matrices

endelse
;;;;;;;;;;;;;;;;
;
PPe=0;memory
bbens=0;memory
if keyword_set(keepin) then xensf=transpose(AA)
;
return,xensa
;

end
