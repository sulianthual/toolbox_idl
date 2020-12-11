Pro myncdfmakeatt,filename,varname,attribute,valor,global=global,delete=delete,new=new
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for adding or changing value of an attribute 
; in an existing netcdf file with IDL
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUTS :
;
; -filename : filename of the netcdf file. Must already exist.
; -varname : name of the variable to put attribute in.
;            varname is of no use if global is set, but must be set anyway.
; -attribute : name of the attribute to be created or overwrited.
; -valor : valor of the attribute to write or overwrite.
; -global(optionnal): If set, attribute is global (and varname is of no use, but must be set)
; -delete(optionnal): If set, only deletes the attribute. 
;                     In this case valor is of no use, but must be set.
;                     BEWARE, if you have various variables with the same attribute, you may
;                     not delete the attribute correpsonding to your variable(code should be meliorated).
;
; EXAMPLES :
; myncdfmakeatt,'test.nc','TEMP','UNITS','°C';=>creates attribute 'UNITS' (='°C') for variable 'TEMP'
; myncdfmakeatt,'test.nc','dummy','NAME','TEST',/global;=>creates global attribute 'NAME'='TEST', dummy is the unusued variable
; myncdfmakeatt,'test.nc','TEMP','UNITS',/delete;=> deletes attribute UNITS, but BEWARE it may be for other variable than 'TEMP'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; open existing netcdf file
id=ncdf_open(filename,/WRITE)
; pass in define mode
ncdf_control,id,/redef
;
if keyword_set(global) then begin
;
;
; if delete is on, look for the global attribute to delete
if keyword_set(delete) then begin
info=ncdf_inquire(id)
for gatt=0,info.ngatts-1 do begin
gattname=ncdf_attname(id,gatt,/global)
if (gattname eq attribute) then begin
ncdf_attdel,id,attribute,/global
endif
endfor
endif else begin
; if delete is off, just overwrite the global attribute
; CHECK THAT VALOR TYPE MATCHS ORIGINAL FOR WRITING ?
ncdf_attput,id,attribute,valor,/global
endelse
;
ncdf_close,id
;
endif else begin
;
myvarid=ncdf_varid(id,varname)
; check that variable exists in netcdf file
if (myvarid eq -1) then begin
print,',myncdfputatt : variable "',varname,'" is inexistent, returning'
ncdf_close,id
return
endif
;
; if delete is on, look for the attribute to delete
if keyword_set(delete) then begin
infovar=ncdf_varinq(id,myvarid)
for att=0,infovar.natts-1 do begin
attname=ncdf_attname(id,myvarid,att)
if (attname eq attribute) then begin
ncdf_attdel,id,myvarid,attribute
endif
endfor
endif else begin
; if delete is off, just overwrite the attribute
; CHECK THAT VALOR TYPE MATCHS ORIGINAL FOR WRITING ?
ncdf_attput,id,myvarid,attribute,valor
endelse
;
ncdf_close,id
;
endelse; end of cases (global attribute or variable attribute)
;

end



