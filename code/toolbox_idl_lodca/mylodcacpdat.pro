Pro mylodcacpdat,filedatin,filedatout,fromref=fromref,fromuse=fromuse,touse=touse
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Pro pour copier un fichier lodca.dat
; Sulian Thual 2011
;
;;;;;;;;;;;;;;;; INPUTS:
;
;
; - filedatin: nom du fichier lodca.dat a copier
; - filedatout: nom du fichier lodca.dat pour copier
;
;;;;;;;;;;;;;;;; KEYWORDS:
;
; /fromref: si mis, copie plutot le lodcaref.dat (in idl toolbox) en filedatout
; /fromuse: si mis, copie plutot le lodca.dat dans la version utilisee de lodca en filedatout
;/touse: si mis, le fichier f iledatout est lodca.dat dans la version utilisee de lodca
;
; Remarques:  
; - toref est impossible car il vaut mieux proteger ce fichier de backup)
; - /fromuse et /touse en meme temps ne sert a rien 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; fichier a copier
filedat=filedatin
;
; fichier lodca.dat a copier (si autre)
if keyword_set(fromref) then begin; reference toolbox idl
dirtoolbox='/home/sulian/Work/IDL/toolbox_idl/toolbox_idl_lodca/'
filedat=dirtoolbox+'lodcaref.dat'
endif
if keyword_set(fromuse) then begin; fichier en cours utilisation dans LODCA dossier
dirlodca=mylodcaversion()
filedat=dirlodca+'lodca.dat'
endif
if keyword_set(touse) then begin; fichier en cours utilisation dans LODCA dossier
dirlodca=mylodcaversion()
filedatout=dirlodca+'lodca.dat'
endif
;
pass='cp '+filedat+' '+filedatout
spawn,pass








end