Pro mywritebin,filename,field,x=x,append=append
;compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for writing field in a binary file
;  Sulian Thual, IRD-IMARPE 2008
;
; filename : file to be writed
; field : field to be writed
; x : if set, writes last dimension with an x increment (see myreadbin)
; append : if set, writes at the following of existing file
;
; EXAMPLE :
;         mywrite,'test',findgen(2,3)=> writes findgen(2,3) in file 'test', you read a=myreadbin('test',[2,3])
;
;         mywrite,'test2',findgen(2,3,5),/x=> writes findgen(2,3,5) in file 'test2' with  increment,
;         wich means you must read a=myreadbin('test2',[2,3],x=5)
;
;         mywrite,'test3',findgen(2,3) then mywrite,'test3',findgen(2,3)+1,/append 
;         writes two times, to read a=myreadbin('test3',[2,3],x=2) 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;
get_lun,buffer
if keyword_set(append) then begin
openw,buffer,filename,/f77_unformatted,/append 
endif else begin
openw,buffer,filename,/f77_unformatted
endelse
;
case 1 of 
keyword_set(x) : begin; case x increment in writing
ndims=size(field,/n_dimensions)
dims=size(field,/dimensions)
dims0=dims(0:ndims-2)
dimst=dims(ndims-1)
;
for k=0,dimst-1 do begin
i1=product(dims0)*k
i2=product(dims0)*(k+1)-1
writeu,buffer,field(i1:i2)
endfor
end
;
else : begin; case no x increment in writing
writeu,buffer,field
end
endcase
;
close,buffer
free_lun,buffer
;
end

