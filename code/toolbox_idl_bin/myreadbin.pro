function myreadbin,filename,dims,x=x,info=info

;compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Function for reading from a binary file 
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUTS
;
; -filename : the path to the binary file
; -dims : the dimensions of the readed data
; - x: if set, reads x times with separator (start) between each point of last dimension
; 
; 
; 
; 
; NOTES : - data type corresponds to readed (use of make_array that does not specifiy data type)
;        - you may read with a loop on last dimension (if their is start points in data).
;        - files with a x separator are when writed with several calls to writeu
;        - the x trick for reading is that a(*,*,i)=a(i1:i2) ie the subscript considering one point of last 
;          dimensions is in one part.
;
; EXAMPLE :
;       a=myreadbin('test',[2,3])=> returns a(2,3)
;       a=myreadbin('test2',[2,3],x=5)=> returns a(2,3,5) from a x separated file
;       
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
get_lun,buffer
openr,buffer,filename
;
case 1 of
keyword_set(x) : begin; case x increment in reading
nt=x
tab=make_array(dims)
data=make_array([dims,nt])
for k=0.,float(nt)-1. do begin
readu,buffer,start,tab,start
i1=product(dims)*k
i2=product(dims)*(k+1)-1
data(i1:i2)=tab; conversion with array index form, on last dimension(see trick)
if keyword_set(info) then print,'myreadbin,',k,' /',nt-1
endfor
end
else : begin; case, no x increment in reading
data=make_array(dims)
readu,buffer,start,data,start
end
endcase
;
close,buffer
free_lun,buffer
;
return,data
;
end