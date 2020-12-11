function m2,a
; variance=moment d'ordre 2
n=n_elements(a)
s=0
m=mean(a)
for i=0,n-1 do s=s+(a(i)-m)^2
s=s/n
return,s
end
