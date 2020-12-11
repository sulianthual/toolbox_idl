function myintmodulo,field,minfield,maxfield
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Function pour mettre un champ entre minfield-maxfield dans le cas discret (entiers)
; 
; ATTENTION DANS LE CAS CONTINU UTILISER mymodulo
; ici dans le cas discret MODULO=maxfield-minfield+1 (et non maxfield-minfield)


; minfield: minimum desire
; maxfield; maximum desire
;
; CALLING SEQUENCE :
; 
; tester avec minfield=1,maxfield=12 (donc modulo=11) par exemple)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
fieldmodulo=field
modulo=maxfield-minfield+1; CHANGEMENT ICI !!!!!!!!
while ((where (fieldmodulo lt minfield))(0) ne -1) do begin
fieldmodulo(where (fieldmodulo lt minfield))=fieldmodulo(where (fieldmodulo lt minfield))+modulo
endwhile
while ((where (fieldmodulo gt maxfield))(0) ne -1) do begin
fieldmodulo(where (fieldmodulo gt maxfield))=fieldmodulo(where (fieldmodulo gt maxfield))-modulo
endwhile
;
return,fieldmodulo
;
end




