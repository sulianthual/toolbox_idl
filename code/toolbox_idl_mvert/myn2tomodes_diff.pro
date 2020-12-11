function myn2tomodes_diff,X,Y
common share_n2tomodes,N2_glo,zgrid_glo,condlim1_glo,cc_glo
N2_atX=myinterpol(N2_glo,zgrid_glo,X)
result=[N2_atX*Y[1],-Y[0]/cc_glo/cc_glo]
return,result
end