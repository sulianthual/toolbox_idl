Pro myncdfmakedim,filename,dimension,dimsize
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for adding a dimension in an existing netcdf file
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUTS :
;
; -filename : filename of the netcdf file (string). MUST ALREADY EXIST.
; -dimension : name of the dimension (string) to be added.
; -dimsize : size of the new dimension (integer) to be added.
;            
; NOTE : If dimension already exits, program quits 
;(you cannot change or delete a dimension in a netcdf file with IDL).
;
;  EXAMPLE : myncdfmakedim,'file.nc','X',10
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; open existing netcdf file
id=ncdf_open(filename,/WRITE)
; pass in define mode
ncdf_control,id,/redef
;
; check if dimension already exits
dimid=ncdf_dimid(id,dimension)
if (dimid eq -1) then begin
print,'(Do not mind precedent message)'
mydimid=ncdf_dimdef(id,dimension,dimsize)
endif else begin
print,'myncdfmakedim : dim "',dimension,'" already exists, returning'
ncdf_close,id
return
endelse
;
ncdf_close,id
;
end



