function myhwavetosla,xin
;
; get function H for passage AKBM-HBM to SLA in lodca
; Sulian 2011
;
; INPUTS: 
;
; -xin: vecteur (params-akbm-hbm) avec params=cn-layer1 
;       (apres reform 4,x*n,x*y*n ) en entree
;       Note: d'un point de vue fonctionnel il est necessaire que les params de reconstruction soient integres a Xin
;       
; OUTPUTS:
;
; - vecteur sla (en reform x*y): C'est toujours la SLA dans l'espace du modele LODCA
;
; exemple:
;cwavem=mylodcagetparams(filedat,/cn)
;layer1=mylodcagetparams(filedat,/layer1)
;xin=[cwavem,layer1,reform(akbm,nxpl*3),reform(hbm,nxpl*nypl*3)]; VECT ENTREE
;sla=myhwavetosla(xin)
;sla=reform(sla,[nxl,nyl])

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; GRILLES
xgridl=findgen(34)*11.25/2.+101.25 & nxl=34
ygridl=findgen(30)*2.-29. & nyl=30; 
nxpl=79 & nypl=116 & nmodel=3
xgridlp=findgen(nxpl)*2.+124.
ygridlp=findgen(nypl)*0.5-28.75;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; LECTURE XIN
; Parameters pour reconstruction MV a partir du fichier lodca.dat
cwavem=xin(0:2)
layer1=xin(3)
; Ondes en entree
akbm=xin(4:4+nxpl*3-1) 
hbm=xin(4+nxpl*3:4+nxpl*3+nxpl*nypl*3-1); doit englober le vecteur
akbm=reform(akbm,[nxpl,3])
hbm=reform(hbm,[nxpl,nypl,3])

; CALCUL SLA EN FONCTION DE AKBM ET HBM: (EN JOUANT CHAMPOLLION DANS LES SCRIPTS LODCA)
;
; * Attention lodca sur NX=85,NY=117 different history NXP=79,NYP=116 !
; * nrdhist.f: dans lodca on a les notations: AKBM, HBM, SL
;
; Calcul h1m
h1m=fltarr(30,34,3); (y,x,m)
for m=1,3 do begin
;
; *** DANS zfsufm.f, je remonte les dernieres lignes avant zavgmv: il faut phik,akb et hb pour h1m

; * constmv.f: akb et hb non modif mais phik est defini !
phik=dblarr(117); cf constmv (calcul phikm=phik,i=1-117)
ysd=-28.75; cf lodca.dat
ynd=28.75; cf lodca.dat
beta=2.28e-11; cf constmv
cwave=cwavem(m-1); convention idl -1
eleq=sqrt(cwave/beta)/(111.e3); cf constmv (111.e3= 1 deg lon en metres)
ny=115; je suppose cf constmv
pi=mypi()
ys=ysd/eleq
yn=ynd/eleq
dy=(yn-ys)/float(ny)
yy=fltarr(117); verif ok dans code
for j=1,ny do yy(j-1)=ys+(j-0.5)*dy; je suppose yy(ny) cf constmv
dyinv=2.0/dy
enorm=sqrt(pi)
;erf def dans serf.f. =fonction erreur? erf(z)=2/sqrt(pi) *int(0,z):exp(-x^2)dx 
anorm=( enorm*( erf(yn)+erf(-ys) ) )^ (-0.5); EN FORTRAN ** is power !
jnot=1.55-yy(1-1)/dy ; convention idl -1
jnot=fix(jnot); dans le code fortran
if (jnot lt 2) then jnot=2
jnot1=jnot+1
; EQUATEUR (PT -0.25 ou 0.25)
phik(jnot-1)=anorm*exp(-0.5*yy(jnot-1)*yy(jnot-1)); convention idl -1
; NORD EQUATEUR
for j=jnot1,ny do begin
phik(j-1)=phik(j-1-1)*(dyinv-yy(j-1-1))/(dyinv+yy(j-1)); convention idl -1
endfor
; SUD EQUATEUR
for j=2,jnot do begin
k=jnot1-j
phik(k-1)=phik(k+1-1)*(dyinv+yy(k+1-1))/(dyinv-yy(k-1)); convention idl -1
endfor

; * projwind.f:(rien)
; * mloop.f: akb modifie,hb modifies(par evolution du modele?)

; * zfsufm.f ligne 161: AKBM=AKB et HBM=HB, donc inverse vrai aussi ?
; akbm(i,m)=akb attention akbm(79,3) et akb(85,3)
; hbm(i,j,m)=hb attention hbm(79,116,3) et hb(117,85,3) avec axe y inverse !
akb=fltarr(85);(x)
for i=1,79 do akb(i-1)=akbm(i-1,m-1); attention grille akb-akbm differentes !
hb=fltarr(117,85);(y,x) avec y inverse
for i=1,79 do begin
for j=1,116 do begin; attention grille hb-hbm differentes !, et inverses !
hb(j-1,i-1)=hbm(i-1,nypl-j,m-1); convention idl -1
endfor
endfor

; * zavgmv: 
hint1=fltarr(30,34)
for i=6,25 do begin
i1=120-4*i
is=i1-2
ie=i1+2
for j=6,32 do begin
x=float(j-1)*0.5625
j1=(10.*x+0.25-20.)/2.
j1=fix(j1); cf code
js=j1-1
je=j1+1
aa=0.
for ii=is,ie do begin
for jj=js,je do begin
aa=aa+hb(ii-1,jj-1)+akb(jj-1)*phik(ii-1); convention idl -1
endfor
endfor
hint1(i-1,j-1)=aa/15.; convention idl -1
endfor
hint1(i-1,33-1)=hint1(i-1,32-1); convention idl -1
hint1(i-1,34-1)=hint1(i-1,32-1); convention idl -1
for j=1,5 do begin
hint1(i-1,j-1)=hint1(i-1,6-1); convention idl -1
endfor
endfor
for j=1,34 do begin
for i=1,5 do begin
hint1(i-1,j-1)=0.; convention idl -1
hint1(31-i-1,j-1)=0.; convention idl -1
endfor
endfor
for i=1,34 do begin
for j=1,30 do begin
h1m(j-1,i-1,m-1)=hint1(j-1,i-1); convention idl -1
endfor
endfor   
endfor; fin loop m pour calcul h1m

; * ztmsufm.f: a partir de h1m je peux calculer la SLA
; for m=0,3 do SCL=1.*cwavem(m)*cwavem(m)*100./layerm(1)/9.81 & SL(i,j)=SL(i,j)+SCL*H1M(i,j,m)
sla=fltarr(30,34); y puis x 
for m=1,3 do begin
scl=cwavem(m-1)*cwavem(m-1)*100./layer1/9.81; convention idl -1
for i=1,34 do begin
for j=1,30 do begin
sla(j-1,i-1)=sla(j-1,i-1)+scl*h1m(j-1,i-1,m-1)
endfor
endfor
endfor

; passage ma convention
sla=transpose(sla); passage ma convention sla
; reverse axe y
pass=sla & for j=0,nyl-1 do pass(*,j)=sla(*,nyl-1-j) 
sla=pass & pass=0
sla=reform(sla,nxl*nyl)
return,sla
;
end