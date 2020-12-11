Pro mylodcaputhistory,filehistin,filehistout,tstart,ntr,field,erasein=erasein,replace=replace,dodebug=dodebug, $
    taux=taux,tauy=tauy,therm=therm,sla=sla,sst=sst,$
    doAKBM=doAKBM,doHBM=doHBM
compile_opt hidden

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR REECRIRE UN HISTORY DE LODCA(Dewitte2000) EN MODIFIANT UNE VARIABLE 
; Sulian Thual 2011
;
; Input: 
;
;-filehistin: le fichier history en entree
; 
; -tstart: time step (month, starting from 0) relatively to filehistin at which starts
;          to write the field in the filehistout file. 
;
; -ntr :  number of time steps of fields. Must correspond to the last dimension of field
;         This is useful if ntr=1, to write differently   
; 
;-field: le champ UNIQUE a modifier dans le fichier history (choisi selon le keyword associe)
; 
; - /taux,/tauy,/therm,/sla,/sst...=> choisir SEULEMENT un de ces keyword, qui correspondra au champ a modifier
;   idem doAKBM,doHBM
;
; Output:
;
; -filehistout: le fichier history en sortie avec la variable modifiee
;               ATTENTION CE FICHIER NE DOIT PAS ETRE LE FICHIER filehistin !
;               la taille de ce fichier est NTR, et reprend les variables du filehistin (sauf field) decalees depuis tstart
; Keywords:
;
; -/erasein: if set, apres execution on efface le fichier filehistin !
;
; -/replace: if set, apres execution le fichier filehistout est copie pour remplacer filehistin
;            et filehistout est ensuite efface. 
; 
; /dodebug: if set, prompts values when reading
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Check : filehistin ne filehistout
if (filehistin eq filehistout) then begin
print,'mylodcaputhistory: input history file cannot be output history file'
stop
endif
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Parametres de grille lodca
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
openr,buffer,filehistin,/get_lun,/f77_unformatted

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Lecture seule du fichier histin sans ecriture dans histout, pour istep<tstart
;
if (tstart gt 0) then begin

;
for istep=0,tstart-1 do begin
;print,'skipping=',istep,tstart-1
;
; LECTURE filehistin
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
AKBM=fltarr(nxpl,nmodel) & readu,buffer,AKBM
UBM=fltarr(nypl,nxpl,nmodel) & readu,buffer,UBM
HBM=fltarr(nypl,nxpl,nmodel) & readu,buffer,HBM
ABC=fltarr(nsl) & readu,buffer,ABC
ROSS=fltarr(nsl) & readu,buffer,ROSS
TR=fltarr(nsl) & readu,buffer,TR
UBNDYM=fltarr(nypl,nsl,nmodel) & readu,buffer,UBNDYM
HBNDYM=fltarr(nypl,nsl,nmodel) & readu,buffer,HBNDYM
H1M=fltarr(nyl,nxl,nmodel) & readu,buffer,H1M
U1M=fltarr(nyl,nxl,nmodel) & readu,buffer,U1M
V1M=fltarr(nyl,nxl,nmodel) & readu,buffer,V1M
;
Q0O=fltarr(nyl,nxl) & readu,buffer,Q0O
UO=fltarr(nyl,nxl) & readu,buffer,UO
VO=fltarr(nyl,nxl) & readu,buffer,VO
iiDO=fltarr(nyl,nxl) & readu,buffer,iiDO; normallement DO
TO=fltarr(nyl,nxl) & readu,buffer,TO
HTAU=fltarr(nxl,nyl,2) & readu,buffer,HTAU
SL=fltarr(nyl,nxl) & readu,buffer,SL
H1=fltarr(nyl,nxl) & readu,buffer,H1
;
if keyword_set(dodebug) then begin; test de prompt pendant la lecture
print,'   '
print,'BEFORE TSTART, values at step=',istep,' over ',tstart-1
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
;
endfor

endif; fin lecture jusque tstart sans sauvegarder
;

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; Lecture et ecriture jointe des fichiers histin et histout

openw,buffer2,filehistout,/get_lun,/f77_unformatted
;
for istep=0,ntr-1 do begin; lecture et ecriture 
;print,'writing=',istep,ntr-1
;
; LECTURE filehistin
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
AKBM=fltarr(nxpl,nmodel) & readu,buffer,AKBM
UBM=fltarr(nypl,nxpl,nmodel) & readu,buffer,UBM
HBM=fltarr(nypl,nxpl,nmodel) & readu,buffer,HBM
ABC=fltarr(nsl) & readu,buffer,ABC
ROSS=fltarr(nsl) & readu,buffer,ROSS
TR=fltarr(nsl) & readu,buffer,TR
UBNDYM=fltarr(nypl,nsl,nmodel) & readu,buffer,UBNDYM
HBNDYM=fltarr(nypl,nsl,nmodel) & readu,buffer,HBNDYM
H1M=fltarr(nyl,nxl,nmodel) & readu,buffer,H1M
U1M=fltarr(nyl,nxl,nmodel) & readu,buffer,U1M
V1M=fltarr(nyl,nxl,nmodel) & readu,buffer,V1M
;
Q0O=fltarr(nyl,nxl) & readu,buffer,Q0O
UO=fltarr(nyl,nxl) & readu,buffer,UO
VO=fltarr(nyl,nxl) & readu,buffer,VO
iiDO=fltarr(nyl,nxl) & readu,buffer,iiDO; normallement DO
TO=fltarr(nyl,nxl) & readu,buffer,TO
HTAU=fltarr(nxl,nyl,2) & readu,buffer,HTAU
SL=fltarr(nyl,nxl) & readu,buffer,SL
H1=fltarr(nyl,nxl) & readu,buffer,H1
;
if keyword_set(dodebug) then begin; test de prompt pendant la lecture
print,'   '
print,'AFTER TSTART, values at step=',istep,' over ',ntr-1
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
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; MODIFICATIONS du champ choisi
;
if keyword_set(taux) then begin
;print,'taux puthistory'
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
if (ntr le 1) then HTAU(i,j,0)=field(i,j) else HTAU(i,j,0)=field(i,j,istep)
endfor
endfor
endif
;
if keyword_set(tauy) then begin
;print,'tauy puthistory'
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
if (ntr le 1) then HTAU(i,j,1)=field(i,j) else HTAU(i,j,1)=field(i,j,istep)
endfor
endfor
endif
;
if keyword_set(therm) then begin
;print,'therm puthistory'
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
if (ntr le 1) then H1(nyl-1-j,i)=field(i,j) else H1(nyl-1-j,i)=field(i,j,istep)  
endfor
endfor
endif
;
if keyword_set(sla) then begin
;print,'sla puthistory'
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
if (ntr le 1) then begin
SL(nyl-1-j,i)=field(i,j) 
endif else begin
SL(nyl-1-j,i)=field(i,j,istep) 
endelse
endfor
endfor
endif
;
if keyword_set(sst) then begin
;print,'sst puthistory'
for i=0,nxl-1 do begin
for j=0,nyl-1 do begin
if (ntr le 1) then TO(nyl-1-j,i)=field(i,j) else TO(nyl-1-j,i)=field(i,j,istep) 
endfor
endfor
endif
;
if keyword_set(doAKBM) then begin
;for i=0,nxpl-1 do begin
;for im=0,nmodel-1 do begin
;AKBM(i,im)=field(i,im)
;endfor
;endfor
AKBM=field
endif
;
if keyword_set(doHBM) then begin
for i=0,nxpl-1 do begin
for j=0,nypl-1 do begin
for im=0,nmodel-1 do begin
HBM(j,i,im)=field(i,j,im)
endfor
endfor
endfor
endif
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; ECRITURE filehistout: ATTENTION, TOUT DOIT ETRE EN 32 BITS ICI !
; 
; Double=64 bits impossible, seulement FLOAT=32 bits !!!
; Aussi les integer: LONG=32 bits au lieu de FIX=16 bits sinon marche pas !!!!!!
;
writeu,buffer2,long(NMODE)
writeu,buffer2,float(TD)
writeu,buffer2,long(NT)
writeu,buffer2,long(NXP)
writeu,buffer2,long(NYP)
writeu,buffer2,long(NSEG)
writeu,buffer2,long(NX)
writeu,buffer2,long(NY)
writeu,buffer2,float(HEQUIV)
writeu,buffer2,float(TZERO)
writeu,buffer2,float(TENDD)
writeu,buffer2,float(DTD)
writeu,buffer2,float(XWD)
writeu,buffer2,float(XED)
writeu,buffer2,float(YSD)
writeu,buffer2,float(YND)
writeu,buffer2,float(TDECAY)
writeu,buffer2,float(TPLMIN)
writeu,buffer2,long(TSTPRT)
writeu,buffer2,long(CHKSUM)
writeu,buffer2,long(NPRINT)
writeu,buffer2,long(MASKW)
writeu,buffer2,long(MWNDGF)
writeu,buffer2,float(WMXW)
writeu,buffer2,float(WMXE)
writeu,buffer2,float(WMYS)
writeu,buffer2,float(WMYN)
writeu,buffer2,float(PERIOD)
writeu,buffer2,float(YNORTH)
writeu,buffer2,float(YSOUTH)
writeu,buffer2,float(XWEST)
writeu,buffer2,long(NSEG)
writeu,buffer2,long(NTAPE)
writeu,buffer2,long(NREWND)
writeu,buffer2,long(NATM)
;
writeu,buffer2,float(AKBM)
writeu,buffer2,float(UBM)
writeu,buffer2,float(HBM)
writeu,buffer2,float(ABC)
writeu,buffer2,float(ROSS)
writeu,buffer2,float(TR)
writeu,buffer2,float(UBNDYM)
writeu,buffer2,float(HBNDYM)
writeu,buffer2,float(H1M)
writeu,buffer2,float(U1M)
writeu,buffer2,float(V1M)
;
writeu,buffer2,float(Q0O)
writeu,buffer2,float(UO)
writeu,buffer2,float(VO)
writeu,buffer2,float(iiDO); normallement DO
writeu,buffer2,float(TO)
writeu,buffer2,float(HTAU)
writeu,buffer2,float(SL)
writeu,buffer2,float(H1)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; fin boucle en temps lecture et ecriture
endfor
;
; REWIND FILE
if (0 eq 1) then begin
point_lun,buffer2,0
endif

close,buffer2 
free_lun,buffer2
close,buffer 
free_lun,buffer


;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Modification a la fin des fichiers optionnelle

if keyword_set(erasein) then begin
pass=mygoodstring('\rm '+filehistin,/blanks)
spawn,pass
endif
;
if keyword_set(replace) then begin
pass=mygoodstring('\rm '+filehistin,/blanks)
spawn,pass
pass=mygoodstring('cp '+filehistout+' '+filehistin,/blanks)
spawn,pass
pass=mygoodstring('\rm '+filehistout,/blanks)
spawn,pass
endif
;


end












