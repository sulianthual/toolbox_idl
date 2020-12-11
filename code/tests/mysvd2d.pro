pro	mysvd2d,field1,field2,pattern1,pattern2,pcs1,pcs2,svls,scf,cutoff,$
                iterations=iterations,nocomments=nocomments,crosscorre=crosscorre,dble=dble
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for calculating SVD of two given fiels, with form field1(*,*,time) and field2(*,*,time)
;  Sulian Thual, IRD-IMARPE 2008
;
; field1 =  array containing first input field (assumed to be (lon,lat,time) )
; field2 =  array containing second input field (assumed to be (lon,lat,time) )
; pattern1  =  output array containing patterns for field1 (lon,lat,cutoff)
; pattern2  =  output array containing patterns for field2 (lon,lat,cutoff)
; pcs1   =  output array containing pcs for field1 (time,cutoff)
; pcs2   =  output array containing pcs for field2 (time,cutoff)
; svls  =  output array containing the singular values (cutoff)
; scf   =  output array containing the Fraction of Squared Covariance (or Cross-Correlation)
;          Explained by a given SVD mode (cutoff)
; cutoff=  The number of Number of SVDs modes to retain (max = no. time points)
; iterations (optionnal) : if set, controls the number of iterations for svdc.default value is 30.
; nocomments (optionnal) : If set, no informations are displayed
; crosscorre (optionnal) : If set, computes cross-correlation SVD rather than covariance SVD.
;                          See (Wallace et al.1992) for more information.
;                          In my case (no access to that paper), I multiply the patterns
;                          with the stddev maps, for each side of the SVD. 
; dble (optionnal) : Id set, computes the SVD with double -precision.
;
; NOTES :
;
; - You must have n <= m, ie lon*lat for field1 <= lon*lat for field2.
; - For comparison with (H.Bjornoss & S.A Venegas-A Manual for EOF and SVD analyses of Climatic Data)
;   Imagine IDL shows a matrix A(i,j) with i being the number of COLUMNS, and j the number of ROWS.
;   Therefore the usual matrix multiplication is ## instead of #.
; - Possible amelioration : if n > m use keyword /column for svdc then adapt the script.
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
ndims1=size(field1,/dimensions)
n11=ndims1(0)
n12=ndims1(1)
n1t=ndims1(2)
;
ndims2=size(field2,/dimensions)
n21=ndims2(0)
n22=ndims2(1)
n2t=ndims2(2)
;
; Condition n <= m for SVD
if (n11*n12 gt n21*n22) then begin
print,'mysvd2d : n > m problem, returning : try mysvd2d(field2,field1,...)'
return 
endif
;
data1=field1
data2=field2
;
; reform data
data1=reform(data1,n11*n12,n1t,/overwrite)
data2=reform(data2,n21*n22,n2t,/overwrite)
;
; substract temporal mean from inputs to produce anomalies
for pi1=0,n11*n12-1 do begin
data1(pi1,*)=data1(pi1,*)-total(data1(pi1,*))/n1t
endfor
for pi2=0,n21*n22-1 do begin
data2(pi2,*)=data2(pi2,*)-total(data2(pi2,*))/n2t
endfor
;
; calculate covariance (or cross-correlation) matrix
if keyword_set(crosscorre) then begin
stddev1=fltarr(n11*n12)
stddev2=fltarr(n21*n22)
for pi1=0,n11*n12-1 do begin
stddev1(pi1)=stddev(data1(pi1,*))
data1(pi1,*)=data1(pi1,*)/stddev1(pi1)
endfor
for pi2=0,n21*n22-1 do begin
stddev2(pi2)=stddev(data2(pi2,*))
data2(pi2,*)=data2(pi2,*)/stddev2(pi2)
endfor
endif 
;
comatrix=transpose(data1) ## data2
;
; perform SVD decomposition
if keyword_set(iterations) then begin
if keyword_set(dble) then begin
svdc,comatrix,w,u,v,/double,itmax=iterations
endif else begin
svdc,comatrix,w,u,v,itmax=iterations
endelse
endif else begin
if keyword_set(dble) then begin
svdc,comatrix,w,u,v,/double
endif else begin
svdc,comatrix,w,u,v
endelse
endelse
;
; sort values by decreasing covariance (or cross-correlation) 
index=reverse(sort(w))
w=w(index)
for pi1=0,n11*n12-1 do begin
u(*,pi1)=u(index,pi1)
endfor
for pi2=0,n21*n22-1 do begin
v(*,pi2)=v(index,pi2)
endfor
;
; Fraction of Squared Covariance (or Cross-Correlation) SCF :
scf=w/total(w)
;
expand1=data1 ## u
expand2=data2 ## v
;
;cut off
u=u(0:cutoff-1,*)
w=w(0:cutoff-1)
v=v(0:cutoff-1,*)
scf=scf(0:cutoff-1)
expand1=expand1(0:cutoff-1,*)
expand2=expand2(0:cutoff-1,*)
;
; Case of cross-correlation : multiply patterns by stddev maps
if keyword_set(crosscorre) then begin
for pin=0,cutoff-1 do begin
u(pin,*)=stddev1(*)*u(pin,*)
v(pin,*)=stddev2(*)*v(pin,*)
endfor
endif
;
; return values
u=reform(u,cutoff,n11,n12)
v=reform(v,cutoff,n21,n22)
pattern1=transpose(u,[1,2,0])
pattern2=transpose(v,[1,2,0])
pcs1=transpose(expand1,[1,0])
pcs2=transpose(expand2,[1,0])
svls=w
;
; diagnostics
if keyword_set(nocomments) then begin
endif else begin
print,'modes= ',findgen(cutoff)+1
print,'scf(%)=',scf*100.
if keyword_set(crosscorre) then begin
print,'cross-correlation : ON'
endif
endelse
;
end




