function mysvdcmap2d,field,pcs

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for calculation of correlation map of  SVD results, from previous call to mysvd.pro
;  Sulian Thual, IRD-IMARPE 2008
;
; Calculates correlation between field(len,time) and pcs(time) time serie for the SVD desired mode. 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
pc=pcs
nx=(size(field,/dimensions))(0)
ny=(size(field,/dimensions))(1)
;
cmap=make_array(nx,ny)
;
for pii=0,nx-1 do begin
for pij=0,ny-1 do begin
cmap(pii,pij)=correlate(data(pii,pij,*),pc(*))
endfor
endfor
;
return,cmap
;
end