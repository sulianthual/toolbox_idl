function rmsdif,a,b
n=n_elements(a)
;m=n_elements(b)
s=0
for i=0,n-1 do s=s+(a(i)-(b(3*i)+b(3*i+1)+b(3*i+2))/3.)^2
s=sqrt(s/n)
return,s
end
