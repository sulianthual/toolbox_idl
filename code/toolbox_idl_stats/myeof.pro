pro	myeof,field,eofs,pcs,pvar,cutoff,nan=nan,latw=latw
;
; EOFcalc
; calculates the EOFs of a given field.
;
; Sulian THUAL janvier 2011
; 
; field =  array containing input field (assumed to be (lon,lat,time) ie of dimensions 2d*time )
; eofs  =  output array containing eofs (lon,lat,cutoff)
; pcs   =  output array containing pcs  (time,cutoff)
; pvar  =  output array containing the % of explained covariance (cutoff)
; cutoff=  The number of Number of EOFs to retain (max = no. time points)
; latw  =  si donne, vecteur latitude sur la deuxieme dimension pour weighter les donnees
; nan = si keyword mis, un mask de nan est recherche sur field(*,*,0). Ces valeurs sont 
;         alors automatiquement enlevee pour le calcul de la svd. 
; 
s=size(field)
nlons=float(s(1))
nlats=float(s(2))
ntims=s(3)
;
data=field
;
;Apply latitude weighting.
if keyword_set(latw) then begin
fac=!pi/180.
for j=0,nlats-1 do begin
cfac=sqrt(abs(cos(latw(j)*fac)))
data(*,j,*)=data(*,j,*)*cfac
endfor
endif
;
; Si existe NAN sans le keyword inclus, arreter
if ~keyword_set(nan) then begin
a=min(finite(data))
if (a eq 0) then begin
print,'existing NaN values, put /nan keyword'
stop
endif
endif
;
; ENLEVE LES NAN de la SVD si la cle est mise
; et reform data into a 2d array
if keyword_set(nan) then begin
wheregood=where(finite(reform(data(*,*,0))))
ngood=size(wheregood,/n_elements)
data2=make_array(ngood,ntims)
for kt=0,ntims-1 do begin
data2(*,kt)=(data(*,*,kt))(wheregood)
endfor
data=data2 & data2=0
nlonsave=nlons & nlatsave=nlats
nlons=1 & nlats=ngood
endif else begin
data=reform(data,nlons*nlats,ntims,/overwrite)
endelse
;
;
; subtract time mean from data to produce anomalies.
for i=0.,nlons*nlats-1. do begin
data(i,*)=data(i,*)-total(data(i,*))/ntims
endfor
;
;
; Calcul matrice de covariance
covmatrix=(1./(ntims-1.))*(double(data)##transpose(data))
;
; Calcul eigenvectors et eigenvalues
LA_SVD,covmatrix,W,U,V
;
; Recuperation des eigenvectors
s = size(data, /DIMENSIONS)
eofs = FltArr(s[1], s[0])
for j=0,s[1]-1 do begin
t = Transpose(data) ## U[j,*]
eofs[j,*]  = t / SQRT(Total(t^2))
endfor
;
; Recuperation des PC
pcs=fltarr(s[1],s[1])
for j=0,s[1]-1 do pcs[j,*]=data##eofs[j,*]
;
; pourcentage de variance percent_variance
pvar=W/total(W)*100.
;
; Reorder
order=reverse(sort(W))
seofs=size(eofs,/dimensions); eofs
for k=0.,seofs(1)-1. do eofs(*,k)=eofs(order,k)
spcs=size(pcs,/dimensions); pcs
for k=0.,spcs(1)-1. do pcs(*,k)=pcs(order,k)
pvar=pvar(order); pvar
;
; Cutoff
eofs=eofs(0:cutoff-1,*)
pcs=pcs(0:cutoff-1,*)
pvar=pvar(0:cutoff-1)
; 
; Transpose dimensions
eofs=transpose(eofs,[1,0]); inverse dimension 1 et 2
pcs=transpose(pcs,[1,0]); inverse dimension 1 et 2
;
; Reform back
if keyword_set(nan) then begin
eofs2=make_array(nlonsave,nlatsave,cutoff)
eofspass=make_array(nlonsave,nlatsave)
for ic=0.,cutoff-1. do begin
eofspass(*,*)=myNaN()
eofspass(wheregood)=eofs(*,ic)
eofs2(*,*,ic)=eofspass
endfor
eofs=eofs2 & eofs2=0.
endif else begin
eofs=reform(eofs,nlons,nlats,cutoff)
endelse

end