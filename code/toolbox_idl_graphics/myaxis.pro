Pro myaxis,side,axis=axis,title=title,labels=labels,range=range,format=format
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for adding axis on an existing graph
; Sulian THUAL IMARPE-IRD 2008
;
; parameters :
;  side : orientation of axis (1=bottom,2=left,3=top,4=right)
;  axis : if set, gives positions of marks. Elsewhere IDL chooses from 3 to 6 marks alone.
;  title : If set, gives title on axis
;  labels : If set, gives labels on marks. BEWARE : if set labels='' (null string), then numeric values are set(default). Note if labels is set the numeric values are not shown
;  range : If set, range of the axis [min,max]. Should concorde with the xrange or yrange of your graphic.
;
; format : set form [-70�W, -80�W] with the keyword format='(I,??)' where I stands for integer
;          for form [-70.0�W,-80.0�W] use keyword format='(F6.1,??)' where F6.1 means float with 6 chiffres
;
;
; EXAMPLE : after a graphic with no axis (mycontour or myplot with keyword /noaxis for example)
; myaxis,1,title='abcisse';=> makes bottom x-axis with title 'abcisse'
; myaxis,2,axis=findgen(10);=> makes left y-axis with marks on positions of findgen(10)
; myaxis,1,labels=['first','second']=> makes bottom x-axis with labels on marks 'first','second',then '  ' for others
; myaxis,1,range=[0,10]=>makes bottom x-axis on range from 0 to 10 only
;
; TIP : For making an axis(x) with units(cm)
; lb=format_axis_values(x)+'cm'
; myaxis,1,axis=x,labels=lb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Parameters :
if keyword_set(axis) then begin; personal points positions
positions=axis; positioning of ticks marks 
tcks=size(positions,/n_elements); number of ticks, must agree with tickv
endif else begin; automatic points from IDL
positions=fltarr(2); automatic positioning of ticks as !x.tickv(0)=!x.tickv(1)
tcks=0; automatic setting of number of ticks
endelse
if keyword_set(labels) then begin
lbls=replicate(' ',60)
for pii=0,size(labels,/n_elements)-1 do lbls(pii)=labels(pii)
endif else begin
lbls=''
endelse
if keyword_set(title) then ttle=title else ttle=''
if keyword_set(range) then rge=range else rge=[0,0]
;
if ~keyword_set(format) then begin
; case of side(1=bottom,2=left,3=top,4=right)
case 1 of 
(side eq 1) : begin; bottom axis
axis,xaxis=0,xstyle=1,xticks=tcks,xtickv=positions,xtickname=lbls,xtitle=ttle,xrange=rge;,xtickformat='(F6.0,"�W")'
end
(side eq 2) : begin; left axis
axis,yaxis=0,ystyle=1,yticks=tcks,ytickv=positions,ytickname=lbls,ytitle=ttle,yrange=rge
end
(side eq 3) : begin; top axis
axis,xaxis=1,xstyle=1,xticks=tcks,xtickv=positions,xtickname=lbls,xtitle=ttle,xrange=rge
end
(side eq 4) : begin; right axis
axis,yaxis=1,ystyle=1,yticks=tcks,ytickv=positions,ytickname=lbls,ytitle=ttle,yrange=rge
end
else :
endcase
endif else begin
; if format is set
case 1 of 
(side eq 1) : begin; bottom axis
axis,xaxis=0,xstyle=1,xticks=tcks,xtickv=positions,xtickname=lbls,xtitle=ttle,xrange=rge,xtickformat=format
end
(side eq 2) : begin; left axis
axis,yaxis=0,ystyle=1,yticks=tcks,ytickv=positions,ytickname=lbls,ytitle=ttle,yrange=rge,ytickformat=format
end
(side eq 3) : begin; top axis
axis,xaxis=1,xstyle=1,xticks=tcks,xtickv=positions,xtickname=lbls,xtitle=ttle,xrange=rge,xtickformat=format
end
(side eq 4) : begin; right axis
axis,yaxis=1,ystyle=1,yticks=tcks,ytickv=positions,ytickname=lbls,ytitle=ttle,yrange=rge,ytickformat=format
end
else :
endcase
endelse
;
end
