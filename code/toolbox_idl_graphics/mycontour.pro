Pro mycontour,field,axs1,axs2, $
               overplot=overplot, $
               range=range,maxs=maxs,xrange=xrange,yrange=yrange, $
               xmargin=xmargin,ymargin=ymargin, $
               nolines=nolines,nocolors=nocolors,noaxis=noaxis, $
               levels=levels,nlevels=nlevels, $
               annotations=annotations,labels=labels, $
               title0=title0,title5=title5, $
               title1=title1,title2=title2,title3=title3,title4=title4, $
               info=info,linestyle=linestyle,thick=thick,nolabels=nolabels,overzero=overzero
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; 2011: ajout nolabels: directement pas de labels
;       nozero: directement contour isotherme zero seulement, sans ligne, en overplot
;
; 2012: ajout: si existe NaN dans levels, alors met keyword nlevels on
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for standard contour with IDL :
;  Sulian Thual, IRD-IMARPE 2008
; 
; field : field to be contoured
; axs1 : first axis for contour. If not set, a straighline is automatically made for both axis(do not set other axis either)
;         note axis1 can be of dimensions 2 defining abcsisse positions of a contour grid(do not set other axis either)
; axs2 : second axis for contour.If not set, an straighline is automatically made for both axis.
;         note axis2 can be of dimensions 2 defining ordonnees positions of a contour grid.
; overplot : If set, does not erase precedent graphic and overplots
; range : If set, gives range of values to be considered(=[min,max]). 
;         Out of range values are not contoured(missing values).
; maxs : If set, values out of maxs are put to NaN values, and are not contoured (maxs=[min,max])
; xrange : If set,range of view on x-axis(=[min,max]).
; yrange : If set,range of view on y-axis(=[min,max]).
; xmargin : If set, gives marge on x-axis (ie borders),(=[border1,border2])
; ymargin : If set, gives marge on y-axis (ie borders),(=[border1,border2])
; nolines : If set, no lines are contoured
; nocolors : If set,no colors are contoured
; noaxis : If set,no axis are made (useful to edit axis with after call to myaxis)
; levels : If set,sets levels used for contour(ie the field values,defining intervals for wich each color is attributed).
;          If not set and nlevels no set, function draws a straightline on field range with 20 colors(ie 20 levels).
;          If set, values outside of levels range are treated as missing values, and are not contoured.
; nlevels : If set,sets the number of levels(default is 20). A straightline is made on field range to determine levels(ie colors).
;           Is stronger than keyword levels, if both are present
;
; annotations : If set,determines the annotations made for each level of the contour (if lines are drawn).
;              By default, the annotation for each level is the corresponding numeric value(that is string-formatted). 
; labels : for each levels, defines if it is labeled(=1 for label,=0 for no label).If needed concatenates to match level array size.
; title0 : If set,sets general titles. Only if overplot not set.
; title1 : If set,sets axis 1 title(bottom)
; title2 : If set,sets axis 2 title(left)
; title3 : If set,sets axis 3 title(top)
; title4 : If set,sets axis 4 title(right)
; title5 : If set,sets general subtitles. Only if overplot not set.
; info : If set, displays informations on field after execution
;
; EXAMPLES : suppose we have the field a(x,y) and the axis x and y.
; FIRST YOU SHOULD SET YOU GRAPHIC SETTING WITH mygraph 
;mycontoura,x,y;=>simple contour
; mycontour,a,x,y,title0='contour',title1='bottom',;=>simple contour with general title and title on bottom aixs
; mycontour,a;=>simple contour, x and y are made with staightlines.
; mycontour,a,x,y,range=[0,max(a)];=> values of 'a' under 0 are not plotted
; mycontour,a,x,y,xrange=[0,max(x)];=> graph view  goes from 0 to max(x) on x-axis.
; mycontour,a,x,y,/nolines,/noaxis then mycontour,a,x,y,/nocolors;=> make only colors then only lines, on the same graph
; mycontours,a,x,y,levels=[0,10,100],annotations=['one','two','three'],labels=[1,0,1];=>only three levels in contours,
; mycontours,a,x,y,levels=[0,10,100,1000],,labels=[1,0];=>un level sur deux est labell� (on concatenate le labels)
; with annotations 'one','two','three' and where second annotation is not shown(cf labels).
;
; NOTES : charsize,charthick(size,thickness of characters)...and other parameters are set with the global !p system,
;         but you can edit this script in some parts to determine them.
; 
; TO DO : Add choice of colors, using c_colors. But I cannot find the default values. Also see tek_color.
; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
if keyword_set(overplot) then noaxis=1
if keyword_set(nolabels) then labels=[0,0,0]; ajout aout2011 a verifier
;
if keyword_set (overzero) then begin
noaxis=1
overplot=1
labels=[0,0,0]
nocolors=1
levels=[min(field)-1,0,max(field)+1]
endif

; change variable(if no axis defined, define default axis ):
fieldaff=field
fieldaff=reform(fieldaff)
if (size(axs1,/type) eq 0) then axis1=findgen((size(fieldaff,/dimensions))(0)) else axis1=axs1
if (size(axs2,/type) eq 0) then axis2=findgen((size(fieldaff,/dimensions))(1)) else axis2=axs2
;
; checks on field :
case 1 of
(size(fieldaff,/n_dimensions) ne 2) : begin
print,'mycontour : dimensions ne 2,returning'
return
end
(size(axis1,/n_dimensions) gt 2) : begin
print,'mycontour : dimension axis1 gt 2,returning'
return
end
(size(axis2,/n_dimensions) gt 2) : begin
print,'mycontour : dimension axis2 gt 2,returning'
return
end
((size(fieldaff,/dimensions))(0) ne size(axis1,/n_elements) and (size(axis1,/n_dimensions) eq 1)) : begin
print,'mycontour : size axis1(0) ne size field,returning'
return
end
((size(fieldaff,/dimensions))(1) ne size(axis2,/n_elements) and (size(axis2,/n_dimensions) eq 1)) : begin
print,'mycontour : size axis2(0) ne size field,returning'
return
end
else : ; do nothing and continue
endcase
;
; Set region for field :
if keyword_set(xrange) then xrge=xrange else xrge=[min(axis1),max(axis1)]
if keyword_set(yrange) then yrge=yrange else yrge=[min(axis2),max(axis2)]
;
; set margin for plot
if keyword_set(xmargin) then xmrgn=xmargin else xmrgn=!x.margin
if keyword_set(ymargin) then ymrgn=ymargin else ymrgn=!y.margin
;
; put outrange values to NaN
if keyword_set(maxs) then begin
maxs=maxs(sort(maxs))
if ((where(fieldaff lt maxs(0)))(0) ne -1) then fieldaff(where(fieldaff lt maxs(0)))=!VALUES.F_NAN
if ((where(fieldaff gt maxs(1)))(0) ne -1) then fieldaff(where(fieldaff gt maxs(1)))=!VALUES.F_NAN
endif
;
; set range for field (for levels computation) :
if keyword_set(range) then begin
range=range(sort(range))
minv=max([min(fieldaff(where(finite(fieldaff)))),range(0)])
maxv=min([max(fieldaff(where(finite(fieldaff)))),range(1)])
endif else begin
maxv=max(fieldaff(where(finite(fieldaff))))
minv=min(fieldaff(where(finite(fieldaff))))
endelse
;
; compute contour levels :
if keyword_set(levels) then dolevels=1 else dolevels=0; modif dec 2011, tq keyword nlevels > levels
if (dolevels eq 1) then begin; modif janv 2012, si NaN alors enleve keyword levels=
isnan=finite(levels) 
if (min(isnan) eq 0) then dolevels=0
endif
if keyword_set(nlevels) then dolevels=0
case 1 of
(dolevels eq 1) : begin
lvls=levels(uniq(levels,sort(levels)))
maxv=max(lvls)
minv=min(lvls)
end
else : begin
if keyword_set(nlevels) then nc=nlevels else nc=20
if (nc lt 2) then nc=20
maxvl=maxv; could be max(fieldaff), relative to whole field
minvl=minv; could be min(fieldaff), relative to whole field
lvls=(maxvl-minvl)/float((nc-1))*findgen(nc)+minvl
lvls=lvls(uniq(lvls,sort(lvls))); avoid repetition of levels
end
endcase
;
; Define general title and subtitle
if keyword_set(title0) then ttle=title0 else ttle=''
if keyword_set(title5) then sbttle=title5 else sbttle=''
;
; make contour of colors :
case 1 of
keyword_set(nocolors) : ; do nothing, first statement seen in case
~keyword_set(overplot) : begin; new color contour
contour,fieldaff,axis1,axis2, $; make a color contour with no characters
xstyle=1,ystyle=1, $; fit contour region to axis
levels=lvls,c_label=lvls*0., $; levels and no labels
xticks=1,yticks=1, $; no tick marks or names
xtickname=[' ',' '],ytickname=[' ',' '], $; no tick characters
xrange=xrge,yrange=yrge, $; region 
xmargin=xmrgn,ymargin=ymrgn,$ ; margin
max_value=maxv,min_value=minv, $; max and min values 
title=ttle,subtitle=sbttle, $; title and subtitle
/cell_fill; put colors
end
keyword_set(overplot) : begin; over color contour
contour,fieldaff,axis1,axis2, $
xstyle=1,ystyle=1, $
levels=lvls,c_label=lvls*0., $
xticks=1,yticks=1, $
xtickname=[' ',' '],ytickname=[' ',' '], $
xrange=xrge,yrange=yrge, $
xmargin=xmrgn,ymargin=ymrgn,$ 
max_value=maxv,min_value=minv, $
/cell_fill, $
/overplot, $; overplot on precedent contour
/follow,/noerase; same as overplot, for old IDL versions
end
else : ; do nothing and continue
endcase
;
; Set lines contour parameters :
if keyword_set(labels) then begin; modif fev 2009( labels est concatenate)
lbls=fix(labels) 
lbls0=lbls
while (size(lbls,/n_elements) lt size(lvls,/n_elements)) do lbls=[lbls,lbls0]
endif else begin
lbls=fix(lvls*0.)+1; labels(1=show,0=unshow)
endelse
if keyword_set(annotations)then antn=annotations else antn=format_axis_values(lvls) ; annotations on lines
if ((where(lbls eq 0))(0) ne -1) then  antn(where(lbls eq 0.))=''
if keyword_set(linestyle)then lnstyle=linestyle else lnstyle=!p.linestyle; style of lines
if keyword_set(thick)then thck=thick else thck=!p.thick; thickness of lines
;
clrs=!p.color; color(s) of lines
cthck=!p.charthick; thickness of characters on annotations
csize=!p.charsize; size of characters on annotations
;
; make contour of lines :
case 1 of
keyword_set(nolines) : ; do nothing, first statement seen in case
(~keyword_set(overplot) and keyword_set(nocolors)) : begin; new line contour
contour,fieldaff,axis1,axis2, $
xstyle=1,ystyle=1, $
levels=lvls, $; levels(c_label not set as c_annotation is set).
xticks=1,yticks=1, $; no tick marks or names
xtickname=[' ',' '],ytickname=[' ',' '], $; no tick characters
xrange=xrge,yrange=yrge, $
xmargin=xmrgn,ymargin=ymrgn,$ 
max_value=maxv,min_value=minv, $
title=ttle,subtitle=sbttle, $
c_linestyle=lnstyle,c_thick=thck,c_colors=clrs, $; style,thickness and colors of lines
c_annotation=antn, $; annotations on each line
c_charthick=cthck,c_charsize=csize,$; thickness and size of characters
c_labels=lbls
end 
(keyword_set(overplot) or ~keyword_set(nocolors)) : begin; over line contour
contour,fieldaff,axis1,axis2, $
xstyle=1,ystyle=1, $
levels=lvls, $
xticks=1,yticks=1, $
xtickname=[' ',' '],ytickname=[' ',' '], $
xrange=xrge,yrange=yrge, $
xmargin=xmrgn,ymargin=ymrgn,$ 
max_value=maxv,min_value=minv, $
c_linestyle=lnstyle,c_thick=thck,c_colors=clrs, $
c_annotation=antn, $
c_charthick=cthck,c_charsize=csize, $
/overplot, $; overplot on precedent contour
/follow,/noerase,$; same as overplot, for old IDL versions
c_labels=lbls
end
else :
endcase
;
; set parameters for axis :
axclrs=!p.color; colors for axis
axcsize=!p.charsize; character size for axis
xtks=!x.ticks; thick marks for axis
ytks=!y.ticks; thick marks for axis
xtknme=!x.tickname; labels on thick marks for axis
ytknme=!y.tickname; labels on thick marks for axis
;
; make axis and titles :
if ~keyword_set(noaxis) then begin
myaxis,1,title=title1,range=xrge; bottom axis
myaxis,2,title=title2,range=yrge; left axis
myaxis,3,title=title3,range=xrge,labels=' '; top axis (no marks)
myaxis,4,title=title4,range=yrge,labels=' '; right axis (no marks)
endif
;
;
; print informations :
if keyword_set(info) then begin
print,' '
print,'PROCEDURE mycontour :'
print,'LEVELS : range=[',lvls(0),lvls(size(lvls,/n_elements)-1),' ]'
print,'         nlevels=',size(lvls,/n_elements)
print,'AXIS :   dims_x=',size(axis1,/dimensions)       
print,'         range_x=[',min(axis1),max(axis1),' ]'
print,'         dims_y=',size(axis2,/dimensions)
print,'         range_y=[',min(axis2),max(axis2),' ]'
print,'FIELD :  mean=',mean(fieldaff)
print,'         range=[',min(fieldaff),max(fieldaff),' ]'
print,'RANGE :  xrange=[',xrge(0),xrge(1),' ]'
print,'         yrange=[',yrge(0),yrge(1),' ]'
print,'         range=[',minv,maxv,' ]'
print,' '
;
endif









end