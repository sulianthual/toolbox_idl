Pro mylodca,filedat,recompile=recompile
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR EXECUTION DE LODCA (Dewitte2000)
; Sulian Thual 2011
;
; INPUT:
;
; filedat: name of output file where to copy the used lodca.dat of the simulation (**** DEFINI DEPUIS LE REPERTOIRE LODCA !****)
;          (useful for backup or to read the created history file)
;
; OUTPUTS:
;
; -run lodca from the previously edited lodca.dat in the CURRENT version of lodca
;
; -after the run, copies the lodca.dat to another location for eventual backup
;  NOTE: if filedat='lodca.dat' only juste rewrites the file the same way, e.g. does nothing
;
; KEYWORDS:
;
; /recompile: if set, recompiles lodca before execution
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; directory actuel (VERSION UTILISEE) de lodca
dirlodca=mylodcaversion()
;
;print,'    '
;print,' Starting mylodca... '
cd, dirlodca,current=workdir
if keyword_set(recompile) then begin
spawn,'\rm *.o'
spawn,'make'
endif
;spawn,'\rm blabla.txt'
;spawn,'./lodca<lodca.dat'; prompt des comments
spawn,'./lodca<lodca.dat>blabla.txt'; comments dans fichier texte
pass=mygoodstring('cp lodca.dat '+filedat,/blanks) & spawn,pass; copie depuis repertoire lodca !
cd, workdir
;print,' Executed mylodca... '
;print,'    '

;
;







end