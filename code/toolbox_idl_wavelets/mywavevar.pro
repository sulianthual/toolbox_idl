Pro mywavevar,field,tgrid,prange,fvar,fsignif,signif=signif

; Fait le graph de average ondelette power sur scale range 
;
; tgrid=time axis
; field=time serie
; prange=range de scales pour faire average (differente de mywavepower,mywaveglobal !), forme [min,max]
;
; retourne:
;fvar=serie temporelle avg power spectrum dans scales prange
;fsignif=niveau de significance (retourne array constant avec la valeur pour plot)
;
; keys:
; signif : if specified, defines percent of significance (90%=default). Ce niveau est choisi pour fsignif

; fait a partir des scripts de Terrence et compo...
; Sulian Thual 2011 adapte
;

;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data=field
signif_val=0.90
if keyword_set(signif) then signif_val=signif/100.
; operations
dt=mygridstep(tgrid)
nt=size(data,/n_elements)
dj=0.125; default utilise dans wavelet (ne pas changer slmt ici)
; wavelets
wave=wavelet(data,dt,period=pgrid,scale=scwave,mother='Morlet',coi=coiwave)
pwave=abs(wave)^2
gwswave = total(pwave,1)/nt
np=size(scwave,/n_elements)-1
; global wave signif
dof=nt-scwave
sgwave=wave_signif(data,dt,scwave,1,lag1=0.0,dof=dof,mother='Morlet',cdelta=cdelta)
; check total variance (partial)
scale_avg = REBIN(TRANSPOSE(scwave),nt,np+1)
power_norm = pwave/scale_avg
;
; Scale-average 
pmin=prange(0) & pmax=prange(1)
avg=where((scwave ge pmin) and (scwave lt pmax))
scale_avg=dj*dt/cdelta*total(power_norm(*,avg),2)  ; [Eqn(24)]
; Scale-average significativity
scaleavg_signif=wave_signif(data,dt,scwave,2,gws=gwswave,siglvl=signif_val,dof=[pmin,pmax],mother='Morlet')
;
fvar=scale_avg
fsignif=fltarr(nt)+scaleavg_signif





end