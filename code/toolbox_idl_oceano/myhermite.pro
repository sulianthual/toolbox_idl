function myhermite,m,y

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; fonction pour sortir le profil d'une fonction d'hermite
;  Sulian Thual, IRD-IMARPE 2010
;
; INPUT PARAMETERS :
;
; ygrid : la grille y 
; m : l'ordre de la fonction d'Hermite
;
; Pour l'instant on fait seulement m=0,1,2,3,4,5
; Pour rajouter des ordres superieurs revoir la formule
;
; NOTE: CETTE BASE EST NORMALISEE (AVEC COEFF): < psi_i * psi_j > =delta_ij avec < > =int (-inf,+inf) dy
; print,int_tabulated(ygrid,myhermite(0,ygrid)*myhermite(0,ygrid)) => =1 en resultat
;
; NOTE : par contre, si les fonctions dependent du rayon de rossby Ln
;  il faut definir un nouveau produit scalaire normalise: < > = (1/Ln) int(-inf,+inf) 
;  alors < psi_i(yn) * psi_j(yn) > = delta_ij avec yn=y/Ln
; 
; TEST :
; myplot,myhermite(2,findgen(101)*0.1-5.)
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Note :
; psim(y)=exp(-y^2/2)*Hm(y)  /  sqrt (2^m * fact(m) * sqrt(pi) )
;
; Hm (polynome d'Hermite)
; Hm(y)=(-1)^m exp(y^2) dy^m (exp(-y^2))
;
m=fix(m) ; doit etre entier
pi=mypi()
;
; Expression du polynome d'Hermite
case 1 of 
m eq 0 : Hm=1.
m eq 1 : Hm=2.*y
m eq 2 : Hm=4.*(y^2)-2.
m eq 3 : Hm=8.*(y^2)-12.*y
m eq 4 : Hm=16.*(y^4)-48.*(y^2)+12.
m eq 5 : Hm=32.*(y^5)-160.*(y^3)+120.*y
m eq 6 : Hm=64.*(y^6)-480.*(y^4)+720.*(y^2)-120.
else : Hm=y*0.
endcase
; Expression de la fonction d'Hermite
coeff=sqrt( (2.^m)*factorial(m)*sqrt(pi) ); coefficient de normalisation
hermite=exp(-(y^2)/2)*Hm/coeff

return,hermite

end