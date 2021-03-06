pro	mysvd,field1,field2,pattern1,pattern2,pcs1,pcs2,svls,scf,cutoff,$
                iterations=iterations,nocomments=nocomments,crosscorre=crosscorre,dble=dble
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for calculating SVD of two given fiels, with form field1(*...,time) and field2(*...,time)
;  Sulian Thual, IRD-IMARPE 2008
;
; field1 =  array containing first input field (assumed to be (len1,time) )
; field2 =  array containing second input field (assumed to be (len2,time) )
; pattern1  =  output array containing patterns for field1 (len1,cutoff)
; pattern2  =  output array containing patterns for field2 (len2,cutoff)
; pcs1   =  output array containing pcs for field1 (time,cutoff)
; pcs2   =  output array containing pcs for field2 (time,cutoff)
; svls  =  output array containing the singular values (cutoff)
; scf= output array with Fractionnal Squared Covariance (or Cross-Correlation).  
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

; - For comparison with (H.Bjornoss & S.A Venegas-A Manual for EOF and SVD analyses of Climatic Data)
;   Imagine IDL shows a matrix A(i,j) with i being the number of COLUMNS, and j the number of ROWS.
;   Therefore the usual matrix multiplication is ## instead of #.
; - A partir de champs 2d field(lon,lat,time) pour mettre au format field(len,time) faire :
;    field=reform(field,lon*lat,time,/overwrite)=> Plus maintenant car on reform automatiquement
;    les entrees sous une forme field(len,time). Il faut seulement 
; - Amelioration : Si len1 > len2 alors on inverse les matrices data1 et data2 pour pouvoir faire 
;                  la svd avec le programme svdc. (You must have n <= m, ie len1 for field1 <= len2
;                  for field2, tu run svdc normally).
; - Il faut s'assurer que field1 et field2 ont memes dimensions en temps, et que le temps est la derniere
;   variable dans l'ordre des dimensions.
; - Note qu'on met en sortie les svls et les scf, car les svls sont soumis au cutoff, tandis que 
;  les scf ont etes calcules en pourcentage par rapport a la covariance (cross-correlation) totale.
;
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Condition n <= m for routine svdc : inverse data if necessary
; Pass data to other variables
testn1=product((size(field1,/dimensions))(0:size(field1,/n_dimensions)-2))
testn2=product((size(field2,/dimensions))(0:size(field2,/n_dimensions)-2))
if (testn1 gt testn2) then begin
data1=field2
data2=field1
inverted=1
endif else begin
data1=field1
data2=field2
inverted=0
endelse
;
; reform data to form field(len,time)
dims1=size(data1,/n_dimensions)
ndims1=size(data1,/dimensions)
if (dims1 gt 2) then begin
data1=reform(data1,product(ndims1(0:dims1-2)),ndims1(dims1-1),/overwrite)
endif
n1=product(ndims1(0:dims1-2))
n1t=ndims1(dims1-1)
;
dims2=size(data2,/n_dimensions)
ndims2=size(data2,/dimensions)
if (dims2 gt 2) then begin
data2=reform(data2,product(ndims2(0:dims2-2)),ndims2(dims2-1),/overwrite)
endif
n2=product(ndims2(0:dims2-2))
n2t=ndims2(dims2-1)
;
; control on time dimensions
if (n1t ne n2t) then begin
print,'mysvd : nt(field1) ne nt(field2), returning'
return
endif
;
; substract temporal mean from inputs to produce anomalies
for pi1=0,n1-1 do begin
data1(pi1,*)=data1(pi1,*)-total(data1(pi1,*))/n1t
endfor
for pi2=0,n2-1 do begin
data2(pi2,*)=data2(pi2,*)-total(data2(pi2,*))/n2t
endfor
;
; calculate covariance (or cross-correlation) matrix
if keyword_set(crosscorre) then begin
stddev1=fltarr(n1)
stddev2=fltarr(n2)
for pi1=0,n1-1 do begin
stddev1(pi1)=stddev(data1(pi1,*))
data1(pi1,*)=data1(pi1,*)/stddev1(pi1)
endfor
for pi2=0,n2-1 do begin
stddev2(pi2)=stddev(data2(pi2,*))
data2(pi2,*)=data2(pi2,*)/stddev2(pi2)
endfor
print,'1'
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
for pi1=0,n1-1 do begin
u(*,pi1)=u(index,pi1)
endfor
for pi2=0,n2-1 do begin
v(*,pi2)=v(index,pi2)
endfor
;
; Fraction of Squared Covariance (or Cross-Correlation) SCF :
scf=w/total(w)
;
; Expansion coefficients ( ie time series)
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
; Case of cross-correlation : multiply patterns by stddev maps for outputs
if keyword_set(crosscorre) then begin
for pin=0,cutoff-1 do begin
u(pin,*)=stddev1(*)*u(pin,*)
v(pin,*)=stddev2(*)*v(pin,*)
endfor
print,'2'
endif
;
; reform values
u=transpose(u,[1,0])
v=transpose(v,[1,0])
u=reform(u,[ndims1(0:dims1-2),cutoff],/overwrite)
v=reform(v,[ndims2(0:dims2-2),cutoff],/overwrite)
expand1=transpose(expand1,[1,0])
expand2=transpose(expand2,[1,0])
svls=w
;
; return values (inverse if necessary, see beginning of script, condition n <= m).
if (inverted eq 1) then begin
pattern1=v
pattern2=u
pcs1=expand2
pcs2=expand1
endif else begin
pattern1=u
pattern2=v
pcs1=expand1
pcs2=expand2
endelse
;
; make diagnostics
corre=make_array(cutoff)
for pin=0,cutoff-1 do begin
corre(pin)=correlate(pcs1(*,pin),pcs2(*,pin))
endfor
;
; scf sum 
if (1 eq 1) then begin
scfsum=make_array(size(scf,/n_elements))
for pin=0,cutoff-1 do begin
scfsum(pin)=total(scf(0:pin));
endfor
endif
;
; show comments
if keyword_set(nocomments) then begin
endif else begin
print,'      '
print,'MYSVD :'
print,'modes=   ',findgen(cutoff)+1
print,'scf(%)=  ',scf*100.
print,'sum(scf)%',scfsum*100.
print,'crlt=    ',corre
print,'n1(f1)=  ',n1
print,'n2(f2)=  ',n2
print,'nt=      ',n1t
if keyword_set(crosscorre) then begin
print,'cross-correlation : ON'
endif
print,'    '
endelse
;
end




