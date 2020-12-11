function m3,a
; skewness=moment d'ordre 3
n=n_elements(a)
m=mean(a)
; calcul m2 ;
;s2=0
;for i=0,n-1 do s2=s2+(a(i)-m)^2
;s2=s2/n
;
; calcul m3
s=0
for i=0,n-1 do s=s+(a(i)-m)^3
;s=s/(s2^(3/2))
s=s/n
return,s
end
