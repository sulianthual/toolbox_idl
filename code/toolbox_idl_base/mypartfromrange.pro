Pro mypartfromrange,field,range,newfield,indices
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for restricting field to certain range. 
;  Sulian Thual, IRD-IMARPE 2008
;
; -field : input field
; -range=[min ,max] : the range with minimum and maximum wanted for new field
; -newfield : the new field : only points of precedent that are in range
; -indices : indices of new field relative to initial (newfield=field(indices) for example). 
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
data=field
range=range(sort(range)); sort range in ascending order(precaution)
indices=where((field ge range(0)) and (field le range(1)))
newfield=data(indices)
;
end