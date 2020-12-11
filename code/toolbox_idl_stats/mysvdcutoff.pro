Pro mysvdcutoff,pattern1,pattern2,pcs1,pcs2,svls,scf,cutoff

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for cutoff of  SVD results, from previous call to mysvd.pro
;  Sulian Thual, IRD-IMARPE 2008
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; reform patterns 
dims1=size(pattern1,/n_dimensions)
ndims1=size(pattern1,/dimensions)
pattern1=reform(pattern1,product(ndims1(0:dims1-2)),ndims1(dims1-1),/overwrite)
;
dims2=size(pattern2,/n_dimensions)
ndims2=size(pattern2,/dimensions)
pattern2=reform(pattern2,product(ndims2(0:dims2-2)),ndims2(dims2-1),/overwrite)
;
; cutoff entries
pattern1=pattern1(*,0:cutoff-1)
pattern2=pattern2(*,0:cutoff-1)
pcs1=pcs1(*,0:cutoff-1)
pcs2=pcs2(*,0:cutoff-1)
svls=svls(0:cutoff-1)
scf=scf(0:cutoff-1)
;
; reform outputs
pattern1=reform(pattern1,[ndims1(0:dims1-2),cutoff],/overwrite)
pattern2=reform(pattern2,[ndims2(0:dims2-2),cutoff],/overwrite)
;
end