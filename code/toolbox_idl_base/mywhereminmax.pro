function mywhereminmax,field
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; function for finding minimum and maximum over field, and give their positions
;  Sulian Thual, IRD-IMARPE 2008
;
; returns infos=[max(field),coords of max(field),min(field),coords of min(field)]
;              coords of max(field) contains the positions of max on each dimensions of field.
;              coords has same size(n_elements) as field as dimensions.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
info1=max(field)
;
info2=where(field eq max(field))
if (size(info2,/n_elements) gt 1) then begin
print,'mywhereminmax : multiples elements at max, first one keeped'
info2=info2(0)
info2=array_indices(field,info2)
endif
;
info3=min(field)
;
info4=where( field eq min(field))
if (size(info4,/n_elements) gt 1) then begin
print,'mywhereminmax : multiples elements at min, first one keeped'
info4=info4(0)
info4=array_indices(field,info4)
endif
;
infos=[info1,info2,info3,info4]
;
return,infos
;
end