function myncdfgetatt,filename,varname,attname,global=global
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for reading attribute from a netcdf file
;  Sulian Thual, IRD-IMARPE 2008
;
; - filename : the netcdf file name
; - varname : the variable to read attribute from, MUST NOT BE SET if keyword_set(global)
;  -attname : the attribute to be readed (its name)
; -global ; if set, reads a global attribute
;
; EXAMPLE : 
; a=myncdfgetatt('file.nc','TEMP','UNITS')
; a=myncdfgetatt('file.nc','one_global_attribute',/global)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; open in data mode
id=ncdf_open(filename,/NOWRITE)
;
; fctmt en global
if keyword_set(global) then begin
attname=varname; varname must not be specified, just read attname
; check that attribute exists
attinfo=ncdf_attinq(id,attname,/global)
if (attinfo.length eq 0) then begin
print,'myncdfgetatt : global attribute',attname,' does not exist, returning'
ncdf_close,id
return,0
endif else begin
ncdf_attget,id,attname,attvalue,/global
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; grosse triche attention
if (size(attvalue,/type) eq 1) then attvalue=string(attvalue)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; grosse triche attention
return,attvalue
endelse
;
endif else begin
;
; check that variable exists
varid=ncdf_varid(id,varname)
if (varid eq -1) then begin
print,'myncdfgetatt : variable',varname,' does not exist, returning'
ncdf_close,id
return,0
endif else begin
; check that attribute exists
attinfo=ncdf_attinq(id,varid,attname)
if (attinfo.length eq 0) then begin
print,'myncdfgetatt : attribute',attname,'for variable',varname,' does not exist, returning'
ncdf_close,id
return,0
endif else begin
ncdf_attget,id,varid,attname,attvalue
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; grosse triche attention
if (size(attvalue,/type) eq 1) then attvalue=string(attvalue)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; grosse triche attention
return,attvalue
endelse
endelse
;
endelse
;
ncdf_close,id
;
end