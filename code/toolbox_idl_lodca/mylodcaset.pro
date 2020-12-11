Pro mylodcaset,filerestart,filehistory,filewind,runtype,runlength,runmonth,$
    allhistory=allhistory,donetcdf=donetcdf,atmgill=atmgill,wind10days=wind10days,$
    fromref=fromref
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR CONFIGURER UN RUN LODCA AVANT EXECUTION(Dewitte2000)
; REMARQUE: MODIFIE lodca.dat dans le repertoire lodca utilise  (voir aussi mylodcaparams.pro)
; Sulian Thual 2011
;
;;;;;;;;;;;;;;;; INPUTS:
;
; filerestart: file where to find initial conditions (**** DEFINI DEPUIS LE REPERTOIRE LODCA !****)
;              by default, initial conditions are taken from the first timestep of this file
;
; filehistory: file where to write history conditions for latter restart (**** DEFINI DEPUIS LE REPERTOIRE LODCA !****)
;              by default, only the last simulated timestep is written
;
; filewind: file where to read wind stress forcing (**** DEFINI DEPUIS LE REPERTOIRE LODCA !****)
;           by default, wind is readed from the first time step
;           wind forcing is always centered on the 15th of the month
;           not needed in coupled simulations but readen anyway
;
;
; runtype: 'C', 'F', 'N' for type of run Coupled, Forced, Nudged
;
; runlength: length of the run in months (1 is minimum)
;
; runmonth: month of the year (from 1 to 12 and modulo(12) ) at which are the initial conditions
;           this is to make the climatological files agree
;
;;;;;;;;;;;;;;;; OUTPUTS:
;
; -actualise lodca.dat dans le repertoire LODCA utilise, par copie et modification de lodcatype.dat (present dans la toolbox)
;
; - The parameters by default for the run are as follow:
;   * 3 baroclinic modes with parameters (Pn,cn,scln,en) from Dewitte2000
;   * climatology files from Boris
;   * statistical atmosphere from Boris in 'C' and 'N' runs
;   * no netcdf output
;   * uses lodcatype.dat as a reference lodca.dat file (donc ne PAS MODIFIER ce fichier)
;   * write only last timestep in history therefore NREWND=11
;
;;;;;;;;;;;;;;;; KEYWORDS:
;
;
; /donetcdf: if set, writes netcdf output (at each timestep including initial conditions) in run.c/std/output.nc
;
; /allhistory: if set, writes history conditions at each simulated timestep (including initial conditions)
;
; /wind10days: if set, wind file is readed every ten days (it must start on the 15th of the month, then the 25th and 5th)
;
; /atmgill: if set, uses the Gill atmosphere rather than the statistical atmosphere
;
; /fromref: if set, reintialise lodca.dat (in lodca folder) from lodcaref.dat (in idl toolbox) before modifications
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; reinitialistion lodca.dat dpeuis lodcaref.dat
dirlodca=mylodcaversion()
if keyword_set(fromref) then begin
dirtoolbox='/home/sulian/Work/IDL/toolbox_idl/toolbox_idl_lodca/'
pass='cp '+mygoodstring(dirtoolbox+'lodcaref.dat')+' '+mygoodstring(dirlodca+'lodca.dat') 
spawn,pass
endif
;
filedat=dirlodca+'lodca.dat'; lodca.dat to modify
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
; Changement du lodca.dat selon les modifications choisies
;
; fichiers entree sortie:
linesdat(1)=filerestart
linesdat(2)=filehistory
linesdat(6)=filewind
linesdat(24)=mygoodstring('RUNTYPE = '+runtype,/blanks)
if keyword_set(allhistory) then linesdat(83)='NREWND =  10'; tq ecrit tous les steps history
if keyword_set(donetcdf) then linesdat(18)='DNCDF =   1'; tq ecrit fichier netcdf output.nc
if keyword_set(atmgill) then linesdat(33)='NTMSTAT=  0'; tq met atmosphere de gill au lieu de statistique
if keyword_set(wind10days) then linesdat(19)='DTWIND =  10'; tq utilise vent a 10 jours
;
; Pour la clim: IT1= TZERO+0.5 (must be 1 to 12 pour choix du mois,TZERO=0.5+runmonth-1)
runmonth=myintmodulo(runmonth,1,12) & passtzero=0.5+runmonth-1; TZERO !
linesdat(49)=mygoodstring('TZERO = '+string(passtzero),/blanks)

; Pour le restart: NSKIP=TFIND-TZERO+0.5 (must be 0.5 tq commence debut restart,TFIND=TZERO)
linesdat(23)=mygoodstring('TFIND = '+string(passtzero),/blanks)

; Pour le run: runlength=TENDD-TZERO (must be TENDD=TZERO+runlength) 
passtendd=passtzero+runlength & linesdat(50)=mygoodstring('TENDD = '+string(passtendd),/blanks)
;
; Pour le vent: lodca (V6 et superieurs) est modife tq T0WIND est directement le nombre de skips a faire (donc T0WIND=0)
passt0wind=0 & linesdat(21)=mygoodstring('T0WIND =  '+string(passt0wind),/blanks)
; Remarque; dans la version 5 T0WIND=-fix(ZERO) tq garde meme axes que boris, mais version FAUSSE

;
;
; ecriture du fichier lodca.dat a utiliser sous lodca
get_lun,buffer & openw,buffer,filedat
for ilin=1,nlines-1 do printf,buffer,linesdat(ilin)
close,buffer & free_lun,buffer
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;







end