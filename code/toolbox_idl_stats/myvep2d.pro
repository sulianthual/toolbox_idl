pro	myvep2d,field,pcs,svls,FVE,cutoff,iteration=iteration
;

; Calcule les vecteurs propres et valeurs propres d'un champ 2d a la base
; C'est une remodification de myeof2d : Ici il faut donner un champ (nx,nt) et on a 
; des vecteurs propres de dimension nt. Pour retrouver la forme nx il faut correler en tout nx avec le vep associé
; on ne renvoit qu'une partie des vep calculés (v mais u n'est pas renvoyé)
; VOIR AUSSI EIGENVEC, cela semble plus juste
; Sulian THUAL 2009
;
; modified :
;
; Sulian Thual IMARPE-IRD 2009
; from /home/dan/idl/EOFcalc.pro
; 27/1/04

; field =  array containing input field (assumed to be (lon,time) ie of dimensions 2d)
; vep  =  output array containing pcs (vector propres) (time,cutoff)
; vp  =  output array containing the singular values (cutoff)
; FVE   =  % var explique de chaqye vp
; iterations(optionnal) : if set, controls the number of iterations for svdc.default value is 30.
;
; nan : AJOUTE LE 9 mars 2009 par Sulian. SI ce keyword est mis alors on fait la SVD sur la partie sans NaN.
;       Notons que pour un champ field(lon,lat,time) s'il y a un NaN c'est en (lon,lat), et alors on considere
;       toute la serie temporelle comme etant a NAN. Ces NaN servent a faire un mask pour la SVD
; 
s=size(field)
nlons=float(s(1))
ntims=s(2)
data=field
;

tr=0
print,'tr calc'
for jk=0.,nlons-1. do begin
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
pcs=v
svls=w
FVE=(svls*svls)/tr
print,'CHECK. Sum of space variances',total(w*w)/(ntims-1),tr/(ntims-1)

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
