function myncdfgetvars,filename
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function for reading variables names from a netcdf file
;  Sulian Thual, IRD-IMARPE 2008
;
; - filename : the netcdf file name
;
; 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; open in data mode
id=ncdf_open(filename,/NOWRITE)
;
infos=ncdf_inquire(id)
nvars=infos.Nvars
varnames=strarr(nvars)
for piv=0,nvars-1 do begin
varid=piv
varinfos=ncdf_varinq(id,varid)
varnames(piv)=varinfos.Name
endfor
;
ncdf_close,id
;
return,varnames
;
end