function mymodulo,field,minfield,maxfield
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Function pour mettre un champ entre minfield-maxfield
; 
; ATTENTION NE MARCHE QUE DANS LE CAS CONTINU, NON DISCRET !!!!!
; dans le cas discret MODULO=maxfield-minfield+1 (exemple de 1 a 12, modulo=12 et non 11), utiliser alors myintmodulo
; 

; minfield: minimum desire
; maxfield; maximum desire
;
; CALLING SEQUENCE :
;
; fieldenmodulo=mymodulo(field,0,2.*mypi()) par exemple pour mettre le champ dans 0<fieldenmodulo<2*pi
; dans ce programme on applique un modulo jusqu'a tomber dans le range desire
; le modulo est dans ce cas maxfield-minfield


;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
fieldmodulo=field
modulo=maxfield-minfield
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




