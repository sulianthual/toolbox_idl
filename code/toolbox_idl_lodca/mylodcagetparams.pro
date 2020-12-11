function mylodcagetparams,filedat,fromref=fromref,fromuse=fromuse,$
    Pn=Pn,cn=cn,scln=scln,layer1=layer1
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Fonction pour lire un parametre dans un lodca.at
; Sulian Thual 2011
;
;;;;;;;;;;;;;;;; INPUTS:
;
;
; -filedat: nom du fichier lodca.dat a lire
;
; -/Pn,/cn,/scln : choisir par keyword le type de parametre a lire: 
;                       Rq pour Pn,cn,scln... on lit un vecteur 3 elements
;                      
;
;;;;;;;;;;;;;;;; KEYWORDS:
;
; /fromref: si mis, lis plutot dans lodcaref.dat (in idl toolbox)
; /fromuse: si mis, lis plutot le lodca.dat dans la version utilisee de lodca
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; fichier lodca.dat lu (si autre)
if keyword_set(fromref) then begin
dirtoolbox='/home/sulian/Work/IDL/toolbox_idl/toolbox_idl_lodca/'
filedat=dirtoolbox+'lodcaref.dat'
endif
if keyword_set(fromuse) then begin
dirlodca=mylodcaversion()
filedat=dirlodca+'lodca.dat'
endif
;
; lecture du lodca.dat
get_lun,buffer & openr,buffer,filedat
nlines=124 & linesdat=strarr(nlines)
for ilin=1,nlines-1 do begin; les lignes correspondent a un F11
pass=string(0) & readf,buffer,pass
linesdat(ilin)=pass
endfor
close,buffer & free_lun,buffer
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Changement du lodca.dat selon les modifications choisies
;
if keyword_set(Pn) then begin
field=[float((strsplit(linesdat(37)," ",/extract))(2)),$
float((strsplit(linesdat(38)," ",/extract))(2)),$
float((strsplit(linesdat(39)," ",/extract))(2))]
endif
;
if keyword_set(cn) then begin
field=[float((strsplit(linesdat(40)," ",/extract))(2)),$
float((strsplit(linesdat(41)," ",/extract))(2)),$
float((strsplit(linesdat(42)," ",/extract))(2))]
endif
;
if keyword_set(scln) then begin
field=[float((strsplit(linesdat(43)," ",/extract))(2)),$
float((strsplit(linesdat(44)," ",/extract))(2)),$
float((strsplit(linesdat(45)," ",/extract))(2))]
endif
;
if keyword_set(layer1) then begin
field=float((strsplit(linesdat(28)," ",/extract))(2))
endif
return,field
;








end