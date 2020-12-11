function mylodcaversion,newversion
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR RECUPERER OU DEFINIR LA VERSION DE LODCA(Dewitte2000) UTILISEE PAR LA TOOLBOX IDL
; Sulian Thual 2011
;
; Output:
;
; -retourne la version de lodca (nom du directory lodca) utilise, si newversion non defini
;
; Keyword:
;
; -Si newversion est defini, il donne le nouveau chemin acces de la version lodca a utiliser
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; fichier lodcaversion.dat ou est ecrit la version de lodca utilisee par la toolbox idl
fileversion='/home/sulian/Work/IDL/toolbox_idl/toolbox_idl_lodca/lodcaversion.dat'
;
; Nom de la version (directory lodca) utilise
currentversion=string(0)

; abscence de redefinition de la version, lit et retourne current version
if (n_params(0) eq 0) then begin
get_lun,buffer & openr,buffer,fileversion
readf,buffer,currentversion
close,buffer & free_lun,buffer
endif
;
; redefinition de la version, ecriture dans le fichier lodcaversion.dat et retour
if (n_params(0) ne 0) then begin
get_lun,buffer & openw,buffer,fileversion
printf,buffer,newversion
close,buffer & free_lun,buffer
currentversion=newversion
endif
;
return,currentversion


end