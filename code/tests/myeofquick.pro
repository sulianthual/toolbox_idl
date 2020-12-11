pro	myeofquick,field,eofs,pcs,svls,FVE,cutoff,iteration=iteration
;
; EOFcalc
; calculates the EOFs of a given field. : For 2d*time input field not changed
;
; modified :
;
; Sulian Thual IMARPE-IRD 2008 (supressed lats and latitude weighting, added iterations control).
; from /home/dan/idl/EOFcalc.pro
; 27/1/04

; field =  array containing input field (assumed to be (lon,lat,time) )
; eofs  =  output array containing eofs (lon,lat,cutoff)
; pcs   =  output array containing pcs  (time,cutoff)
; svls  =  output array containing the singular values (cutoff)
; FVE   =  output array containing the Fractional Variance of the
;          input array Explained by a given EOF (cutoff)
; cutoff=  The number of Number of EOFs to retain (max = no. time points)
; iterations(optionnal) : if set, controls the number of iterations for svdc.default value is 30.
;
s=size(field)
nlons=s(1)
nlats=s(2)
ntims=s(3)
;
; w*w=L
; where X.X^T E=LE
; hence tr(X.X^T)=tr(L)=tr(w^2)
;
;      Applying latitude weighting.
    ;    fac=!pi/180.
    ;    for j=0,nlats-1 do begin
    ;          cfac=sqrt(abs(cos(lats(j)*fac)))
    ;          field(*,j,*)=field(*,j,*)*cfac
;	endfor
;
;Reform data into a 2d array
data=field
;data=reform(field,nlons*nlats,ntims,/overwrite)
;
; subtract time mean from data to produce anomalies.
for i=0,nlons-1 do begin
for j=0,nlats-1 do begin
data(i,j,*)=data(i,j,*)-total(data(i,j,*))/ntims
endfor
endfor
;
; this is TR(X.X^T) = total sum of variance
; note that in the EOF basis TR(Lambda) is the total sum of variance
; but that Lambda is the Eigenvalue matrix of X.X^T (W=sqrt(Lambda) in svd)
;
tr=0
print,'tr calc'
for jk=0,nlons-1 do begin
for kk=0,nlats-1 do begin
tr=tr+total(data(jk,kk,*)*data(jk,kk,*))
endfor
endfor
print,'sum of (space) variances:',tr/(ntims-1)
;
data=reform(data,nlons*nlats,ntims,/overwrite)
;
print,'svdc'
if keyword_set(iterations) then begin
svdc,data(*,*),w,u,v,/column,itmax=iterations
endif else begin
svdc,data(*,*),w,u,v,/column
endelse
;
nuend=(size(u,/dimensions))(1)
u=reform(u(*,*),nlons,nlats,nuend,/overwrite)
;
svd_sort,w,u,v,/column
;
;cut off
print,'cutoff'
u=u(*,*,0:cutoff-1)
w=w(0:cutoff-1)
v=v(*,0:cutoff-1)
;
eofs=u;reform(u(*,*),nlons,nlats,cutoff)
pcs=v
svls=w
FVE=(svls*svls)/tr
print,'CHECK. Sum of space variances',total(w*w)/(ntims-1),tr/(ntims-1)
;
	;       Latitude de-weight 
        ;fac=!pi/180.
         ; for j=0,nlats-1 do begin
          ;    cfac=1./sqrt(abs(cos(lats(j)*fac))) 
           ;          eofs(*,j,*)=cfac*eofs(*,j,*)
          ;endfor

end


pro svd_sort,w,u,v,row=row,column=column
; sorts singular values and left and right singular vectors after call to
; svdc into order of descending singular value
su=size(u)
sv=size(v)
index=reverse(sort(w))
w=w(index)
if (keyword_set(column)) then begin
for k=0, su(1)-1 do begin; two dimensions for u, been reformed before
for k2=0,su(2)-1 do begin
u(k,k2,*)=u(k,k2,index)
endfor
endfor
for k=0, sv(1)-1 do v(k,*)=v(k,index)
endif else begin; havent changed here in case of no columns
for k=0, su(2)-1 do u(*,k)=u(index,k)
for k=0, sv(2)-1 do v(*,k)=v(index,k)
endelse
return
end
