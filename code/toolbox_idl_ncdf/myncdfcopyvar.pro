Pro myncdfcopyvar,filename,fileout,varname
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for copying a variable from filename to fileout, with same dimensions and attributes
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUTS :
;
; -filename : filename of the netcdf file (string). MUST ALREADY EXIST.
; -fileout : filename of the netcdf file (string) where copied. MUST ALREADY EXIST.
; -varname. name of the variable to be copied. Dimensions of variable from filename must concord with dimensions from fileout.
;            
;  EXAMPLE : myncdfcopyvar,'file.nc','file2.nc','X'
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; get variable dimensions (names and sizes) from first file
vardimsnames=myncdfgetvardims(filename,varname,/names)
vardims=myncdfgetvardims(filename,varname,/names)
; get variable data from first file
vardata=myncdfgetvar(filename,varname)
print,'1',size(vardata,/type)
; write variable in new file
myncdfmakevar,fileout,varname,vardimsnames,vardata
;
; get variable attributes
varattsnames=myncdfgetatts(filename,varname)
; for each attribute, get and write its value
if (size(varattsnames,/n_elements)-1 gt 0) then begin
for i=0,size(varattsnames,/n_elements)-1 do begin
att=myncdfgetatt(filename,varname,varattsnames(i))
myncdfmakeatt,fileout,varname,varattsnames(i),att
endfor
endif
;
end