function mygridz,positive=positive,info=info
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for reading gridz from SODA_1.4.2 with IDL :
;  Sulian Thual, IRD-IMARPE 2008
;
; NO INPUTS
;
; KEYWORD : if set postive, gridz is returned as positive.
;
; NOTES : - Uses buffer 6 for reading.
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
model=string('/windows/D/data/')
fil6=model+'5d-mean/grid/gdept.41'
get_lun,buffer
openr,buffer,fil6
gridz=fltarr(41)
readu,buffer,start,gridz,start
free_lun,buffer
if keyword_set(positive) then begin
endif else begin
gridz=-gridz
endelse
if keyword_set(info) then print,'mygridz : readed -gridz,size(41) from SODA_1.4.2'
return,gridz
end