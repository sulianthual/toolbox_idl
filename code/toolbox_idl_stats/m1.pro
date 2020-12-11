function m1,a
; moyenne=moment d'ordre 1
n=n_elements(a)
s=0
for i=0,n-1 do s=s+a(i)
s=s/n
return,s
end
