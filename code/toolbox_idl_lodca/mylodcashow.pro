Pro mylodcashow,yearshow,nwindow,commentary
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; PROCEDURE POUR GRAPH SUR SORTIES NETCDF DE LODCA (Dewitte2000)
; Sulian Thual 2011
;
; input:
;
; yearshow: annee a laquelle montrer la carte, 0.=le debut du fichier output
;
; Remarque: on fait un graph lon-time de tout le run avg 5N-5S, et un graph carte a un instant donne, pour taux,sla,sst
;
; nwindow: si parametre defini, donne le numero de la fenetre a utiliser, sinon utilise window=1

; commentary: si parametre defini, ajoute dans titre de chaque figure
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; directory par defaut de lodca
dirlodca=mylodcaversion()
;
filename=dirlodca+'run.c/std/output.nc'

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; grille output = 27 x 20
xgridout=myncdfgetvar(filename,'Xaxis')
ygridout=myncdfgetvar(filename,'Yaxis')
tgridout=myncdfgetvar(filename,'TAXIS') & ntrout=size(tgridout,/n_elements) 
tgridout=findgen(ntrout)/12.
;
ishow=myfindcoord(yearshow,tgridout)
;
sstout=myncdfgetvar(filename,'SST')
slaout=myncdfgetvar(filename,'SL')
txout=myncdfgetvar(filename,'TX')
hout=myncdfgetvar(filename,'H1')
;
; GRAPHIQUES: evolution dans le temps et carte a un instant donne
mygraph 
nnparams=n_params()
if (nnparams eq 1) then begin
mywindow,1; window 1 par defaut
endif else begin
mywindow,nwindow; window donne par utilisateur
endelse
;
if (nnparams ne 3) then commentary=''

mypmulti,3,2
xrange=[101.250,286.875]; range du vrai lodca, tel que le netcdf corresponde !
;
jmin=myfindcoord(-5.,ygridout) & jmax=myfindcoord(5.,ygridout)
;
toshow=myswitch(txout(*,jmin:jmax,*),[1,3,2]) & toshow=mymean(toshow)
mycontour,toshow,xgridout,tgridout,title0='TAUX',xrange=xrange,/nolines,$
;nlevels=11
;levels=(findgen(21)*0.1-1.)*100.
levels=mylevels(toshow,0.05)
mycontour,toshow,xgridout,tgridout,/overplot,/noaxis,/nocolors,levels=mylevels(toshow,0.2)
mycontour,toshow,xgridout,tgridout,/overplot,/noaxis,/nocolors,levels=[-9999,0,9999],labels=[0,0,0],thick=2
!p.color=240 & myplot,[-9999,9999],[yearshow,yearshow],/overplot,/noaxis,thick=2 & !p.color=0
;
toshow=myswitch(slaout(*,jmin:jmax,*),[1,3,2]) & toshow=mymean(toshow)
mycontour,toshow,xgridout,tgridout,title0='SLA',xrange=xrange,/nolines,$
;nlevels=11
levels=mylevels(toshow,2.)
mycontour,toshow,xgridout,tgridout,/overplot,/noaxis,/nocolors,levels=mylevels(toshow,4)
mycontour,toshow,xgridout,tgridout,/overplot,/noaxis,/nocolors,levels=[-9999,0,9999],labels=[0,0,0],thick=2
!p.color=240 & myplot,[-9999,9999],[yearshow,yearshow],/overplot,/noaxis,thick=2 & !p.color=0

toshow=myswitch(sstout(*,jmin:jmax,*),[1,3,2]) & toshow=mymean(toshow)
mycontour,toshow,xgridout,tgridout,title0='SST',xrange=xrange,/nolines,$
;nlevels=11
;levels=(findgen(21)*0.1-1.)*4.
levels=mylevels(toshow,0.2)
mycontour,toshow,xgridout,tgridout,/overplot,/noaxis,/nocolors,levels=mylevels(toshow,0.4)
mycontour,toshow,xgridout,tgridout,/overplot,/noaxis,/nocolors,levels=[-9999,0,9999],labels=[0,0,0],thick=2
!p.color=240 & myplot,[-9999,9999],[yearshow,yearshow],/overplot,/noaxis,thick=2 & !p.color=0
;
;
;toshow=myswitch(hout(*,jmin:jmax,*),[1,3,2]) & toshow=mymean(toshow)
;mycontour,toshow,xgridout,tgridout,title0='THERM',xrange=xrange,$
;nlevels=11
;levels=(findgen(21)*0.1-1.)*50.
;
;
toshow=txout(*,*,ishow)
mycontour,toshow,xgridout,ygridout,xrange=xrange,/nolines,title0=mygoodstring('YR='+string(yearshow),/blanks),$
;nlevels=11
;levels=(findgen(21)*0.1-1.)*0.5
levels=mylevels(toshow,0.05)
mycontour,toshow,xgridout,ygridout,/overplot,/noaxis,/nocolors,levels=mylevels(toshow,0.2)
mycontour,toshow,xgridout,ygridout,/overplot,/noaxis,/nocolors,levels=[-9999,0,9999],labels=[0,0,0],thick=2
;
toshow=slaout(*,*,ishow)
mycontour,toshow,xgridout,ygridout,xrange=xrange,/nolines,title0=commentary,$
;nlevels=11
levels=mylevels(toshow,2)
mycontour,toshow,xgridout,ygridout,/overplot,/noaxis,/nocolors,levels=mylevels(toshow,4)
mycontour,toshow,xgridout,ygridout,/overplot,/noaxis,/nocolors,levels=[-9999,0,9999],labels=[0,0,0],thick=2
;
toshow=sstout(*,*,ishow)
mycontour,toshow,xgridout,ygridout,xrange=xrange,/nolines,title0=commentary,$
;nlevels=11
;levels=(findgen(21)*0.1-1.)*4.
levels=mylevels(toshow,0.2)
mycontour,toshow,xgridout,ygridout,/overplot,/noaxis,/nocolors,levels=mylevels(toshow,0.4)
mycontour,toshow,xgridout,ygridout,/overplot,/noaxis,/nocolors,levels=[-9999,0,9999],labels=[0,0,0],thick=2
;
;
;mycontour,hout(*,*,ishow),xgridout,ygridout,xrange=xrange,$
;nlevels=11
;levels=(findgen(21)*0.1-1.)*50.
;
mygraph
;
end