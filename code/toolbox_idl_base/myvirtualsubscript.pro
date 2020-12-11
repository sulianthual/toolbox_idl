function myvirtualsubscript,grid1,grid2
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Gives subscripts of grid1 reported to grid2 (by interpolation of index) 
; Sulian THUAL
;
; NOTE : grid2 is of subscript [1,...,n2] (ie his index). We can obtain grid1 subscript relative to grid2.
;        this function is useful while using interpolate, or bilinear idl functions for interpolations.
; 
; EXAMPLE : suppose grid2=[-20,-10,10,20,100]. Subscript of grid2 is : [0,1,2,3,4] (it is his index)
;           now suppose grid1=[-15,10,15,100]. Subscript of grid1 is : [0,1,2,3] (it is his index)
;           Now we want subscript of grid1 interpolated on subscript of grid 2 : We will obtain :
;           [0.5,2,2.5], 0.5 because grid1(0) is at middle of grid2(0) and grid2(1), then 2 because
;           grid1(1) is equal to grid2(2), and 2.5 because grid1(2) is at middle of grid2(2) and grid2(3)
;
; TIP : to make bilinear interpolation of A1(x1,y1) to get A2(x2,y2) just do (if regular grids):
;     vx=myvirtualsubscript(x2,x1)
;     vy= myvirtualsubscript(y2,y1)
;     A2=bilinear(A1,vx,vy)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
n2=size(grid2,/n_elements)
index2=findgen(n2)
;
index1=interpol(index2,grid2,grid1)
;
return,index1
;
end