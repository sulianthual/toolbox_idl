Pro myplot,axis1,field1, $
           overplot=overplot, $
           range=range,xrange=xrange,yrange=yrange, $
           xmargin=xmargin,ymargin=ymargin, $
           thick=thick,linestyle=linestyle,psym=psym,color=color, $
           noaxis=noaxis,symsize=symsize, $
           annotation=annotation, $
           title0=title0,title5=title5, $
           title1=title1,title2=title2,title3=title3,title4=title4, $
           info=info
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for standard plots with IDL
; Sulian THUAL, IRD-IMARPE 2008
;
; axiss : first axis for plot(if not set, a straightline is used to match size of field)
; field : field to be plotted
; overplot : If set, does not erase precedent graphic and overplots
; range : If set, gives range of values to be considered(=[min,max]). 
;         Out of range values are not plotted(missing values).
; xrange : If set,range of view on x-axis(=[min,max]).
; yrange : If set,range of view on y-axis(=[min,max]).
; thick : If set, thickness of the plotted line.
; linestyle : If set, linestyle of the plotted line.(dash, points,full...) 
; psym : If set, psym for the plotted line (0 for linking data points, else only makes marks at data points).
; symsize : If set and psym is set, determines sizes of the symbols
; color : if set, color of the plotted line (else it is !p.color)
; noaxis : If set,no axis are made (useful to edit axis with after call to myaxis)
; annotation : If set, adds an annotation at the right of the plot,using xyouts (not this is a gadget)
; title0 : If set,set general titles. Only if overplot not set.
; title1 : If set,sets axis 1 title(bottom)
; title2 : If set,sets axis 2 title(left)
; title3 : If set,sets axis 3 title(top)
; title4 : If set,sets axis 4 title(right)
; title5 : If set,set general subtitles. Only if overplot not set.
; info : If set, displays informations on field after execution
; 
; EXAMPLES : suppose we have the field a(t) with the axis t
; FIRST YOU SHOULD SET YOU GRAPHIC SETTING WITH mygraph 
; myplot,t,a;=>simple plot
; myplot,t,a,title0='plot',title1='bottom',;=>simple plot with general title and title on bottom aixs
; myplot,t,a,range=[0,max(a)];=> values of 'a' under 0 are not plotted
; myplot,t,a,xrange=[0,max(x)];=> graph view  goes from 0 to max(x) on x-axis.
; myplot,t,a,y then myplot,t,a+1=> plots a then overplots a+1 on the same graph
; myplot,t,a,psym=1; does not link data points.
;
; NOTE : by using xstyle or ystyle ne 1, you may not remove all tick marks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
if keyword_set(overplot) then noaxis=1

; if axis1 not set, make a straightline matching size of field :
if (n_params() eq 1) then begin
field1=axis1
axs1=findgen(size(field1,/n_elements))
endif else begin; normal case where axis1 is set
axs1=axis1
endelse
;
field1=reform(field1)
axs1=reform(axs1)
;
; checks on field :
case 1 of
(size(axs1,/n_dimensions) ne 1) : begin
print,'myplot,ndims(axis) ne 1, returning'
return
end
(size(field1,/n_dimensions) ne 1) : begin
print,'myplot,ndims(field) ne 1, returning'
return
end
(size(axs1,/n_elements) ne size(field1,/n_elements)) : begin
print,'myplot,size(axis) ne size(field), returning'
return
end
else : ; do nothing and continue
endcase
;
; Set region for plot :
if keyword_set(xrange) then xrge=xrange else xrge=[min(axs1),max(axs1)]
if keyword_set(yrange) then yrge=yrange else yrge=[min(field1),max(field1)]
;
; set margin for plot
if keyword_set(xmargin) then xmrgn=xmargin else xmrgn=!x.margin
if keyword_set(ymargin) then ymrgn=ymargin else ymrgn=!y.margin
;
; set range for plot:
if keyword_set(range) then begin
range=range(sort(range))
pass=field1(where (finite(field1) eq 1))
minv=max([min(pass),range(0)])
maxv=min([max(pass),range(1)])
endif else begin
pass=field1(where (finite(field1) eq 1))
maxv=max(pass)
minv=min(pass)
endelse
;
; set other parmeters for plot :
if keyword_set(thick) then thck=thick else thck=0
if keyword_set(linestyle) then lnstl=linestyle else lnstl=0
if keyword_set(psym) then pym=psym else pym=0
if keyword_set(symsize) then symsze=symsize else symsze=1.
if keyword_set(color) then clr=color else clr=!p.color
; Define general title and subtitle
if keyword_set(title0) then ttle=title0 else ttle=''
if keyword_set(title5) then sbttle=title5 else sbttle=''
;
; make plot :
case 1 of
~keyword_set(overplot) and ~keyword_set(noerase) : begin; simple plot
plot,axs1,field1,xrange=xrge,yrange=yrge,min_value=minv,max_value=maxv, $
xstyle=1,ystyle=1,thick=thck,linestyle=lnstl,psym=pym,symsize=symsze,color=clr, $
xmargin=xmrgn,ymargin=ymrgn, $
title=ttle,subtitle=sbttle, $
xticks=1,yticks=1,xtickname=[' ',' '],ytickname=[' ',' ']; no axis drawn
end
keyword_set(overplot) : begin; overplot on existing plot
oplot,axs1,field1,min_value=minv,max_value=maxv, $
thick=thck,linestyle=lnstl,psym=pym,symsize=symsze,color=clr
end
else :
endcase
;
; make axis :
if ~keyword_set(noaxis) then begin
myaxis,1,title=title1; bottom axis
myaxis,2,title=title2; left axis
myaxis,3,title=title3,labels=' '; top axis (no marks)
myaxis,4,title=title4,labels=' '; right axis (no marks)
endif
;
; add a annotation on axis (at the right) :
; this is an example, beste is to use xyouts
if keyword_set(annotation) then begin
xyouts,axs1(size(axs1,/n_elements)-1),field1(size(field1,/n_elements)-1),' '+annotation
endif
;
; print informations :
if keyword_set(info) then begin
print,' '
print,'PROCEDURE myplot :'
print,'AXIS :   size_x=',size(axs1,/n_elements)
print,'         range_x=[',min(axs1),max(axs1),' ]'
print,'FIELD :  mean=',mean(field1)
print,'         range=[',min(field1),max(field1),' ]'
print,'RANGE :  xrange=[',xrge(0),xrge(1),' ]'
print,'         yrange=[',yrge(0),yrge(1),' ]'
print,'         range=[',minv,maxv,' ]'
print,' '
endif

end






