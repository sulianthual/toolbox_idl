Pro mylodcaparams,field,filedat,fromref=fromref,$
    Pn=Pn,cn=cn,scln=scln,epsn=epsn
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR MODIFICATION DES PARAMETRES DE LODCA (Dewitte2000) PAR EDITION DU LODCA.DAT
; REMARQUE: CERTAINS PARAMETRES SONT DEFINIS DANS mylodca POUR UN RUN, ICI ON MODIFIE DES PARAMETRES DIFFERENTS
;           QUI NECESSITENT D ETRE SPECIFIES NUMERIQUEMENT
; Sulian Thual 2011
;
;;;;;;;;;;;;;;;; INPUTS:
;
;
; -field: un champ de parametres UNIQUE remplacant les parametres correspondant dans le lodca.dat
;         le type de parametre UNIQUE modifie depend du keyword (UNIQUE) choisi
;         Si au sein de ce meme field un param est NaN il ne sera pas modifie
;        (exemple: field=[0.6,0.4,NaN] et keyword /Pn alors on modifie seulement P1 et P2)
;
; -/Pn,/cn,/scln,/epsn: choisir par keyword le type de parametre a modifie
;                      
;
;;;;;;;;;;;;;;;; OUTPUTS:
;
; -modifie le lodca.dat du repertoire lodca (version utilisee) avec le nouveau field de parametres
;
;;;;;;;;;;;;;;;; KEYWORDS:
;
; /fromref: if set, reintialise lodca.dat (in lodca folder) from lodcaref.dat (in idl toolbox) before modifications
;
; Pn=[P1,P2,P3]; if set, defines the Pn parameters (with Boris convention)
;
; cn=[c1,c2,c3]; if set, defines the cn parameters (m.s-1)
;
; scln=[scl1,scl2,scl3]; if set, defines the scln parameters
;
; epsn=[To,q]; if set, defines the friction coefficients,
;              where To is decay timescale (months,30 default) of M1, q for power law (=0.5 default)
;
; filedat='lodca_nn.dat': si mis, donne le fichier dat a modifier. Sinon par defaut (si seulement un parametre mis) c'est le fichier dans le 
;                                          repertoire lodca en courds d utilisation qui est modifié. 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; version utilisee de lodca
dirlodca=mylodcaversion()
;
; fichier lodca.dat a modifier
nparams0=n_params()
if (nparams0 eq 1) then begin
filedat=dirlodca+'lodca.dat'
endif 
;
; recopie fichier de reference 
if keyword_set(fromref) then begin
dirtoolbox='/home/sulian/Work/IDL/toolbox_idl/toolbox_idl_lodca/'
pass='cp '+mygoodstring(dirtoolbox+'lodcaref.dat')+' '+filedat
spawn,pass
endif
;
; lecture du fichier de reference lodca.dat
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
pass=field(0) & if (finite(pass) ne 0) then linesdat(37)='PHI10  =  '+mygoodstring(pass)
pass=field(1) & if (finite(pass) ne 0) then linesdat(38)='PHI20  =  '+mygoodstring(pass)
pass=field(2) & if (finite(pass) ne 0) then linesdat(39)='PHI30  =  '+mygoodstring(pass)
endif
;
if keyword_set(cn) then begin
pass=field(0) & if (finite(pass) ne 0) then linesdat(40)='CWAVE1 =  '+mygoodstring(pass)
pass=field(1) & if (finite(pass) ne 0) then linesdat(41)='CWAVE2 =  '+mygoodstring(pass)
pass=field(2) & if (finite(pass) ne 0) then linesdat(42)='CWAVE3 =  '+mygoodstring(pass)
endif
;
if keyword_set(scln) then begin
pass=field(0) & if (finite(pass) ne 0) then linesdat(43)='SCL1   =  '+mygoodstring(pass)
pass=field(1) & if (finite(pass) ne 0) then linesdat(44)='SCL2   =  '+mygoodstring(pass)
pass=field(2) & if (finite(pass) ne 0) then linesdat(45)='SCL3   =  '+mygoodstring(pass)
endif
;
if keyword_set(epsn) then begin
pass=field(0) & if (finite(pass) ne 0) then linesdat(56)='TDECA1 =   '+mygoodstring(pass)
pass=field(1) & if (finite(pass) ne 0) then linesdat(57)='Q      =   '+mygoodstring(pass)
endif
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Reecriture du fichier lodca.dat 
get_lun,buffer & openw,buffer,filedat
for ilin=1,nlines-1 do printf,buffer,linesdat(ilin)
close,buffer & free_lun,buffer
;








end