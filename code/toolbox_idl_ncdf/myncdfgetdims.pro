function myncdfgetdims,filename,varname,names=names,all=all
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function for reading dimensions names or sizes from a variable, in a ncdf file 
;  Sulian Thual, IRD-IMARPE 2008
;
; - filename : the netcdf file name
; -varname : the variable to get dimensions sizes from.
; -names : if keyword set, gives a array of names for the dimensions
; -all : if set, gives all dimensions names or sizes from ncdf rather than than from a variable.
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
if keyword_set(all) then begin; case all dimensions
infos=ncdf_inquire(id)
ndims=infos.Ndims
nams=strarr(ndims)
sizs=intarr(ndims)
for pii=0,ndims-1 do begin
ncdf_diminq,id,pii,nam,siz
nams(pii)=nam
sizs(pii)=siz
endfor
endif else begin; case dimensions from a variable
varid=ncdf_varid(id,varname)
infos=ncdf_varinq(id,varid)
ndims=size(infos.Dim,/n_elements)
nams=strarr(ndims)
sizs=intarr(ndims)
for pii=0,ndims-1 do begin
ncdf_diminq,id,infos.Dim(pii),nam,siz
nams(pii)=nam
sizs(pii)=siz
endfor
endelse
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