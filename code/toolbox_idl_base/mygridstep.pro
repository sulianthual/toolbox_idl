function mygridstep,grid,test=test
;
; Gives step of a grid, supposed to be regular. 
; When test is put, returns NaN if not regular 
; (but with errors see below).
; Sulian THUAL
;
; No keyword : returns the average of all grid steps
; Option test : When put, check first step with other ones
; and returns NaN if difference exists. This can check quickly
; if a grid is irregular, but sometims there will be mistakes
; due to roundoff error. This happens when doing x=findgen(21) 
; then x=x*0.21 for example. 
; So a maybe better way to look irregularity is to do 
; print,x(0:nx-1)-x(1:nx-2)
; 
;
;
; Example :
; x=findgen(21)*0.2
; step=mygridstep(x) =>0.2
;
; x=[0,1,2.1,3.3,4.5]
;step=mygridstep(x) =>NaN
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
grid2=grid
grid2=reform(grid2)
nx=size(grid2,/n_elements)
if keyword_set(test) then begin
dxs=grid2(1:nx-1)-grid2(0:nx-2)
dx=dxs(0)
if (min(dxs eq dx) ne 1) then begin
return,myNaN()
endif else begin
return,dx
endelse
endif else begin
dxs=grid2(1:nx-1)-grid2(0:nx-2)
dx=mean(dxs)
return,dx
endelse



end