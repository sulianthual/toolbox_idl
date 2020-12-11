function mycycle,field,year
compile_opt hidden
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for cycling a field : given a period cycle nc (year in the calling sequence),
;   field(x,...,t) becomes field (x,...,nc,t*)
; ie separates field into nc time series constructed from the steps of the cycle. 
; 
; (for example with nc=12 and monthly data, field(x,...,0,t*) is conditions at all Januaries of each years 
;

;  Sulian Thual, 2011
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,...,time).
;         Note that time MUST BE the last dimension for field.
; year : taille du cycle , entier
;
; Rq : - marche aussi pour field(t) (une dimension)
;      - on ne prend pas en compte la fin du cycle (qui depasse de fix(nt/year) )
;
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
data=field
myreform1,data,dims,prod,time
;
n1=prod
nt=time & n_an=fix(nt/year)
;
; checks on data
if (year gt nt) then begin
print,'mycycle : year > nt, returning'
return,0
endif
;
; recompose data in (year,month) format
recompose=make_array(n1,year,n_an)
for nn=0,n_an-1 do begin
for kc=0,year-1 do begin
recompose(*,kc,nn)=data(*,kc+nn*year)
endfor
endfor
;
ndims=size(dims,/n_elements)
if (ndims gt 1) then begin
myreform2,recompose,[dims(0:ndims-2),year,n_an]; champ field(x,t)
endif else begin
recompose=reform(recompose); serie field(t)
endelse



;
return,recompose
; 
;
end


