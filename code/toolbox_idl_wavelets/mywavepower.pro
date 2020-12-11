Pro mywavepower,field,tgrid,prange,levels=levels,signif=signif
; Fait le graph du power spectrum des ondelettes
; (power, signif at 90% selon method gws, cone influence bords)
; fait a partir des scripts de Terrence et compo...
;Sulian Thual 2011 adapte
;
; tgrid=time axis
; field=time serie
; prange=range of plot for scales (can be inverted)
; levels : if specified,specify levels (with lines)
; signif : if specified, defines percent of significance (90%=default)
; 
; Rq : si field en C, alors power en C^2 ! 
; pour connaitre levels, utiliser mywaveglobal

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
signif_val=0.90
if keyword_set(signif) then signif_val=signif/100.
; operations
dt=mygridstep(tgrid)
nt=size(data,/n_elements)
; wavelets
wave=wavelet(data,dt,period=pgrid,scale=scwave,mother='Morlet',coi=coiwave)
;awave=float(wave) & phwave=atan(imaginary(wave),float(wave))
pwave=abs(wave)^2
gwswave = total(pwave,1)/nt
np=size(scwave,/n_elements)-1
; wave signif
swave=wave_signif(data,dt,scwave,0,GWS=gwswave,siglvl=signif_val,mother='Morlet')
swave=rebin(transpose(swave),nt,np+1)
swave=pwave/swave
; graph
mygraph & mywindow,6
if keyword_set(levels) then begin
mycontour,pwave,tgrid,pgrid,yrange=prange,levels=levels; plot
endif else begin
mycontour,pwave,tgrid,pgrid,/nolines,yrange=prange; plot
endelse
!p.color=250 
mycontour,swave,tgrid,pgrid,/overplot,/nocolors,/noaxis,$
levels=[-9999.,1.,9999.],labels=[0.,0.,0.]; signif levels 90%
myplot,tgrid,coiwave,/overplot,/noaxis,thick=2; cone of borders influence 
!p.color=0.


end