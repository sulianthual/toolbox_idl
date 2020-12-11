function mypder3d,mat,x,dim

; fonction pour faire une derivee partielle sur une matrice de dimension 3
; Sulian THUAL IRD 2009
;
;
; mat(x,y,t) par exemple en entree
; x : par exemple l'axe y de la deuxieme dimension. Dans ce cas on retourne dy(mat) derivee partielle
; dim : la dimension correspondante. Pour x,dim=1, pour y dim=2 et pour t dim=3

nx=(size(mat,/dimensions))(0)
ny=(size(mat,/dimensions))(1)
nt=(size(mat,/dimensions))(2)
der=make_array(nx,ny,nt)
nax=size(x,/n_elements)
;
; first dimension
if (dim eq 1) then begin
; check
if (nax ne nx) then print,"mypder3d, no match on dim1 and axis"
for j=0,ny-1 do begin
for kt=0,nt-1 do begin
pass=reform(mat(*,j,kt))
der(*,j,kt)=deriv(x,pass)
endfor
endfor
endif
;
; second dimension
if (dim eq 2) then begin
; check
if (nax ne ny) then print,"mypder3d, no match on dim2 and axis"
for i=0,nx-1 do begin
for kt=0,nt-1 do begin
pass=reform(mat(i,*,kt))
der(i,*,kt)=deriv(x,pass)
endfor
endfor
endif
;
; third dimension
if (dim eq 3) then begin
; check
if (nax ne nt) then print,"mypder3d, no match on dim3 and axis"
for i=0,nx-1 do begin
for j=0,ny-1 do begin
pass=reform(mat(i,j,*))
der(i,j,*)=deriv(x,pass)
endfor
endfor
endif








return,der
;
end