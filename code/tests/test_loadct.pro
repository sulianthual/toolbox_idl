; Programme pour tester les tables de couleurs et les reediter

mygraph
;itab=1; numero de la tablette de couleur
loadct,itab
print,!d.table_size;number of available colors
nx=256 & ny=10
startlevel=0
pass=findgen(nx)#(fltarr(ny)+1)
mycontour,pass,/nolines,levels=findgen(nx)-startlevel
;remarque : les levels (couleurs) sont toujours ajustees du min au max des levels







end