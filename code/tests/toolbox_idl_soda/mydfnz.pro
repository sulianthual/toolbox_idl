function mydfnz
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for reading fnz from SODA_1.4.2 with IDL :
;  Sulian Thual, IRD-IMARPE 2008
;
; NOTES : - Uses buffer 6 for reading.
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
model=string('/windows/D/data/')
fil6=model+'5d-mean/dfnz.664111x1'
get_lun,buffer
openr,buffer,fil6
dfnz=fltarr(66,41,11)
readu,buffer,start,dfnz,start
free_lun,buffer
print,'mydfnz=>dfnz(66,41,11),1=barotrope,(meters)-1,badvalue=9999.0,FIRST N=BAROTROPE !!'
return,dfnz
end