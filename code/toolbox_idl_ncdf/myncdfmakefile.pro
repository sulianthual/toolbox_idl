Pro myncdfmakefile,filename
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for writing an empty ncdf file
;
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUTS :
;
; -filename : filename of the netcdf file to be created. If file already exists it will be overwrited.
;
; EXAMPLE :
; myncdfmakefile,'testncdf.nc'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; create new netcdf file or entirely overwrite existing netcdf file
id = NCDF_CREATE(filename, /CLOBBER)
;
ncdf_close,id
;

;
end