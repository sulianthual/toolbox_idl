Pro myncdfmakevar,filename,varname,dimensions,field,new=new,empty=empty,append=append
compile_opt hidden
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Procedure for writing datas into a ncdf file with IDL
;
;  Sulian Thual, IRD-IMARPE 2008
;
; INPUTS :
;
; -filename : filename of the netcdf file
; -varname : name of the variable to be created & writed,
;            or overwrited.
; -dimensions : array of strings containing the name of the 
;               dimensions of the variable.MUST AGREE with
;               field(same number of dims). 
;               If dimensions already exist, must be 
;               of same size as precedent.But if dimension
;               is only used by the variable varname, then
;               overwrite it.
; -field : field to be writed. MUST AGREE with dimensions
;
; new(optionnal) : if set, creates or overwrites for a new netcdf file 
; empty(optionnal) : If set, only creates header for variable, without writing data.
;          
; AJOUT 2011 : append
;   Si append est defini, avec new, cree une dimension infinie (la derniere de la variable)
;   Si append est defini, sans new (ie second appel), ajoute sur dimension infinie   
; ATTENTION SI UNE DIMENSION INFINITE EXISTE DEJA, ON NE PEUT EN CREER UN AUTRE !!! (non gere par le script)
; UNE SEULE VARIABLE PEUT AVOIR LA DIMENSION INFINIE. SINON LA DIMENSION INFINIE EST ELARGIE A CHAQUE NOUVELLE ECRITURE
; (donc pour 3 variables le lenght sera 3 fois trop long). 
;
; NOTES : 
; - IDL CANNOT DELETE OR CHANGE SIZE OF EXISTING VARIABLES AND DIMENSIONS
; - YOU CANNOT WRITE OR OVERWRITE UNLIMITED DIMENSION WITH THIS SCRIPT(but should be implemented) 
; - Normally the netcdf is writen according to the format of the input data
; (can be normally :byte,short,long,float,double,default is float)
; -entry data should already be reformed with no degenerated dimensions, unless wanted(see function reform).
;
; EXAMPLE :
; myncdfmakevar,'testncdf.nc','temp',['X','Y'],findgen(2,3),/new
; myncdfmakevar,'testncdf.nc','sal',['X','Y','Z'],findgen(2,3,4)
; myncdfmakevar,'testncdf.nc','sal',['X','Y','Z'],fltarr(2,3,4)
;
; En append :
;myncdfmakevar,'test.nc','var',['X','Y','T'],findgen(2,3,9999),/new,/append,/empty ; cree empty infinite dimension
;myncdfmakevar,'test.nc','var',['X','Y','T'],findgen(2,3,5),/append; ajout a la suite sur derniere dimension)
;myncdfmakevar,'test.nc','var',['X','Y','T'],findgen(2,3),/append; ajoute un step a la suite: REMARQUE DIM INF !
;myncdfmakevar,'test.nc','var2',['X','Z','T'],findgen(2,10,5),/append; INTERDIT ! UNE SEULE VARIABLE AVEC T=infinite PERMIS
;
; RQ : n'accepte que des vecteur, donc si on veut mettre un scalaire A, le transformer en vecteur avec A=fltarr(1)+A
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
myvardims=size(field,/n_dimensions)
myvarsize=size(field,/dimensions)
sdims=size(dimensions,/n_elements)
;
; check that the number of dimensions for field matchs with dimensions string 
; Dans ce cas une dimension ne peut etre 1, sauf en append
if ~keyword_set(append) then begin
if (myvardims ne sdims) and (myvarsize(0) ne 0)  then begin
print,'myncdfmakevar : dims(field) ne dimensions,returning' 
return
endif
endif
;
;
; Two distinct scripts : new for entirely new netcdf, elsewhere edit existing netcdf
if keyword_set(new) then begin
;
;
; create new netcdf file or entirely overwrite existing netcdf file
id = NCDF_CREATE(filename, /CLOBBER)
;
; create new dimensions
dimids=intarr(size(dimensions,/n_elements))
myvarsize=size(field,/dimensions)
; Creer derniere dimension en infinite
if keyword_set(append) then begin
;
if ( size(dimensions,/n_elements) gt 1 ) then begin
for mydim=0,size(dimensions,/n_elements)-2 do begin
mydimname=dimensions(mydim)
mydimsize=myvarsize(mydim)
dimids(mydim)=ncdf_dimdef(id,mydimname,mydimsize)
endfor
endif
mydim=size(dimensions,/n_elements)-1; dimension infinie
mydimname=dimensions(mydim)
;mydimsize=myvarsize(mydim)
dimids(mydim)=ncdf_dimdef(id,mydimname,/UNLIMITED)
;
endif else begin
;
; Ne pas creer derniere dimension en infinite
for mydim=0,size(dimensions,/n_elements)-1 do begin
mydimname=dimensions(mydim)
mydimsize=myvarsize(mydim)
dimids(mydim)=ncdf_dimdef(id,mydimname,mydimsize)
endfor
;
endelse
;
; create variable with corresponding field type
myvartype=size(field,/type)
case myvartype of
1 : varid=ncdf_vardef(id,varname,dimids,/byte)
2 : varid=ncdf_vardef(id,varname,dimids,/short);2-bytes integer 
3 : varid=ncdf_vardef(id,varname,dimids,/long)
4 : varid=ncdf_vardef(id,varname,dimids,/float)
5 : varid=ncdf_vardef(id,varname,dimids,/double)
else : varid=ncdf_vardef(id,varname,dimids,/float)
endcase
;
; quit define mode to write variable
ncdf_control,id,/endef
; write variable (si new est mis, meme script en infinite dim ou non)
if ~keyword_set(empty) then begin
myvarid=ncdf_varid(id,varname)
ncdf_varput,id,myvarid,field
endif
;
ncdf_close,id
;
;
endif else begin
; Cas /new non defini
;
;
; open existing netcdf file
id=ncdf_open(filename,/WRITE)
ncdf_control,id,/noverbose
; pass in define mode
ncdf_control,id,/redef
; get informations on existing netcdf file
info=ncdf_inquire(id)
; check if must create new variable or check if variable matchs with existing variable
varid=ncdf_varid(id,varname)
createnewvar=0
if (varid eq -1) then begin
createnewvar=1; switch for creating new variable
endif else begin
; if var exists, check that dimensions agree(que dimension=same name and order, sans regarder le lenght)
; Si append ne cree pas la derniere dimension
infovar=ncdf_varinq(id,varid)
for vdim=0,infovar.ndims-1 do begin
vdimid=infovar.dim(vdim)
ncdf_diminq,id,vdimid,vdimname,vdimsize
; check that names matchs(in the right order)
if (vdimname ne dimensions(vdim)) then begin
print,'myncdfmakevar : dim "',dimensions(vdim),'" unmatchs name of existing dim "',vdimname, $
'", wich is already at use for var "',varname,'", returning'
ncdf_close,id
return 
endif
endfor
; CHECK THAT FIELD DIM IS OF SAME TYPE AS EXISTING VAR
; PEU UTILE CAR VARPUT met field au bon format avant d'ecrire
endelse
;
; check if must create new dimensions,
; or ckeck if dimensions match size with existing dimensions.
; ne le fait pas en append !
if ~keyword_set(append) then begin
createnewdim=intarr(size(dimensions,/n_elements))
for mydim=0,size(dimensions,/n_elements)-1 do begin
mydimname=dimensions(mydim)
myvarsize=size(field,/dimensions)
mydimsize=myvarsize(mydim)
dimid=ncdf_dimid(id,mydimname)
if (dimid eq -1) then begin
createnewdim(mydim)=1; switch for creating new dimension. 
endif else begin
; check if existing dimension matchs new size 
ncdf_diminq,id,dimid,dimname,dimsize
if ((dimsize ne mydimsize) and (mydimsize ne 0))then begin
; if size unmatchs, error message (sauf si c est la derniere dimension infinite !!!)
; Ici filtre le cas de la derniere dimension infinite
if (  ((keyword_set(append)) and (mydim eq size(dimensions,/n_elements)-1))  eq 0  ) then begin 
print,'myncdfmakevar : dim "',mydimname,'" already exists with size "', $ 
dimsize,'" ne new dim size=',mydimsize,' returning'
ncdf_close,id
return
endif
endif
endelse
endfor
; create dimensions that must be created (from previous check) :
for mydim=0,size(dimensions,/n_elements)-1 do begin
; if dimension must be created(cf switch), create it
if (createnewdim(mydim) eq 1) then begin
mydimname=dimensions(mydim)
myvarsize=size(field,/dimensions)
mydimsize=myvarsize(mydim)
; Si c est la derniere dimension en infinite, cas special
if ((keyword_set(append)) and (mydim eq size(dimensions,/n_elements)-1)) then begin
dimid=ncdf_dimdef(id,mydimname,/UNLIMITED)
endif else begin
; cas sans dimension infinite
dimid=ncdf_dimdef(id,mydimname,mydimsize)
endelse
endif
endfor
endif; fin cas non append
;
; create variable if it must be created (from previous check) :
if (createnewvar eq 1) then begin
; get all dim ids for my variable
dimids=intarr(size(dimensions,/n_elements))
for mydim=0,size(dimensions,/n_elements)-1 do begin
dimids(mydim)=ncdf_dimid(id,dimensions(mydim))
endfor
; create variable with corresponding field type
myvartype=size(field,/type)
case myvartype of
1 : varid=ncdf_vardef(id,varname,dimids,/byte)
2 : varid=ncdf_vardef(id,varname,dimids,/short);2-bytes integer 
3 : varid=ncdf_vardef(id,varname,dimids,/long)
4 : varid=ncdf_vardef(id,varname,dimids,/float)
5 : varid=ncdf_vardef(id,varname,dimids,/double)
else : varid=ncdf_vardef(id,varname,dimids,/float)
endcase
endif
;
;
; quit define mode to write variable
ncdf_control,id,/endef
;
; write or overwrite variable
if ~keyword_set(empty) then begin
;
; CAS EN APPEND SUR UNE DIMENSION INFINITE
if keyword_set(append) then begin
myvarid=ncdf_varid(id,varname)
myoffset=intarr(size(dimensions,/n_elements)); starting position to write
; modify start of last dimension to the last one
mydim=size(dimensions,/n_elements)-1
mydimname=dimensions(mydim)
dimid=ncdf_dimid(id,mydimname)
ncdf_diminq,id,dimid,dimname,mydimsize
myoffset(mydim)=mydimsize
ncdf_varput,id,myvarid,field,offset=myoffset
endif else begin
; CAS SANS APPEND SUR UNE DIMENSION INFINITE (overwrite si existant)
myvarid=ncdf_varid(id,varname)
ncdf_varput,id,myvarid,field
endelse
endif
;
ncdf_close,id
;
endelse; end of cases (new ncdf or overwrite existing one)
;
end



