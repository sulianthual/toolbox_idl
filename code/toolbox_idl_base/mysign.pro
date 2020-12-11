function mysign,data
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; returns sign of data at each point (1,0 or -1). All is in float
; Sulian THUAL IMARPE-IRD 2008
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
datasign=data*0.
for id=0,size(data,/n_elements)-1 do begin
if (data(id) gt 0.) then datasign(id)=1.
if (data(id) lt 0.) then datasign(id)=-1.
if (data(id) eq 0.) then datasign(id)=0.
endfor
;
return,datasign
;
end