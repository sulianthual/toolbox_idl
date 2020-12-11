function myinterpol,field1,grid1,grid2,parts=parts, $
         lsquadratic=lsquadratic,quadratic=quadratic,spline=spline, $
         auto=auto,missing=missing
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; interpolates a field on new grid, for one dimension only
; Sulian THUAL IMARPE-IRD 2008
;
; field1 : initial field
; grid1 : initial grid
; grid2 ; new grid wanted
; parts : if set, array of position for interpolating by parts (positions ge and le relatives to parts).
;         auto keyword is then automatically used. Note that interpolation is made only within the intervals between
;         points of parts. Example : parts=[0,1,2]=> interpolation made on [0,1] and [1,2] only.
;         to restrain interpolation to input grid range : parts=[...,min(grid1),max(grid1)]
;         to interpolate with parts on all the output grid : parts=[...,min(grid2),max(grid2)]
; missing : If set, and when using parts keyword, defines the default value of output field where 
;           interpolation is not made. Default value is NaN.
; lsquadratic : if set, lsquadratic interpolation
; quadratic : if set, quadratic interpolation
; spline : if set, spline interpolation
; auto : if set, automatically switchs to linear interpolation if necessary. 
;        Explanation : To make a good interpolation, linear needs two points, quad 3 points, lsquad & spline 4 points
;        If there is not enough points, switch is made to linear or interpolation is not made if one point.
;        Not that will working with parts, if in one part only one grid1 point is available, unstead of not 
;        making the interpolation then interpolation is made from the entire grid1 set (using linear interpolation).
;       Note that when using parts (that can lead to sections with very few points), this method is automatically used.
;
; NOTES : default is linear interpolation, else lsquadratic,quadratic or spline interpolation
;        do not define various interpolation type at the same time.
;        function returns field2.
; NOTE ON PARTS : normally, interpol from IDL uses ALL input grid to interpolate on ALL output grid.
;                 YOU may want to systematically use the parts keyword, first is the output grid range is 
;                 larger than the input grid, to avoid a false interpolation outside input grid range
;                 (in that case use missing keyword to define value outside of input grid range), and
;                 secondly if output grid range is smaller than input grid range, and you want to consider
;                 influence on a specific zone.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
fieldd1=field1
gridd1=grid1
gridd2=grid2
if keyword_set(parts) then partts=parts
fieldd1=reform(fieldd1)
gridd1=reform(gridd1)
gridd2=reform(gridd2)
;
; checks :
if (size(fieldd1,/n_dimensions) ne 1) then begin
print,'myinterpol, ndims(fieldd1) ne 1, returning'
return,0
endif
if (size(gridd1,/n_dimensions) ne 1) then begin
print,'myinterpol, ndims(gridd1) ne 1, returning'
return,0
endif
if (size(gridd2,/n_dimensions) ne 1) then begin
print,'myinterpol, ndims(gridd2) ne 1, returning'
return,0
endif
if (size(fieldd1,/n_elements) ne size(gridd1,/n_elements)) then begin
print,'myinterpol, size(fieldd1) ne size(gridd1), returning'
return,0
endif
if (size(gridd1,/n_elements) eq 1) then begin
print,'myinterpol, size(gridd1) eq 1, cannot interpolate, returning'
return,0
endif
;
if ~keyword_set(parts) then begin; case without parts
;
if keyword_set(auto) then begin; switch interpolation method if very few points.
case 1 of
(size(gridd1,/n_elements) eq 2) : field2=interpol(fieldd1,gridd1,gridd2)
((size(gridd1,/n_elements) eq 3) and keyword_set(quadratic)) : field2=interpol(fieldd1,gridd1,gridd2,/quadratic)
(size(gridd1,/n_elements) eq 3) : field2=interpol(fieldd1,gridd1,gridd2); checked in second if (mysize(gridd1) eq 3)
keyword_set(lsquadratic) : field2=interpol(fieldd1,gridd1,gridd2,/lsquadratic)
keyword_set(quadratic) : field2=interpol(fieldd1,gridd1,gridd2,/quadratic)
keyword_set(spline) : field2=interpol(fieldd1,gridd1,gridd2,/spline)
else : field2=interpol(fieldd1,gridd1,gridd2)
endcase
endif else begin
case 1 of
keyword_set(lsquadratic) : field2=interpol(fieldd1,gridd1,gridd2,/lsquadratic)
keyword_set(quadratic) : field2=interpol(fieldd1,gridd1,gridd2,/quadratic)
keyword_set(spline) : field2=interpol(fieldd1,gridd1,gridd2,/spline)
else : field2=interpol(fieldd1,gridd1,gridd2)
endcase
endelse
;
endif else begin; case with parts
;
partts=partts(sort(partts)); parts in increasing order
npartts=size(partts,/n_elements)
field2=make_array(size(gridd2,/n_elements))
if keyword_set(missing) then miss=missing else miss=myNaN()
field2(*)=miss
for pip=0,npartts-2 do begin
index1=where((gridd1 ge partts(pip)) and (gridd1 le partts(pip+1)))
index2=where((gridd2 ge partts(pip)) and (gridd2 le partts(pip+1)))
if ((index1(0) ne -1) and (index2(0) ne -1)) then begin
case 1 of; note that /auto method is used with keyword parts
(size(gridd1(index1),/n_elements) eq 1) : field2(index2)=interpol(fieldd1,gridd1,gridd2(index2)); if 1 pt, then int from all input (in linear)
(size(gridd1(index1),/n_elements) eq 2) : field2(index2)=interpol(fieldd1(index1),gridd1(index1),gridd2(index2)); if 2 pts, then linear
((size(gridd1(index1),/n_elements) eq 3) and keyword_set(quadratic)) : $; if 3 pts, first look if quadratic
field2(index2)=interpol(fieldd1(index1),gridd1(index1),gridd2(index2),/quadratic) 
(size(gridd1(index1),/n_elements) eq 3) : field2(index2)=interpol(fieldd1(index1),gridd1(index1),gridd2(index2)); if 3 pts no quad, then linear
keyword_set(lsquadratic) : field2(index2)=interpol(fieldd1(index1),gridd1(index1),gridd2(index2),/lsquadratic); if >3pts, choose
keyword_set(quadratic) : field2(index2)=interpol(fieldd1(index1),gridd1(index1),gridd2(index2),/quadratic)
keyword_set(spline) : field2(index2)=interpol(fieldd1(index1),gridd1(index1),gridd2(index2),/spline)
else : field2(index2)=interpol(fieldd1(index1),gridd1(index1),gridd2(index2))
endcase
endif
endfor
;
endelse
;
return,field2
;
end