function myaclim,field,year,clim=clim,cycle=cycle
compile_opt hidden
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for extracting anomalies from field of form field(*...,time) with IDL :
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUT PARAMETERS :
;
; field : input field, with form field(*,...,time).
;         Note that time MUST BE the last dimension for field.
; year : cycle for a year, relative to the field timestep. For example if field is in month than a cycle 
;         for a climatology is a year (12 months), so you will take year=12.
;         Note the cycle starts on first time step of your time serie.
;
; OPTIONNAL PARAMETERS :
;
; clim (optionnal) : If set, returns only the climatology, with form clim(*,...,time), ie on all the time serie.
; cycle(optionnal) : If set, returns only the climatology cycle with form climcycle(*,...year)
;
; CALLING SEQUENCE :
;
;  afield=myaclim(field,12)=> field with climatology removed
;
;  clim_field=myaclim(field,12,/clim)=> climatology on the whole time period
;
; clim_cycle=myaclim(field,12,/cycle)=> climatology cycle, (12 time steps)
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
print,'myaclim : year > nt, returning'
return,0
endif
;
; recompose data in (year,month) format
recompose=make_array(n1,n_an,year)
for n=0,n_an-1 do begin
for kc=0,year-1 do begin
recompose(*,n,kc)=data(*,kc+n*year)
endfor
endfor
;
; calculate "monthly" climatology=climcycle
clima=make_array(n1,year)
for pi1=0.,n1-1. do begin
for kc=0,year-1 do begin
clima(pi1,kc)=mean(recompose(pi1,*,kc))
endfor
endfor
;
; 
; case , return aclim,clim or climcycle :
case 1 of 
;
keyword_set(cycle) : begin; return climcycle
; reform output
if (size(dims,/n_elements) eq 1) then begin
clima=reform(clima); gets out degenerated dimension of clima
endif else begin
myreform2,clima,[dims(0:size(dims,/n_elements)-2),year]
endelse
return,clima
end
;
keyword_set(clim) : begin; return clim
climato=make_array(n1,nt)
; attribute of climatology using climcycle
for n=0,n_an-1 do begin
for kc=0,year-1 do begin
climato(*,kc+n*year)=clima(*,kc)
endfor
endfor
; for last year (if nt > n_an*cycle), complete with part of climcycle
if (nt gt n_an*year) then begin
print,'myaclim : warning, nt > n_an*year, completing part of last year with part of climatology'
kc=0
for k=n_an*year,nt-1 do begin
climato(*,k)=clima(*,kc)
kc=kc+1
endfor
endif
myreform2,climato,dims
return,climato
end
;
else : begin; return aclim
aclim=make_array(n1,nt)
; calculate new field without climatology
for n=0,n_an-1 do begin
for kc=0,year-1 do begin
aclim(*,kc+n*year)=data(*,kc+n*year)-clima(*,kc)
endfor
endfor
; for last year (if nt > n_an*year), complete with part of climcycle
if (nt gt n_an*year) then begin
print,'myaclim : warning, nt > n_an*year, completing part of last year with part of climatology'
kc=0
for k=n_an*year,nt-1 do begin
aclim(*,k)=data(*,k)-clima(*,kc)
kc=kc+1
endfor
endif
myreform2,aclim,dims
return,aclim
end
;
endcase
;
end


