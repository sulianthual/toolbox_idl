;function myfindcoord,A,X,inf=inf,sup=sup,silent=silent
;compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Function for finding the closest point of X to the point A. Returns the corresponding index of X point.
;  X should be in ASCENDING or DECREASING order, elsewhere you may have various times close to A.
;    (but it is not obligatory)
;  X must can now be any dimension
;
; inf or sup as keyword : selon si on veut que le point soit superieur(inferieur) a la valeur recherchee
;  Sulian Thual, IRD-IMARPE 2008
; silent : pour ne pas retourner de messages
;
; Example : X= [0.5, 1.5, 2.5 ] and A=1.3
; The closest point to X is the point X(1)=1.5. 
; The function returns the index of X(1), that is 1.
; If X is multiple dimension array, it will return the index X(1) the same way. To find the point according to dimensions
; use array_indice function of IDL
; If the A point is at the middle of several points then the first of these points will be returned, with an error message
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
nA=size(A,/n_elements)
if (nA ne 1) then begin
if ~keyword_set(silent) then print,'myfindcoord, dim of point ne 1, returning'
endif
nxd=size(X,/n_elements)
Xdistance=dblarr(nxd)
for pii=0.,double(nxd)-1. do begin
Xdistance(pii)=abs(A-X(pii))
endfor
;
if keyword_set(inf) then begin
found=0 
closest0=where(Xdistance eq mymin(Xdistance))
while (found eq 0) do begin
closest=where(Xdistance eq mymin(Xdistance))
if (X(closest) gt A) then begin
Xdistance(closest)=myNaN() 
endif else begin
returnclosest=closest(0)
found=1
endelse
if (max(finite(Xdistance)) eq 0) then begin
if ~keyword_set(silent) then print,'myfindcoord, all point are sup, returning closest but sup'
returnclosest=closest0(0)
found=1
endif
endwhile
endif
;
if keyword_set(sup) then begin
found=0 
closest0=where(Xdistance eq mymin(Xdistance))
while (found eq 0) do begin
closest=where(Xdistance eq mymin(Xdistance))
if (X(closest) lt A) then begin
Xdistance(closest)=myNaN() 
endif else begin
returnclosest=closest(0)
found=1
endelse
if (max(finite(Xdistance)) eq 0) then begin
if ~keyword_set(silent) then print,'myfindcoord, all point are inf, returning closest but inf'
returnclosest=closest0(0)
found=1
endif
endwhile
endif
;
;
if (~keyword_set(inf) and ~keyword_set(sup)) then begin
closest=where(Xdistance eq mymin(Xdistance))
if (size(closest,/n_elements) ne 1) then begin
if ~keyword_set(silent) then print,'myfindcoord :',size(closest,/n_elements),' points at equal distance to point, returning first one' 
endif
returnclosest=closest(0)
endif
;
;print,'findcoord : X(a)=b, (a,b)=',returnclosest,X(returnclosest) 
return,returnclosest
;
end