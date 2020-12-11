Pro mylodcagethistory,filehist,tstart,ntr,field,dodebug=dodebug,fromdat=fromdat,tonetcdf=tonetcdf,$
    taux=taux,tauy=tauy,therm=therm,sla=sla,sst=sst,$
    doAKBM=doAKBM,doHBM=doHBM,doUBM=doUBM,doH1M=doH1M,doU1M=doU1M,doV1M=doV1M
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR LIRE UN CHAMP DE HISTORY DE LODCA 
; Remarque: lodca (V4 et superieur) est modifie tq lecture-ecriture du history en f77_unformatted possible sous idl
; Sulian Thual 2011
;
; Input: 
;
; -filehist: nom du fichier history a lire
;
; -tstart: step ou on commence a lire le fichier
;
; -ntr: taille en mois du champ a lire (depuis tstart, ne doit pas depasser la fin du history)
;       si /fromdat defini mettre sur ntr le nom du fichier lodca.dat pour calculer ntr
;
; Output:
;
; -field: returned field (only one), which nature is set by the choosen keyword
; 
; - /taux,/tauy,/therm,/sla,/sst...=> choisir SEULEMENT un de ces keyword, qui correspondra au champ a renvoyer 
; - idem doAKBM,doHBM....
; 
;
; Clefs:
;
; /tonetcdf: ecrit dernier pas de temps lu dans fichier netcdf (meme nom que filehist+.nc) 
;            avec toutes les variables(string aussi ?)
;
; /fromdat: si defini, utiliser un lodca.dat (TZERO,TENDD,NREWND) associe au history pour calculer ntr
;           dans ce cas ntr dans etre le nom du fichier lodca.dat 
;
; /dodebug: if set, prompts values when reading
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
filehistpass=filehist; changer le nom, filehist doit rester identique

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Cas ou ntr est un entier
tstartl=tstart; changer le nom, tstart doit rester identique
ntrl=ntr; changer le nom, ntr doit rester identique
;
; Cas ou ntr est un string: definition de la taille du fichier par appel a un lodca.dat
if keyword_set(fromdat) then begin
; Lecture du fichier lodca.dat
filedatpass=ntr; dans appel ntr est un string contenant le chemin du lodca.dat
get_lun,buffer & openr,buffer,filedatpass
nlines=124 & linesdat=strarr(nlines)
for ilin=1,nlines-1 do begin
pass=string(0) & readf,buffer,pass
linesdat(ilin)=pass
endfor
close,buffer & free_lun,buffer
; Calcul du length ntr du fichier history
TZERO=float( (strsplit(linesdat(49)," ",/extract))(2) )
TENDD=float( (strsplit(linesdat(50)," ",/extract))(2) )
NREWND=float( (strsplit(linesdat(83)," ",/extract))(2) )
if (NREWND eq 11) then begin; history a ecrit slmt un pas de temps (le dernier)
ntrl=1
endif else begin; cas NREWND=10, tous les pas de temps (incluant les conditions initiales) sont ecrits
ntrl=fix(TENDD-TZERO+1)
endelse
tstartl=0; dans ce cas part du debut
endif
;
; ntrl doit etre >=1 tel que lecture possible
if (ntrl lt 1) then begin
print,'mylodcagethistory: error there is ntr<1, to read first step put tstart=0,ntr=1'
stop
endif
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Parametres de grille lodca
; 
; 
; history initiaux de boris: 
nxl=34 & nyl=30; pour lecture (NXP,NYL en fait)
nxpl=79 & nypl=116; pour lecture (NX, NY en fait)
nmodel=3; pour lecture (NMODE en fait)
nsl=2; pour lecture (NS en fait)
;
; Rappel: grilles lodca
;xgridl=findgen(34)*11.25/2.+101.25
;ygridl=findgen(30)*2.-29.; (attention fichier history sur grille differente ! ici on passe de une a autre)
;xgridlwind=findgen(84)*2.+124.; Est=290E
;ygridlwind=findgen(30)*2.-29.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Type de la Variable (UNIQUE) a garder lors de la lecture pour retour
if keyword_set(taux) then vartype=1
if keyword_set(tauy) then vartype=1
if keyword_set(therm) then vartype=1
if keyword_set(sla) then vartype=1
if keyword_set(sst) then vartype=1
if keyword_set(doAKBM) then vartype=2
if keyword_set(doHBM) then vartype=3
if keyword_set(doUBM) then vartype=3
if keyword_set(doVBM) then vartype=3
if keyword_set(doH1M) then vartype=4
if keyword_set(doU1M) then vartype=4
if keyword_set(doV1M) then vartype=4
;
; Cas Variable=champ 2D=(NXL,NYL,*):sla,taux,tauy,therm,sst...(inversion dims/champ lodca)
if (vartype eq 1) then begin
field=fltarr(nxl,nyl,ntrl,/nozero)
endif
; Cas Variable=(NXPL,NMODE): AKBM
if (vartype eq 2) then begin
field=fltarr(nxpl,nmodel,ntrl,/nozero)
endif
; Cas Variable=(nxpl,nypl,NMODE): HBM,UBM (inversion dims/champ lodca)
if (vartype eq 3) then begin
field=fltarr(nxpl,nypl,nmodel,ntrl,/nozero)
endif
; Cas Variable=(nxl,nyl,NMODE): H1M,U1M,V1M (inversion dims/champ lodca)
if (vartype eq 4) then begin
field=fltarr(nxl,nyl,nmodel,ntrl,/nozero)
endif
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Debut boucle de Lecture:
; A chaque step de lecture les variables sont ecrasees sauf celles a garder
get_lun,buffer & openr,buffer,filehistpass,/f77_unformatted
;
;Rewind the file:
;point_lun,buffer,0 & print,'mylodcagethistory: rewind file test'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Lecture jusque a tstart sans sauvegarder

if (tstartl gt 0) then begin

for istep=0,tstartl-1 do begin
;print,'skipping=',istep,tstart-1
;
NMODE=0 & readu,buffer,NMODE 
TD=0. & readu,buffer,TD
NT=0 & readu,buffer,NT
NXP=0 & readu,buffer,NXP
NYP=0 & readu,buffer,NYP
NSEG=0 & readu,buffer,NSEG
NX=0 & readu,buffer,NX
NY=0 & readu,buffer,NY
HEQUIV=0. & readu,buffer,HEQUIV
TZERO=0. & readu,buffer,TZERO
TENDD=0. & readu,buffer,TENDD
DTD=0. & readu,buffer,DTD
XWD=0. & readu,buffer,XWD
XED=0. & readu,buffer,XED
YSD=0. & readu,buffer,YSD
YND=0. & readu,buffer,YND
TDECAY=0. & readu,buffer,TDECAY
TPLMIN=0. & readu,buffer,TPLMIN
TSTPRT=0 & readu,buffer,TSTPRT
CHKSUM=0 & readu,buffer,CHKSUM
NPRINT=0 & readu,buffer,NPRINT
MASKW=0 & readu,buffer,MASKW
MWNDGF=0 & readu,buffer,MWNDGF
WMXW=0. & readu,buffer,WMXW
WMXE=0. & readu,buffer,WMXE
WMYS=0. & readu,buffer,WMYS
WMYN=0. & readu,buffer,WMYN
PERIOD=0. & readu,buffer,PERIOD
YNORTH=[0.,0.,0.,0.] & readu,buffer,YNORTH
YSOUTH=[0.,0.,0.,0.] & readu,buffer,YSOUTH
XWEST=[0.,0.,0.,0.] & readu,buffer,XWEST
NSEG=0 & readu,buffer,NSEG
NTAPE=0 & readu,buffer,NTAPE
NREWND=0 & readu,buffer,NREWND
NATM=0 & readu,buffer,NATM
;
NS=NSEG+1
;
AKBM=fltarr(nxpl,nmodel,/nozero) & readu,buffer,AKBM
UBM=fltarr(nypl,nxpl,nmodel,/nozero) & readu,buffer,UBM
HBM=fltarr(nypl,nxpl,nmodel,/nozero) & readu,buffer,HBM
ABC=fltarr(nsl,/nozero) & readu,buffer,ABC
ROSS=fltarr(nsl,/nozero) & readu,buffer,ROSS
TR=fltarr(nsl,/nozero) & readu,buffer,TR
UBNDYM=fltarr(nypl,nsl,nmodel,/nozero) & readu,buffer,UBNDYM
HBNDYM=fltarr(nypl,nsl,nmodel,/nozero) & readu,buffer,HBNDYM
H1M=fltarr(nyl,nxl,nmodel,/nozero) & readu,buffer,H1M
U1M=fltarr(nyl,nxl,nmodel,/nozero) & readu,buffer,U1M
V1M=fltarr(nyl,nxl,nmodel,/nozero) & readu,buffer,V1M
;
Q0O=fltarr(nyl,nxl,/nozero) & readu,buffer,Q0O
UO=fltarr(nyl,nxl,/nozero) & readu,buffer,UO
VO=fltarr(nyl,nxl,/nozero) & readu,buffer,VO
iiDO=fltarr(nyl,nxl,/nozero) & readu,buffer,iiDO; normallement DO
TO=fltarr(nyl,nxl,/nozero) & readu,buffer,TO
HTAU=fltarr(nxl,nyl,2,/nozero) & readu,buffer,HTAU
SL=fltarr(nyl,nxl,/nozero) & readu,buffer,SL
H1=fltarr(nyl,nxl,/nozero) & readu,buffer,H1
;
if keyword_set(dodebug) then begin; test de prompt pendant la lecture
print,'   '
print,'BEFORE TSTART, values at step=',istep,' over ',tstartl-1
print,'NMODE='+string(NMODE)
print,'TD='+string(TD)
print,'NT='+string(NT)
print,'NXP='+string(NXP)
print,'NYP='+string(NYP)
print,'NSEG='+string(NSEG)
print,'NX='+string(NX)
print,'NY='+string(NY)
print,'HEQUIV='+string(HEQUIV)
print,'TZERO='+string(TZERO)
print,'TENDD='+string(TENDD)
print,'DTD='+string(DTD)
print,'XWD='+string(XWD)
print,'XED='+string(XED)
print,'YSD='+string(YSD)
print,'YND='+string(YND)
print,'TDECAY='+string(TDECAY)
print,'TPLMIN='+string(TPLMIN)
print,'TSTPRT='+string(TSTPRT)
print,'CHKSUM='+string(CHKSUM)
print,'NPRINT='+string(NPRINT)
print,'MASKW='+string(MASKW)
print,'MWNDGF='+string(MWNDGF)
print,'WMXW='+string(WMXW)
print,'WMXE='+string(WMXE)
print,'WMYS='+string(WMYS)
print,'WMYN='+string(WMYN)
print,'PERIOD='+string(PERIOD)
print,'YNORTH=',string(YNORTH)
print,'YSOUTH=',string(YSOUTH)
print,'XWEST=',string(XWEST)
print,'NSEG='+string(NSEG)
print,'NTAPE='+string(NTAPE)
print,'NREWND='+string(NREWND)
print,'NATM='+string(NATM)
print,'AKBM=',string(size(AKBM,/dimensions))
print,'UBM=',string(size(UBM,/dimensions))
print,'HBM=',string(size(HBM,/dimensions))
print,'ABC=',string(size(ABC,/dimensions))
print,'ROSS=',string(size(ROSS,/dimensions))
print,'TR=',string(size(TR,/dimensions))
print,'UBNDYM=',string(size(UBNDYM,/dimensions))
print,'HBNDYM=',string(size(HBNDYM,/dimensions))
print,'H1M=',string(size(H1M,/dimensions))
print,'U1M=',string(size(U1M,/dimensions))
print,'V1M=',string(size(V1M,/dimensions))
print,'Q0O=',string(size(Q0O,/dimensions))
print,'UO=',string(size(UO,/dimensions))
print,'VO=',string(size(VO,/dimensions))
print,'iiDO=',string(size(iiDO,/dimensions))
print,'TO=',string(size(TO,/dimensions))
print,'HTAU=',string(size(HTAU,/dimensions))
print,'SL=',string(size(SL,/dimensions))
print,'H1=',string(size(H1,/dimensions))
print,'   '
endif

endfor

endif; fin lecture jusque tstart sans sauvegarder

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Boucle de lecture avec sauvegarde du champ a retourner
; Apres tstart
; 
for istep=0,ntrl-1 do begin
;
NMODE=0 & readu,buffer,NMODE 
TD=0. & readu,buffer,TD
NT=0 & readu,buffer,NT
NXP=0 & readu,buffer,NXP
NYP=0 & readu,buffer,NYP
NSEG=0 & readu,buffer,NSEG
NX=0 & readu,buffer,NX
NY=0 & readu,buffer,NY
HEQUIV=0. & readu,buffer,HEQUIV
TZERO=0. & readu,buffer,TZERO
TENDD=0. & readu,buffer,TENDD
DTD=0. & readu,buffer,DTD
XWD=0. & readu,buffer,XWD
XED=0. & readu,buffer,XED
YSD=0. & readu,buffer,YSD
YND=0. & readu,buffer,YND
TDECAY=0. & readu,buffer,TDECAY
TPLMIN=0. & readu,buffer,TPLMIN
TSTPRT=0 & readu,buffer,TSTPRT
CHKSUM=0 & readu,buffer,CHKSUM
NPRINT=0 & readu,buffer,NPRINT
MASKW=0 & readu,buffer,MASKW
MWNDGF=0 & readu,buffer,MWNDGF
WMXW=0. & readu,buffer,WMXW
WMXE=0. & readu,buffer,WMXE
WMYS=0. & readu,buffer,WMYS
WMYN=0. & readu,buffer,WMYN
PERIOD=0. & readu,buffer,PERIOD
YNORTH=[0.,0.,0.,0.] & readu,buffer,YNORTH
YSOUTH=[0.,0.,0.,0.] & readu,buffer,YSOUTH
XWEST=[0.,0.,0.,0.] & readu,buffer,XWEST
NSEG=0 & readu,buffer,NSEG
NTAPE=0 & readu,buffer,NTAPE
NREWND=0 & readu,buffer,NREWND
NATM=0 & readu,buffer,NATM
;
NS=NSEG+1
;
if keyword_set(dodebug) then begin; test de prompt pendant la lecture
print,'   '
print,'values at step=',istep,' over ',ntrl-1
print,'NMODE='+string(NMODE)
print,'TD='+string(TD)
print,'NT='+string(NT)
print,'NXP='+string(NXP)
print,'NYP='+string(NYP)
print,'NSEG='+string(NSEG)
print,'NX='+string(NX)
print,'NY='+string(NY)
print,'HEQUIV='+string(HEQUIV)
print,'TZERO='+string(TZERO)
print,'TENDD='+string(TENDD)
print,'DTD='+string(DTD)
print,'XWD='+string(XWD)
print,'XED='+string(XED)
print,'YSD='+string(YSD)
print,'YND='+string(YND)
print,'TDECAY='+string(TDECAY)
print,'TPLMIN='+string(TPLMIN)
print,'TSTPRT='+string(TSTPRT)
print,'CHKSUM='+string(CHKSUM)
print,'NPRINT='+string(NPRINT)
print,'MASKW='+string(MASKW)
print,'MWNDGF='+string(MWNDGF)
print,'WMXW='+string(WMXW)
print,'WMXE='+string(WMXE)
print,'WMYS='+string(WMYS)
print,'WMYN='+string(WMYN)
print,'PERIOD='+string(PERIOD)
print,'YNORTH=',string(YNORTH)
print,'YSOUTH=',string(YSOUTH)
print,'XWEST=',string(XWEST)
print,'NSEG='+string(NSEG)
print,'NTAPE='+string(NTAPE)
print,'NREWND='+string(NREWND)
print,'NATM='+string(NATM)
endif
;
;
AKBM=fltarr(nxpl,nmodel,/nozero) & readu,buffer,AKBM
UBM=fltarr(nypl,nxpl,nmodel,/nozero) & readu,buffer,UBM
HBM=fltarr(nypl,nxpl,nmodel,/nozero) & readu,buffer,HBM
ABC=fltarr(nsl,/nozero) & readu,buffer,ABC
ROSS=fltarr(nsl,/nozero) & readu,buffer,ROSS
TR=fltarr(nsl,/nozero) & readu,buffer,TR

UBNDYM=fltarr(nypl,nsl,nmodel,/nozero) & readu,buffer,UBNDYM
HBNDYM=fltarr(nypl,nsl,nmodel,/nozero) & readu,buffer,HBNDYM
H1M=fltarr(nyl,nxl,nmodel,/nozero) & readu,buffer,H1M
U1M=fltarr(nyl,nxl,nmodel,/nozero) & readu,buffer,U1M
V1M=fltarr(nyl,nxl,nmodel,/nozero) & readu,buffer,V1M
;
;print,NATM; toujours =2 donc toujours meme type lecture derniers champs
Q0O=fltarr(nyl,nxl,/nozero) & readu,buffer,Q0O
UO=fltarr(nyl,nxl,/nozero) & readu,buffer,UO
VO=fltarr(nyl,nxl,/nozero) & readu,buffer,VO
iiDO=fltarr(nyl,nxl,/nozero) & readu,buffer,iiDO; normallement DO
TO=fltarr(nyl,nxl,/nozero) & readu,buffer,TO
HTAU=fltarr(nxl,nyl,2,/nozero) & readu,buffer,HTAU
SL=fltarr(nyl,nxl,/nozero) & readu,buffer,SL
H1=fltarr(nyl,nxl,/nozero) & readu,buffer,H1
;
;print, H1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
if keyword_set(dodebug) then begin; test de prompt pendant la lecture

print,'AKBM=',string(size(AKBM,/dimensions))
print,'UBM=',string(size(UBM,/dimensions))
print,'HBM=',string(size(HBM,/dimensions))
print,'ABC=',string(size(ABC,/dimensions))
print,'ROSS=',string(size(ROSS,/dimensions))
print,'TR=',string(size(TR,/dimensions))
print,'UBNDYM=',string(size(UBNDYM,/dimensions))
print,'HBNDYM=',string(size(HBNDYM,/dimensions))
print,'H1M=',string(size(H1M,/dimensions))
print,'U1M=',string(size(U1M,/dimensions))
print,'V1M=',string(size(V1M,/dimensions))
print,'Q0O=',string(size(Q0O,/dimensions))
print,'UO=',string(size(UO,/dimensions))
print,'VO=',string(size(VO,/dimensions))
print,'iiDO=',string(size(iiDO,/dimensions))
print,'TO=',string(size(TO,/dimensions))
print,'HTAU=',string(size(HTAU,/dimensions))
print,'SL=',string(size(SL,/dimensions))
print,'H1=',string(size(H1,/dimensions))
print,'   '
endif
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Sauvegarde du champ a retourner
;
if keyword_set(taux) then begin
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
field(i,j,istep)=HTAU(i,j,0)
endfor
endfor
endif
;
if keyword_set(tauy) then begin
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
field(i,j,istep)=HTAU(i,j,1)
endfor
endfor
endif
;
if keyword_set(therm) then begin
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
field(i,j,istep)=H1(nyl-1-j,i)
endfor
endfor
endif
;
if keyword_set(sla) then begin
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
field(i,j,istep)=SL(nyl-1-j,i)
endfor
endfor
endif
;
if keyword_set(sst) then begin
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
field(i,j,istep)=TO(nyl-1-j,i)
endfor
endfor
endif
;
if keyword_set(doAKBM) then begin
;for i=0,nxpl-1 do begin
;for im=0,nmodel-1 do begin
;field(i,im)=AKBM(i,im)
;endfor
;endfor
field(*,*,istep)=AKBM
endif
;
if keyword_set(doHBM) then begin
for i=0,nxpl-1 do begin
for j=0,nypl-1 do begin
for im=0,nmodel-1 do begin
field(i,j,im,istep)=HBM(nypl-1-j,i,im)
endfor
endfor
endfor
endif

if keyword_set(doUBM) then begin
for i=0,nxpl-1 do begin
for j=0,nypl-1 do begin
for im=0,nmodel-1 do begin
field(i,j,im,istep)=UBM(nypl-1-j,i,im)
endfor
endfor
endfor
endif

if keyword_set(doH1M) then begin
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
for im=0,nmodel-1 do begin
field(i,j,im,istep)=H1M(nyl-1-j,i,im)
endfor
endfor
endfor
endif
;
if keyword_set(doU1M) then begin
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
for im=0,nmodel-1 do begin
field(i,j,im,istep)=U1M(nyl-1-j,i,im)
endfor
endfor
endfor
endif

if keyword_set(doV1M) then begin
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
for im=0,nmodel-1 do begin
field(i,j,im,istep)=V1M(nyl-1-j,i,im)
endfor
endfor
endfor
endif

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
endfor; boucle de lecture sur istep
close,buffer & free_lun,buffer
; fin de lecture
;
; a faire plus tard: lecture 8 champs autres differente si NATM ne 2 !
;print,'NATM=',NATM,' attention lecture differente pour Gill ou SVD, pas fait !'
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Ecriture de tout dans un netcdf (seulement le dernier pas de temps !)
if keyword_set(tonetcdf) then begin
filenet=filehist+'.nc'
myncdfmakefile,filenet
myncdfmakeatt,filenet,'dummy1','INFO1','champs du dernier pas de temps lu dans fichier history du meme nom',/global
myncdfmakeatt,filenet,'dummy2','INFO2','fichier .nc  cree par mylodcagethistory de toolbox IDL Sulian',/global
myncdfmakeatt,filenet,'dummy3','INFO3',' ATTENTION lecture differente pour Gill ou SVD, A FAIRE !',/global
myncdfmakevar,filenet,'TSTART','one',tstartl
myncdfmakeatt,filenet,'TSTART','INFO','tstart=skip initial utilise lors de la lecture de ce history'
myncdfmakevar,filenet,'NTR','one',ntrl
myncdfmakeatt,filenet,'NTR','INFO1','ntr=nombre de steps lus apres tstart.'
myncdfmakeatt,filenet,'NTR','INFO2','Rq: Timestep des champs ici par rapport au debut du history=tstart+ntrl-1 (first=0) '
;
myncdfmakevar,filenet,'NMODE','one',NMODE
myncdfmakevar,filenet,'TD','one',TD
myncdfmakevar,filenet,'NT','one',NT
myncdfmakevar,filenet,'NXP','one',NXP
myncdfmakevar,filenet,'NYP','one',NYP
myncdfmakevar,filenet,'NSEG','one',NSEG
myncdfmakevar,filenet,'NX','one',NX
myncdfmakevar,filenet,'NY','one',NY
myncdfmakevar,filenet,'HEQUIV','one',HEQUIV
myncdfmakevar,filenet,'TZERO','one',TZERO
myncdfmakevar,filenet,'TENDD','one',TENDD
myncdfmakevar,filenet,'DTD','one',DTD
myncdfmakevar,filenet,'XWD','one',XWD
myncdfmakevar,filenet,'XED','one',XED
myncdfmakevar,filenet,'YSD','one',YSD
myncdfmakevar,filenet,'YND','one',YND
myncdfmakevar,filenet,'TDECAY','one',TDECAY
myncdfmakevar,filenet,'TPLMIN','one',TPLMIN
myncdfmakevar,filenet,'TSTPRT','one',TSTPRT
myncdfmakevar,filenet,'CHKSUM','one',CHKSUM
myncdfmakevar,filenet,'NPRINT','one',NPRINT
myncdfmakevar,filenet,'MASKW','one',MASKW
myncdfmakevar,filenet,'MWNDGF','one',MWNDGF
myncdfmakevar,filenet,'WMXW','one',WMXW
myncdfmakevar,filenet,'WMXE','one',WMXE
myncdfmakevar,filenet,'WMYS','one',WMYS
myncdfmakevar,filenet,'WMYN','one',WMYN
myncdfmakevar,filenet,'PERIOD','one',PERIOD
myncdfmakevar,filenet,'YNORTH','four',YNORTH
myncdfmakevar,filenet,'YSOUTH','four',YSOUTH
myncdfmakevar,filenet,'XWEST','four',XWEST
myncdfmakevar,filenet,'NSEG','one',NSEG
myncdfmakevar,filenet,'NTAPE','one',NTAPE
myncdfmakevar,filenet,'NREWND','one',NREWND
myncdfmakevar,filenet,'NATM','one',NATM
;
myncdfmakevar,filenet,'AKBM',['NXPL','NMODEL'],AKBM
myncdfmakevar,filenet,'UBM',['NXPL','NYPL','NMODEL'],UBM
myncdfmakevar,filenet,'HBM',['NXPL','NYPL','NMODEL'],HBM
myncdfmakevar,filenet,'ABC','NSL',ABC
myncdfmakevar,filenet,'ROSS','NSL',NSL
myncdfmakevar,filenet,'TR','NSL',TR
myncdfmakevar,filenet,'UBNDYM',['NYPL','NSL','NMODEL'],UBNDYM
myncdfmakevar,filenet,'HBNDYM',['NYPL','NSL','NMODEL'],HBNDYM
myncdfmakevar,filenet,'H1M',['NYL','NXL','NMODEL'],H1M
myncdfmakevar,filenet,'U1M',['NYL','NXL','NMODEL'],U1M
myncdfmakevar,filenet,'V1M',['NYL','NXL','NMODEL'],V1M
;
myncdfmakevar,filenet,'Q0O',['NYL','NXL'],Q0O
myncdfmakevar,filenet,'UO',['NYL','NXL'],UO
myncdfmakevar,filenet,'VO',['NYL','NXL'],VO
myncdfmakevar,filenet,'DO',['NYL','NXL'],iiDO
myncdfmakevar,filenet,'TO',['NYL','NXL'],TO
myncdfmakevar,filenet,'HTAU',['NXL','NYL','two'],HTAU
myncdfmakevar,filenet,'SL',['NYL','NXL'],SL
myncdfmakevar,filenet,'H1',['NYL','NXL'],H1

endif
;
;
end










