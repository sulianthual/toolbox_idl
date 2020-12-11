function myswitch,field,order,back=back,last=last,temporary=temporary
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; switch dimensions of an array
; Sulian THUAL IMARPE-IRD 2008, revisions 2011
;
; PARAMETERS :
; field : the array to be switched
; order : an array containing the new dimensions order (order starts from one)
; back : if keyword set, computes the inverse switching.
; last : if keyword set, must specify only one dimension for order, that will
;        be put at the end. Also works with back.
; keyword temporary: si set, field en entree est mis en undefined
; 
; example : a=findgen(2,3,4,5)
; b=myswitch(a,[1,2,4,3]=> b is of size [2,3,5,4], dimensions 4 and 5 have been switched
; b=myswitch(a,[1,2,4,3]) then a=myswitch(b,[1,2,4,3],/back) gives back the array a.
; b=myswitch(a,1,/last)=> b of size[3,4,5,2] then c=myswitch(b,1,/last,/back) gives back a.
;
; NOTE : will not work for 1d field (but you dont need that anyway)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; if last keyword is set
if keyword_set(last) then begin
if (size(order,/n_elements) ne 1) then begin
print,'myswitch : /last specified with size(order) ne 1, returning'
return,0
endif
lastdim=order
order=make_array(size(field,/n_dimensions))
ndims=size(field,/n_dimensions)
index=indgen(ndims)+1
case lastdim of
1 : order=[index(lastdim:ndims-1),lastdim] 
ndims : order=[index(0:ndims-2),lastdim]
else : order=[index(0:lastdim-2),index(lastdim:ndims-1),lastdim]
endcase
endif
;
;check that size(order)=size(field) 
ndf=size(field,/n_dimensions)
ndo=size(order,/n_elements)
if (ndf ne ndo) then begin
print,'myswitch : size(order) ne size(field), returning'
return,0
endif
;
; make transposition for switch
if ~keyword_set(back) then begin
if keyword_set(temporary) then data=transpose(temporary(field),order-1) else data=transpose(field,order-1)
endif else begin
dimo=size(order,/dimensions)
backorder=make_array(dimo)
for pii=0,ndo-1 do begin
backorder(pii)=where(order eq pii+1)+1
endfor
if keyword_set(temporary) then data=transpose(temporary(field),backorder-1) else data=transpose(field,backorder-1)
endelse
;
return,data
;
end