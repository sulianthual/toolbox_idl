function mypart,field,dim,dimpart
;
; SEE EXTRAC
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for extracting matrice part with IDL , on one dimension:
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : Input field for extracting part
; dim : Dimension number on wich part is extracted (starting from one).
;             Must be <= number of dimensions from field.
; dimpart : Part to be extracted on the dimension dimnumber. 
;           dimpart can be an array containing the points coordinates (starting from zero=IDL
;           counting).
;           dimpart can also be a scalar, in this case the dimension dimnumber is erased (with reform)
;           for the output matrice.
;
; CALLING SEQUENCE : EXAMPLES
;
;b= mypart(findgen(5,7),2,0)=> On dimension 2 (of size=7) of input field,
;                           extracts matrice on first point, of coordinate 0.
;                           Gives output=findgen(5)
;
;b= mypart(findgen(5,7),2,1)=> On dimension 2 (of size=7) of input field,
;                           extracts matrice on second point, of coordinate 1.
;                           Gives output=findgen(5)+5
;
;b= mypart,(findgen(5,7),2,indgen(3))=> On dimension 2 (of size=7) of input field, 
;                                   extracts matrice on 3 first points,
;                                   of coordinates [0,1,2]. Gives output=findgen(5,3).
; 
; NOTES :
;
; -for parting on different dimensions, you must recall several times this function
;  (beware the dimension order will change between each recall).
; - NOTES : degenerated dimensions (ie of size 1) will be erased by this function, 
;           has it uses the reform function.
; 
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
dims=size(data,/dimensions)
ndims=size(data,/n_dimensions)
index=indgen(ndims)+1
;
; check that dim is part of the field dimensions
if (dim gt ndims) then begin
print,'mypart : dim gt ndims(field), returning)'
return,0
endif
; check that dimpart is in range of the dim dimensions (TODO)
; 
; if field has only one dimension, make quick part
if (ndims eq 1) then begin
out=data(dimpart)
return,out
endif
;
case dim of
1 : newindex=[index(dim:ndims-1),dim] 
ndims : newindex=[index(0:ndims-2),dim]
else : newindex=[index(0:dim-2),index(dim:ndims-1),dim]
endcase
data=myswitch(data,newindex)
;
myreform1,data,newdims,prod,time
datapart=data(*,dimpart)
myreform2,datapart,[newdims(0:ndims-2),mysize(dimpart)]
;
out=myswitch(datapart,newindex,/back)
;
out=reform(out,/overwrite)
return,out
;
end