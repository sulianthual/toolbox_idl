function myrhoseawater,T,S,p 

; retourne rho en fonction de S,T,p 
; remarque p=0 at one standard atmosphere (je crois que c est pour la temperature potentielle,
; dans ce cas les donnees utlisees sont en general avec p=0

;S=0. & T=5. & p=0.; test=999.96675 (OK)
;S=35. & T=5. & p=0.; test=1027.67547 (OK)
;S=35. & T=25. & p=1000.; test=1062.53817 (OK)
;
; Programme de calcul de la densite de l eau de mer rho(S,T,p)
; S=practical, T=deg C, p= bars, rho=kg.m-3
; 
S=double(S) & T=double(T) & p=double(p) ;& rho=double(0.)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; fresh water density (S=0)
rhow=999.842594+6.793952*10.^(-2)*T-9.095290*10.^(-3)*T^2+$
1.001685*10.^(-4)*T^3-1.120083*10.^(-6)*T^4+6.536332*10.^(-9)*T^5; verif OK
;
; standard atmosphere density (p=0)
rhosa=rhow+$
S*( 0.824493-4.0899*10.^(-3)*T+7.6438*10.^(-5)*T^2-8.2467*10.^(-7)*T^3+5.3875*10.^(-9)*T^4 )+$
S^1.5*( -5.72466*10.^(-3)+1.0227*10.^(-4)*T-1.6546*10.^(-6)*T^2 )+$
4.8314*10.^(-4)*S^2; verif OK
;
; Pure water secant modulus (S=0)
Kw=19652.21+148.4206*T-2.327105*T^2+1.360477*10.^(-2)*T^3-5.155288*10.^(-5)*T^4; verif OK
;
; Standard atmosphere secant modulus (p=0)
Ksa=Kw+$
S*( 54.6746-0.603459*T+1.09987*10.^(-2)*T^2-6.1670*10.^(-5)*T^3 )+$
S^1.5*( 7.944*10.^(-2)+1.6483*10.^(-2)*T-5.3009*10.^(-4)*T^2 ); verif OK
;
; Secant modulus
K=Ksa+$
p*( 3.239908+1.43713*10.^(-3)*T+1.16092*10.^(-4)*T^2-5.77905*10.^(-7)*T^3 )+$
p*S*( 2.2838*10.^(-3)-1.0981*10.^(-5)*T-1.6078*10.^(-6)*T^2 )+$
1.91075*10.^(-4)*p*S^1.5+$
p^2*( 8.50935*10.^(-5)-6.12293*10.^(-6)*T+5.2787*10.^(-8)*T^2 )+$
p^2*S*( -9.9348*10.^(-7)+2.0816*10.^(-8)*T+9.1697*10.^(-10)*T^2 ); verif OK
; (manquait derniere ligne)
;
; final density
rho=rhosa/(1.-p/K)
;
return,rho
























end