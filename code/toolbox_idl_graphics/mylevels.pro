function mylevels,field,step,start=start,regular=regular
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for finding levels of a field before mycontour.pro :
;  Sulian Thual, IRD-IMARPE 2008
; 
; -levels without keyword : between min and max with nlevels=21
;      Adds two points out of range
;      Only on finite part (NaN values removed)
;
; -step : defines the step of leveling (between min and max) 
;  With the starting point, you define levels=findgen(...)*step+start then only 
;  take the part in min(field)-max(field) range. This is useful if for example you want
;  only enters in levels (you will define step=1,start=0). If you want levels being 6.5,7.5,8.5 etc...
;  then define step=1,start=0.5. 
;  cannot be used with keyword regular. Most of all ENSURES REGULAR STEPPING.step is >0
;
; -keyword start : define yourself the starting point (default is zero).
;
; -keyword regular : construct a regular line between min and max, specifying number of levels.
;   With this method you dont have to think about values, but you will have levels like 1.54532
;  wich can be anoying in visualisation. If used step and start will not be considered
;  Also ENSURES REGULAR STEPPING
;
; Example : levels=mylevels(field,regular=21); 21 points between min and max(+2out of range points)
;
; levels=mylevels(field,1) : only enters between min and max (+2 out of range points), starting
;                            from O levels=indgen(...) and only part betwwen min and max
; levels=mylevels(field,1,start=0.5) : levels will be 0.5,1.5,2.5 etc... between min and max
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
data=field
;
data=data(where(finite (data)))
maxf=max(data)
minf=min(data)
;
if keyword_set(regular) then begin
nc=regular
lvls=(maxf-minf)/float((nc-1))*findgen(nc)+minf

endif else begin
sttep=step & sttep=abs(step)
if keyword_set(start) then sttart=start else sttart=0
; find one point of level=start+n*step between min and max
; if doesnt exist then stop and return
nini=fix((minf-sttart/sttep))
lv1=float(sttart)+float(nini)*sttep & if (lv1 gt minf) then lv1=lv1-sttep
lvls=lv1
while (lv1 le maxf) do begin
lv1=lv1+step
lvls=[lvls,lv1]
endwhile
lvls=lvls(where ( (lvls ge minf) and (lvls le maxf) ) )
endelse
;
lvls=[fix(minf)-10,lvls,fix(maxf)+10]; add out of range levels
lvls=lvls(uniq(lvls,sort(lvls))); avoid repetition of levels
return,lvls
;

end