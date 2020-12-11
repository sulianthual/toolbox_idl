function myfnz

model=string('/windows/D/data/')
fil6=model+'5d-mean/fnz.664111x1'
get_lun,buffer
openr,buffer,fil6
fnz=fltarr(66,41,11)
readu,buffer,start,fnz,start
free_lun,buffer
print,'myfnz=>fnz(66,41,11),badvalue=9999.0,PREMIER N=BAROTROPE !!'
return,fnz
end