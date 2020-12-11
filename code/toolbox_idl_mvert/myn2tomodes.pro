Pro myn2tomodes,N20,zgrid0,cguess,Cn,Fn0,Scln0
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Sulian THUAL oct 2010
;
; Calculate vertical modes for a given profile of N2
; 
; Entrees
; N2 : profil de la frequence de Brunt Vasalia (en s-1)
; zgrid : grille verticale de N2 (doit aller de z=0 a z=-H avec H pris comme bottom)
; cguess : vecteur de guess pour les vitesses cn (prendre des valeurs usuelles)
;
; Sorties
; on retourne les cn, Fn, et Scln=g*dzFn/N2. Ici n est la taille de cguess.
; Les sorties sont sous forme cn(n),Fn(z,n),Scln(z,n)
; les Fn,Scln sont normalises tel que Fn(0)=1
; 
; Badvalues NaN dans N2
; Si NaN est mis dans N2 (au fond), alors pour N2(z<Hgood)=NaN en entree le calcul se fait de z=0 a z=-Hgood
; et les champs sont retournees avec Fn(z<Hgood)=NaN idem Scln. (N20, Fn0,Scln0) sont les profils avec badvalues,
; tandis que les champs (N2,Fn,Scln)  sont les profils restreints sont badvalues
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Storm-Liouville problem:
; dz(dzF/N2)+F/c2=0
; dzF=0 at z=-Hbottom
; dzF/N2+F/g=0 at z=0
; Ici on modifie le systeme comme: 
; on definit J=dzF/N2 alors on a
; dJ+F/c2=0
; dF=N2*J
; J(-Hbottom)=0
; (J+F/g)(0)=0
;
; Shooting method:
;    Pour c donne dans n2tomodes_reconstruct, on integre le systeme a partir de  
;    la condition limite en  J(-Hbottom)=0 et on retourne la condition limite en z=0
;    Dans myn2tormodes, on cherche c par iterations tel que 
;    on trouve egalement  la condition limite en z=0.
;    Cela revient a chercher les racines d'une fonction dont les racines sont les cn (methode de Newton).
;    n2tomodes_diff (appele iterativement par n2tomodes_reconstruct) retourne les derivees [dF,dJ] 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Traitement pour badvalues du fond :
; Sauvegarde de la taille original
nz0=size(zgrid0,/n_elements)
; recherche de la premiere badvalue
if ((where(finite(N20) eq 0))(0) ne -1) then Hg=(where(finite(N20) eq 0))(0) else Hg=nz0
; restriction du domaine a la premiere badvalue
N2=N20(0:Hg-1)
zgrid=zgrid0(0:Hg-1)
;
; Initialisation des variables globales (pour n2tomodes_shoot et n2tomodes_diff)
common share_n2tomodes,N2_glo,zgrid_glo,condlim1_glo,cc_glo
N2_glo=N2
zgrid_glo=zgrid
condlim1_glo=1.; condition limite libre (F(-Hbottom)=cdlim1_glo)
;
;
; A partir des guess, racine cn la plus proche (shooting method)
; On part de cguessfirst, et on incremente pour aller vers cguessmax (nsteps au total)
; La solution doit etre entre cguessmin et cguessmax, sinon il n y a pas convergence
ncn=size(cguess,/n_elements)
croot=dblarr(ncn)
for icn=0,ncn-1 do croot(icn)=newton(cguess(icn),'myn2tomodes_reconstruct'); trouve la racine la plus proche

;
; A partir des racines, reconstruction de (Fn,Scln=g*dzFn/N2)
nz=size(zgrid,/n_elements)
Cn=dblarr(ncn)
Fn=fltarr(nz,ncn)
Scln=fltarr(nz,ncn)
for icn=0,ncn-1 do begin
cninput=croot(icn)
result=myn2tomodes_reconstruct(cninput,/giveall)
Cn(icn)=cninput
Fn(*,icn)=result(0,*) 
Scln(*,icn)=result(1,*)
endfor
;
; Normalisation des profils par Fn(0)=1
for icn=0,ncn-1 do begin
norme=Fn(0,icn)
Fn(*,icn)=Fn(*,icn)/norme
Scln(*,icn)=Scln(*,icn)/norme
endfor
;
; Ajout des badvalues de fond
Fn0=fltarr(nz0,ncn)+myNaN()
Scln0=fltarr(nz0,ncn)+myNaN()
for icn=0,ncn-1 do begin
Fn0(0:nz-1,icn)=Fn(*,icn)
Scln0(0:nz-1,icn)=Scln(*,icn)
endfor
;
end
