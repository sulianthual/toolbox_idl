function myncdfgetdim,filename,dimname
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for reading dimension( ie size) from a netcdf file
;  Sulian Thual, IRD-IMARPE 2008
;
; - filename : the netcdf file name
; -dimname : the dimension to be readed
;
; EXAMPLE :
; dim=myncdfgetdim('file.nc','X')
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; open in data mode
id=ncdf_open(filename,/NOWRITE)
;
dimid=ncdf_dimid(id,dimname)
;
ncdf_diminq,id,dimid,dummydimname,dimsize
;
ncdf_close,id
;
return,dimsize
;
end