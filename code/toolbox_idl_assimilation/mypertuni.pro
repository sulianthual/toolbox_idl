function mypertuni,yobs,nens,pstd,onlypert=onlypert
compile_opt hidden
;
; Pour un champ observations, retourne n membres perturbes selon distribution uniforme stddev a donner
; Sulian 2011
;
; inputs:
;
; -yobs: champ observe (nx,ny...)
;
; -nens: nombre de membres desire
;
; -pstd: standard deviation pour perturbation a ajouter (pour distribution normale autour de 0)
;        si size(pstd) ne 1 (donc egal a size(yobs)) alors chaque point de obs a une pert a lui
;
; output: 
;
; -ypert: nens membres du champ observe (nx,ny...nens) perturbes
;         une distribution normale differente est ajoutee en chaque point de yobs
;         on force le mean nul sur les membres
;     
;
; keyword:
;
; -onlypert: retourne seulement les perturbations, sans ajouter la base des obs
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=yobs
dims=size(data,/dimensions)
prod=product(dims)
data=reform(data,prod)
;
; perturbation mise; uniforme ou differente en chaque point de yobs
pstdput=pstd
if (size(pstd,/n_elements) eq 1) then pstdput=fltarr(prod)+pstd

ypert=fltarr(prod,nens)
for ii=0,prod-1 do ypert(ii,*)=myrandomn(nens)*pstdput(ii)
pstdput=0;memory
;ypert=myamean(ypert); force le mean nul: je pense que ce n est pas necessaire
;
if ~keyword_set(onlypert) then begin
for iens=0,nens-1 do begin
ypert(*,iens)=ypert(*,iens)+data; ajoute obs
endfor
endif
data=0;memory
;
ypert=reform(ypert,[dims,nens])
;
return,ypert





end