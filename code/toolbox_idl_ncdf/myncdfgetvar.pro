function myncdfgetvar,filename,varname,rmin=rmin,rmax=rmax
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for reading variable from a netcdf file
;  Sulian Thual, IRD-IMARPE 2008
;
; -filename : the netcdf file name
; -varname : the variable to be readed
; -rmin : if set, reading position start for each dimension (from 0, IDL indexing). 
;         If set to -1 for a dimension, starts
;         from first point.  
; -rmax : if set, reading position end for each dimension (from 0, IDL indexing). 
;         If set to -1 for a dimension, ends
;         on last point.  
;
; EXAMPLE :for reading TEMP(X,Y,Z) in test.nc, with dimensions (nx,ny,nz)=(2,3,4)
;         a=myncdfgetvar('test.nc'.'TEMP')=> TEMP(X,Y,Z) 
;         a=myncdfgetvar('test.nc','TEMP',rmin=[0,0,1])=> TEMP(X,Y,Z(1:nz)) only a part on Z
;         a=myncdfgetvar('test.nc','TEMP',rmin=[-1,-1,10],rmax=[-1,-1,10])=> TEMP(X,Y,Z0=10) only one point of Z.
;         in that case degenerated dimensions are NOT erased.
;
;NOTES : you could also use the stride to read with intervals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; get sizes on variable dimensions
dims=myncdfgetvardims(filename,varname)
ndims=size(dims,/n_elements)
;
; (re)open in data mode
id=ncdf_open(filename,/NOWRITE)
varid=ncdf_varid(id,varname)
;
; check for starting position
if keyword_set(rmin) then begin
if (where(rmin eq -1) ne -1) then begin
rmin(where (rmin eq -1))=0
endif
endif else begin
rmin=intarr(ndims)
endelse
;
; check for ending position
if keyword_set(rmax) then begin
if (where(rmax eq -1) ne -1) then begin
rmax(where (rmax eq -1))=dims(where (rmax eq -1))
endif
rcount=rmax-rmin+1
endif else begin
rcount=dims-rmin
endelse
;
ncdf_varget,id,varid,field,offset=rmin,count=rcount
ncdf_close,id
;
return,field
;
end