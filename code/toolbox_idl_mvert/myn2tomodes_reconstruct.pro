function myn2tomodes_reconstruct,cc,giveall=giveall
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fonction pour reconstuire les modes verticaux, pour cn donne
; 
; cc: cn en entree. 
; Par defaut retourne la condition limite en z=0 (pour shooting method)
; /giveall: si keyword set, retourne [transpose(Fn),transpose (Scln)] avec Scln=g*dzFn/N2 (pour resultats)
;           mais les profils ne sont pas normalises (il le sont ensuite dans myn2tomodes)
; 
; Attention ce programme est joint avec n2tomodes.pro et n2tomodes_diff.pro (variables globales)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;    Dans myn2tomodes, on cherche c par iterations tel que 
;    on trouve egalement  la condition limite (J+F/g)(0)=0 en z=0.
;    Cela revient a chercher les racines d'une fonction dont les racines sont les cn (methode de Newton).
;    n2tomodes_diff (appele iterativement par n2tomodes_reconstruct) retourne les derivees [dF,dJ] 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Variables globales
common share_n2tomodes,N2_glo,zgrid_glo,condlim1_glo,cc_glo
cc_glo=cc
nz=size(zgrid_glo,/n_elements)
g=9.81
ff=dblarr(nz) & jj=dblarr(nz)
;
; Reconstruction a partir de la condition initiale
ff(nz-1)=condlim1_glo & jj(nz-1)=0.; condition limite de depart (-H)
for k=nz-2,0,-1 do begin; integration -H a 0
yy=[ff(k+1),jj(k+1)]
dydx=myn2tomodes_diff(zgrid_glo(k+1),yy)
xx=zgrid_glo(k+1)
hh=zgrid_glo(k)-zgrid_glo(k+1)
;result=RK4(yy,dydx,xx,hh,'myn2tomodes_diff'); PAS BON, MIEUX LSODE
result=LSODE(yy,xx,hh,'myn2tomodes_diff')
ff(k)=result(0) & jj(k)=result(1)
endfor
;
condlim2=jj(0)+ff(0)/g; condition limite en z=0 (si cn est solution, doit etre 0) 
;
if keyword_set(giveall) then begin
return,[transpose(ff),g*transpose(jj)]
endif else begin
return,condlim2
endelse
;







end