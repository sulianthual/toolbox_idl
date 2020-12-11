function myncdfgetatts,filename,varname,global=global
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function for reading attributes names of a variable(or globals) from a netcdf file
;  Sulian Thual, IRD-IMARPE 2008
;
; - filename : the netcdf file name
; -varname : the variable to get attributes names from.
; -global : if keyword set, gives names of global attributes, rather than of the variable.
;
; 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; open in data mode
id=ncdf_open(filename,/NOWRITE)
;
if keyword_set(global) then begin; case global attributes
infos=ncdf_inquire(id)
natts=infos.Ngatts
if (natts gt 0) then nams=strarr(natts) else nams=''
if (natts gt 0) then begin
for pii=0,natts-1 do begin
nams(pii)=ncdf_attname(id,pii,/global)
endfor
endif
;
endif else begin; case attributes from a variable
varid=ncdf_varid(id,varname)
infos=ncdf_varinq(id,varid)
natts=infos.Natts
if (natts gt 0) then nams=strarr(natts) else nams=''
if (natts gt 0) then begin
for pii=0,natts-1 do begin
nams(pii)=ncdf_attname(id,varid,pii)
endfor
endif
endelse
;
ncdf_close,id
;
return,nams
;
end