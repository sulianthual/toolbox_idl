function myfindcoord,xfind,xfunc,inf=inf,sup=sup,range=range,arrayindices=arrayindices
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Function for finding unique point of xfunc closest to xfind
; Sulian Thual 2011
;
; INPUT:
; xfind: desired value to find. If array of size(nxf),nxf>1 then returns array with closest point for every element of xfind
; xfunc: array where to search the desired values. Can be of any dimensions.
;
; OUTPUT:
; - return ifind, coordinates of the xfind points ( size ifind=size(xfind), one search for each element)
;   xfunc(ifind) returns the closest values to the desired ones, not however that if xfunc is of dim>1
;   array_indices must be used to get back 
;   Rq: aux points ou ne trouve rien on aura -1
;
; KEYWORD:
;
; -sup or inf: imposes in search finding superior-equal or inferior-equal value to the searched one
;
; -range: si mis, programme tres different (inf et sup sans interet). Renvoie les indices du champ
;         comprise entre min(xfind) et max(xfunc), ordered. Ex: sur xfunc=axe latitude ygrid, find partie
;         entre -5N,5S ifind. Puis fait mean(xfunc(ifind)) pour average par example. 
;
; -arrayindices: instead of returning ifind(nxf) returns ifind(ndims,nxf) where ndims is the number
;  of dimensions of xfunc. In that case ifind(idim,ixf) is for the ixf searched value the coordinate
;  of the closest point found on the idim dimension. it is equal to converting ifind with array_indices
;   dans ce cas, pour print la value la plus proche trouvee faire print,xfunc(ii(0),ii(1)...) au lieu de xfunc(ii)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
if ~keyword_set(range) then begin

; trouve point le plus proche pour chaque element de xfunc
nxf=size(xfind,/n_elements)
ifind=intarr(nxf); coords a trouver
for ii=0.,nxf-1. do begin
; fonction avec minimum a trouver
xifind=xfind(ii)
Xdist=abs(xfunc-xifind)
if keyword_set(inf) then Xdist(where(xfunc gt xifind))=max(Xdist)+1.; enleve ces values
if keyword_set(sup) then Xdist(where(xfunc lt xifind))=max(Xdist)+1.; enleve ces values
ismin=where(Xdist eq min(Xdist))
ifind(ii)=ismin(0); prend le premier
endfor
;
endif else begin

; trouve partie de xfunc compris dans le range min(xfind),max(xfind)
xmin=min(xfind) & xmax=max(xfind)
ifind=where( (xfunc ge xmin) and (xfunc le xmax) ); ici on a alors un vecteur
endelse
;
;
; Si desire, retourne sans la forme indices array
if keyword_set(arrayindices) then begin
nxf=size(ifind,/n_elements)
dims=size(xfunc,/dimensions) & ndims=size(dims,/n_elements)
iifind=intarr(ndims,nxf)-1
for ii=0.,nxf-1. do begin
ipass=ifind(ii)
if (ipass ne -1) then iifind(*,ii)=array_indices(dims,ipass,/dimensions)
endfor
ifind=iifind
endif


return,ifind
;
end