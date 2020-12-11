FUNCTION mymasscenter,field,xgrid,ygrid
; 
; pour un champ 2D field, retourne (x,y) la position de son centre de masse sur xgrid,ygrid
; Sulian Thual 2011, adapte de site COyote 
;
; ATTENTION: xgrid et ygrid doivent etre regulieres !
;
; utilite:
; on veut trouver le point le plus proche de la value iso dans field
; si field0=abs(field0-iso) ou (field-iso)^2 en entree de mymasscenter, ou a une fcontion qui approche cela
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; 
   s = Size(field, /Dimensions)
   totalMass = Total(field)
   xcm = Total( Total(field, 2) * Indgen(s[0]) ) / totalMass
   ycm = Total( Total(field, 1) * Indgen(s[1]) ) / totalMass  

; xcm et ycm sont le centre pour xgrid=findgen(nx) & ygrid=findgen(ny)
; donnont maintenant la position sur les grilles xgrid,ygrid donnees
dxstep=mygridstep(xgrid) & dystep=mygridstep(ygrid)
xgm=xgrid(0)+dxstep*xcm & ygm=ygrid(0)+dystep*ycm

                                                                      
   RETURN, [xgm, ygm]
   END
