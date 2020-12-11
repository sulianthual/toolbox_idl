function myncdfgetvardims,filename,varname,names=names
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function for reading dimensions sizes of a variable from a netcdf file
;  Sulian Thual, IRD-IMARPE 2008
;
; - filename : the netcdf file name
; -varname : the variable to get dimensions sizes from.
; -names : if keyword set, gives a array of names for the dimensions
;
; EXAMPLE : test.nc contains the variable TEMP(x,y,z) where (nx,ny,nz)=(2,3,4)
; dims=myncdfgetvardims('test.nc','TEMP')=>[2,3,4]
; dnames=myncdfgetvardims('test.nc','TEMP',/names)=> ['x','y','z']
; 
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; open in data mode
id=ncdf_open(filename,/NOWRITE)
;
varid=ncdf_varid(id,varname)
infos=ncdf_varinq(id,varid)
;
ndims=size(infos.Dim,/n_elements)
nams=strarr(ndims)
;sizs=intarr(ndims)
sizs=fltarr(ndims); modif pour large size
for pii=0,ndims-1 do begin
ncdf_diminq,id,infos.Dim(pii),nam,siz
nams(pii)=nam
sizs(pii)=siz
endfor
;
ncdf_close,id
;
if keyword_set(names) then begin
return,nams
endif else begin
return,sizs
endelse
;
end