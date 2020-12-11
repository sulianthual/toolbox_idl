pro	myeof2d,field,eofs,pcs,svls,FVE,cutoff,iteration=iteration,nan=nan
;
; EOFcalc
; calculates the EOFs of a given field.
;
; ATTENTION AU PIEGE (Sulian  2009) : On ne calcule pas la matrice de covariance !!! programme a eviter
;
; modified :
;
; Sulian Thual IMARPE-IRD 2008 (supressed lats and latitude weighting, added iterations control).
; from /home/dan/idl/EOFcalc.pro
; 27/1/04

; field =  array containing input field (assumed to be (lon,lat,time) ie of dimensions 2d*time )
; eofs  =  output array containing eofs (lon,lat,cutoff)
; pcs   =  output array containing pcs  (time,cutoff)
; svls  =  output array containing the singular values (cutoff)
; FVE   =  output array containing the Fractional Variance of the
;          input array Explained by a given EOF (cutoff)
; cutoff=  The number of Number of EOFs to retain (max = no. time points)
; iterations(optionnal) : if set, controls the number of iterations for svdc.default value is 30.
;
; nan : AJOUTE LE 9 mars 2009 par Sulian. SI ce keyword est mis alors on fait la SVD sur la partie sans NaN.
;       Notons que pour un champ field(lon,lat,time) s'il y a un NaN c'est en (lon,lat), et alors on considere
;       toute la serie temporelle comme etant a NAN. Ces NaN servent a faire un mask pour la SVD
; 
s=size(field)
nlons=float(s(1))
nlats=float(s(2))
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
;
if keyword_set(nan) then begin; AJOUT SULIAN 9MARS2009
; ENLEVE LES NAN si la cle est mise
; NAN(lon,lat) doivent etre au meme endroit pour tout time 
wheregood=where(finite(reform(data(*,*,0))))
ngood=size(wheregood,/n_elements)
data2=make_array(ngood,ntims)
for kt=0,ntims-1 do begin
data2(*,kt)=(field(*,*,kt))(where(finite(reform(field(*,*,kt)))))
endfor
data=data2 & data2=0
nlonsave=nlons & nlatsave=nlats
nlons=1 & nlats=ngood
endif else begin
;
data=reform(data,nlons*nlats,ntims,/overwrite)
;
endelse
;
;
; subtract time mean from data to produce anomalies.
for i=0.,nlons*nlats-1. do begin
data(i,*)=data(i,*)-total(data(i,*))/ntims
endfor
;
; this is TR(X.X^T) = total sum of variance
; note that in the EOF basis TR(Lambda) is the total sum of variance
; but that Lambda is the Eigenvalue matrix of X.X^T (W=sqrt(Lambda) in svd)
;
tr=0
print,'tr calc'
for jk=0.,nlons*nlats-1. do begin
tr=tr+total(data(jk,*)*data(jk,*))
endfor
print,'sum of (space) variances:',tr/(ntims-1)
;
print,'svdc'
if keyword_set(iterations) then begin
svdc,data(*,*),w,u,v,/column,itmax=iterations
endif else begin
svdc,data(*,*),w,u,v,/column
endelse
svd_sort,w,u,v,/column
;
;cut off
print,'cutoff'
u=u(*,0:cutoff-1)
w=w(0:cutoff-1)
v=v(*,0:cutoff-1)
;
eofs=reform(u(*,*),nlons,nlats,cutoff)
;
if keyword_set(nan) then begin; AJOUT SULIAN 9MARS2009
; REMETTRE DANS LE BON ORDRE SI NAN VALUES
eofs=make_array(nlonsave,nlatsave,cutoff)
eofspass=make_array(nlonsave,nlatsave)
for ic=0.,cutoff-1. do begin
eofspass(*,*)=myNaN()
eofspass(wheregood)=u(*,ic)
eofs(*,*,ic)=eofspass
endfor
endif
;
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
for k=0., su(1)-1. do u(k,*)=u(k,index)
for k=0., sv(1)-1. do v(k,*)=v(k,index)
endif else begin
for k=0., su(2)-1. do u(*,k)=u(index,k)
for k=0., sv(2)-1. do v(*,k)=v(index,k)
endelse
return
end
