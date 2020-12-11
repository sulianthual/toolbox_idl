function mycutnumber,number,cutoff
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for cuting a number keeping the first figures (number of figures kept=cutoff)
;  Sulian Thual, IRD-IMARPE 2008
;
; number : the number to bu cut out (CAN BE INTEGER,FLOAT OR DOUBLE ONLY)
; cutoff : the number of first figures to keep : if cutoff=1, you only keep first number
;
; NOTE : the cuted number is returned
; NOTE : this function should already exist in IDL, but I can't find it. 
; NOTE : the number is translated to double, then to initial type for operations
; NOTE : can also take negative numbers
;
; EXAMPLE : b=mycutnumber(10.634,3) => b=10.6
;           b=mycutnumber(10.367,4) => b=10.37
;
; NOTE : CAN TAKE ONLY ONE ELEMENT IN ENTRY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
numtype=size(number,/type)
if (~(numtype eq 2) and ~(numtype eq 4) and ~(numtype eq 5)) then begin
print,'mycutnumber : number must be integer,float or double, returning'
return,0
endif
if (size(number,/n_dimensions) ne 0) then begin
print,'mycutnumber : dims(number) ne 0,returning'
return,0
endif
;
; convert to double for calculation
num=double(number)
cutoff=fix(cutoff)
; if number is NEGATIVE, convert to POSITIVE (for alog10) :
if (num lt 0) then begin
num=-num
isnegative=1
endif else begin
isnegative=0
endelse
; if number is 0, then DON'T DO ANY PROCESS :
if (num ne 0) then begin
; find power 10
numlog10=alog10(num)
numlog10=fix(numlog10)
; multiply number to keep only first figures > 1
num=num*double(10)^(-numlog10+(cutoff-1))
; save original number and cutoff with a fix
num0=num
num=fix(num)
; take most closer number (14.6=>15 and 14.2=>14 for example)
if (num0-num gt double(0.5)) then begin
num=num+double(1)
endif else begin
num=num
endelse
; remultiply
num=num*double(10)^(numlog10-(cutoff-1))
; if number was NEGATIVE, reconvert from POSITIVE to negative
if (isnegative eq 1) then begin
num=-num
endif
endif; end of condition, if (number ne 0)
; reconvert to intial type
if (numtype eq 2) then num=fix(num)
if (numtype eq 4) then num=float(num)
if (numtype eq 5) then num=double(num)
;
;
return,num
;
end