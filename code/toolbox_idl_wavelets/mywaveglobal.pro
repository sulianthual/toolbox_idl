Pro mywaveglobal,field,tgrid,prange,signif=signif

; Fait le graph de energie globale ondelette = 
; X-axis = power average sur toute la serie
; Y-axis = scale choisis
; Aussi ajoute la significativite a 95% (cf lag1=0.0 par defaut je pense...)
; fait a partir des scripts de Terrence et compo...
;Sulian Thual 2011 adapte
;
; tgrid=time axis
; field=time serie
; prange=range of plot for scales (can be inverted)
; signif : if specified, defines percent of significance (90%=default)

; RQ : attention je ne suis pas sur de la significance.
;      Si un doute, reprendre sgwave par calcul lag1 (en commentaire)
; qui donne la significance a 95% dans le script de base
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

data=field
signif_val=0.90
if keyword_set(signif) then signif_val=signif/100.
; operations
dt=mygridstep(tgrid)
nt=size(data,/n_elements)
; wavelets
wave=wavelet(data,dt,period=pgrid,scale=scwave,mother='Morlet',coi=coiwave)
pwave=abs(wave)^2
gwswave = total(pwave,1)/nt
np=size(scwave,/n_elements)-1
; global wave signif
dof=nt-scwave
;sgwave=wave_signif(data,dt,scwave,1,lag1=0.0,dof=dof,mother='Morlet'); lag1=0.0=>95% percent ?
sgwave=wave_signif(data,dt,scwave,1,siglvl=signif_val,dof=dof,mother='Morlet')

; graph
mygraph & mywindow,7
myplot,gwswave,pgrid,yrange=prange,thick=2
myplot,sgwave,pgrid,/overplot,/noaxis,thick=2,linestyle=2


end