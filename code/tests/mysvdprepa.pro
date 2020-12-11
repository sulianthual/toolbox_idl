; process for preparing entries for SVD
;
model=string('/windows/D/data/SODA_1.4.2/')
;
; entry-output file
file_read=model+'5d-mean/t.664641x3168'
file_writed='test'
;
; parts to be extracted
part1=58
part2=indgen(22)+12
part3=indgen(23)
nt=100;2449
oneyear=12*6; one year in number of file time steps 
;          (to make climatology with appropriate cycle)
;
; reading of file with part only
field=fltarr(66,46,41)
fieldpart=mypartfromfile3d(file_read,field,part1,part2,part3,time=nt)
;
; process on data, remove climatology and trend.(file must be 2d dims)
fieldpart=myaclim2d(fieldpart,oneyear)
fieldpart=myatrend2d(fieldpart)
;
; write processed file(file must be 2d dims)
mywritefile2d,file_writed,fieldpart,time=nt



end