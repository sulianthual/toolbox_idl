function m4,a
n=n_elements(a)
s=0
m=mean(a)
; calcul m2 ;
s2=0
for i=0,n-1 do s2=s2+(a(i)-m)^2
s2=s2/n
; calcul m4
for i=0,n-1 do s=s+(a(i)-m)^4
s=s/(s2^2)
s=s/n
return,s
end
