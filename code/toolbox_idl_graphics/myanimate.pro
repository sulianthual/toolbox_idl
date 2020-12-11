Pro myanimate,data1,axs1,axs2,rate=rate,loop=loop,static=static,maxs=maxs,lvls=lvls,nolines=nolines,skip=skip
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function to animate on screen contour visualisation of a field
; Sulian THUAL IMARPE-IRD 2008
;
; data1 : the data of form 2d*time 
; rate : the rate between each contour (a loop of size rate is made, with prints).default is 5000
; loop : the number of loops covering the time period to make. default is 1.
; static : set keyword to keep initial levels between animation, calculated as straightline from (min,max) of whole field
; skip : nombre de pas de temps a sauter entre chaque plot
;          if set to value then gives number of colors used (default is 20 as in mycontour)
; NOTES : 
;  - normally you should uses the MPEG tools for this, but image display crashes on my computer 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; change and reform data :
data=data1
data=reform(data)
if (size(axs1,/type) eq 0) then axis1=findgen((size(data,/dimensions))(0)) else axis1=axs1
if (size(axs2,/type) eq 0) then axis2=findgen((size(data,/dimensions))(1)) else axis2=axs2

; open graphic window
mygraph
;
; set static levels (for contours), if set :
if keyword_set(static) then begin
maxv=max(data)
minv=min(data)
if (static eq 1) then nc=20 else nc=static; 
maxvl=maxv; could be max(fieldaff), relative to whole field
minvl=minv; could be min(fieldaff), relative to whole field
lvls=(maxvl-minvl)/float((nc-1))*findgen(nc)+minvl
lvls=lvls(uniq(lvls,sort(lvls))); avoid repetition of levels
endif
;
; make maxs keyword for contours :
if keyword_set(maxs) then begin
maxs=maxs(sort(maxs))
min1=maxs(0)
max1=maxs(1)
endif else begin
min1=min(data)
max1=max(data)
endelse
;
; make first empty contour to open window
if keyword_set(lvls) then begin
if keyword_set(nolines) then begin
mycontour,data(*,*,0),axis1,axis2,title0='myanimate',maxs=[min1,max1],levels=lvls,/nolines
endif else begin
mycontour,data(*,*,0),axis1,axis2,title0='myanimate',maxs=[min1,max1],levels=lvls
endelse
endif else begin
if keyword_set(nolines) then begin
mycontour,data(*,*,0),axis1,axis2,title0='myanimate',maxs=[min1,max1],/nolines
endif else begin
mycontour,data(*,*,0),axis1,axis2,title0='myanimate',maxs=[min1,max1]
endelse
endelse
;
; set parameters of loop
ndims=size(data,/n_dimensions)
nt=(size(data,/dimensions))(ndims-1)
if keyword_set(loops) then nloops=loops else nloops=1
if keyword_set(rate) then rater=rate else rater=5000
;
; skip parameter
if keyword_set(skip) then whenskip=skip else whenskip=0
; loop for contouring 
for pilp=0,nloops-1 do begin
countskip=0
for pit=0,nt-1 do begin
countskip=countskip+1
if (~keyword_set(skip) or (countskip eq whenskip)) then begin
countskip=0
; make contour
if keyword_set(static) then begin
if keyword_set(lvls) then begin
if keyword_set(nolines) then begin
mycontour,data(*,*,pit),axis1,axis2,levels=lvls,/overplot,maxs=[min1,max1],/nolines
endif else begin
mycontour,data(*,*,pit),axis1,axis2,levels=lvls,/overplot,maxs=[min1,max1],/nolines
endelse 
endif else begin
if keyword_set(nolines) then begin
mycontour,data(*,*,pit),axis1,axis2,levels=lvls,/overplot,maxs=[min1,max1],/nolines
endif else begin
mycontour,data(*,*,pit),axis1,axis2,levels=lvls,/overplot,maxs=[min1,max1]
endelse
endelse
endif else begin 
if keyword_set(lvls) then begin
if keyword_set(nolines) then begin
mycontour,data(*,*,pit),axis1,axis2,/overplot,maxs=[min1,max1],levels=lvls,/nolines
endif else begin
mycontour,data(*,*,pit),axis1,axis2,/overplot,maxs=[min1,max1],levels=lvls
endelse
endif else begin
if keyword_set(nolines) then begin
mycontour,data(*,*,pit),axis1,axis2,/overplot,maxs=[min1,max1],/nolines
endif else begin
mycontour,data(*,*,pit),axis1,axis2,/overplot,maxs=[min1,max1]
endelse
endelse
endelse
; do something as a timer (print message):
for pii=1,rater do begin
print,strtrim(['myanimate:loop=',string(pilp),'/',string(nloops),',time=',string(pit),'/',string(nt),',rate count= ',string(pii),'/',string(rater)],1 )
endfor
;
endif
endfor
endfor



end


