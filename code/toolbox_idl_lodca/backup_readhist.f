c    PROGRAM readhist
C    ifort readhist.f pour compiler a.out
C   ./a.out pour executer

C lit le fichier out-back1.dat et out-back2.dat et compare les deux fichiers history
C
C
C REMARQUE: ATTENTION les champs du history sont sur NXP,NYP,NMODE,NS,NX,NY....(peut aussi etre notation nxpl,nypl...)
C           qui sont des grilles restreintes par rapport aux grilles de lodca utilisees: NXLm, NYLm,NMODEm,NSLm,NXm,NYm...
C           dans nrdhist.f de lodca on lit et ecrit seulement field(1:NXP,1:NYP) selon les cas
C           On a les changements suivants:
C           grille restreinte du history: NXP = 79, NYP=116, NMODE=3, NS=2, NX=34,NY=30 
C           grille reelement utilisees: NXPm=85, NYPm=117, NMODEm=3,NSm=4,NXm=34,NYm=30
C
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
      IMPLICIT REAL*4(A-H,O-Z)
      CHARACTER*100 FN61,FN62
      INTEGER ii,iend

C champs de run1
      INTEGER NMODE,NT,NXP,NYP,NX,NY
      INTEGER TSTPRT,CHKSUM,NPRINT,MASKW,MWNDGF
      INTEGER  NSEG,NTAPE,NREWND,NTAM
      REAL TPLMIN,TD,HEQUIV,TZERO,TENDD,DTD
      REAL XWD,XED,YSD,YND,TDECAY
      REAL WMXW,WMXE,WMYS,WMYN,PERIOD
      REAL*4 YNORTH,YSOUTH,XWEST
      REAL AKBM(79,3)
      REAL UBM(79,116,3), HBM(79,116,3)
      REAL ABC(2), ROSS(2),TR(2)
      REAL UBNDYM(116,2,3), HBNDYM(116,2,3)
      REAL H1M(30,34,3), U1M(30,34,3), V1M(30,34,3)
      REAL Q0O(30,34),UO(30,34),VO(30,34),DO(30,34),TO(30,34)
      REAL HTAU(30,34,2)
      REAL SL(30,34),H1(30,34)
C champs de run2
      INTEGER NMODE2,NT2,NXP2,NYP2,NX2,NY2
      INTEGER TSTPRT2,CHKSUM2,NPRINT2,MASKW2,MWNDGF2
      INTEGER  NSEG2,NTAPE2,NREWND2,NTAM2
      REAL TPLMIN2,TD2,HEQUIV2,TZERO2,TENDD2,DTD2
      REAL XWD2,XED2,YSD2,YND2,TDECAY2
      REAL WMXW2,WMXE2,WMYS2,WMYN2,PERIOD2
      REAL*4 YNORTH2,YSOUTH2,XWEST2
      REAL AKBM2(79,3)
      REAL UBM2(79,116,3), HBM2(79,116,3)
      REAL ABC2(2), ROSS2(2),TR2(2)
      REAL UBNDYM2(116,2,3), HBNDYM2(116,2,3)
      REAL H1M2(30,34,3), U1M2(30,34,3), V1M2(30,34,3)
      REAL Q0O2(30,34),UO2(30,34),VO2(30,34),DO2(30,34),TO2(30,34)
      REAL HTAU2(30,34,2)
      REAL SL2(30,34),H12(30,34)



C ouverture
      FN61='out-back1.dat'
      FN62='out-back2.dat'
      OPEN(UNIT=61, FILE=FN61, FORM='UNFORMATTED',ACCESS='SEQUENTIAL') 
      OPEN(UNIT=62, FILE=FN62, FORM='UNFORMATTED',ACCESS='SEQUENTIAL')  
      
      if (1 .EQ. 1) then
      REWIND 61 
      REWIND 62 
      endif


CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCc
C BOUCLE DE LECTURE 
C NOMBRE DE STEPS LUS 
      iend=1

C boucle
      print *, '      '
      print *, 'readhist.f: start read out-back1.dat et out-back2.dat'
      print *, ' analyse au time step du fichier (first=1)=',iend
      do ii=1,iend
c      print *,'read loop=',ii,iend
C
C LECTURE RUN1CCCCCCCCCCCCCCC
C lecture 35 params
      READ(61,ERR=99,END=100) NMODE
      READ(61,ERR=99,END=100) TD
      READ(61,ERR=99,END=100) NT
      READ(61,ERR=99,END=100) NXP
      READ(61,ERR=99,END=100) NYP
      READ(61,ERR=99,END=100) NSEG
      READ(61,ERR=99,END=100) NX
      READ(61,ERR=99,END=100) NY
      READ(61,ERR=99,END=100) HEQUIV
      READ(61,ERR=99,END=100) TZERO
      READ(61,ERR=99,END=100) TENDD
      READ(61,ERR=99,END=100) DTD
      READ(61,ERR=99,END=100) XWD
      READ(61,ERR=99,END=100) XED
      READ(61,ERR=99,END=100) YSD
      READ(61,ERR=99,END=100) YND
      READ(61,ERR=99,END=100) TDECAY
      READ(61,ERR=99,END=100) TPLMIN
      READ(61,ERR=99,END=100) TSTPRT
      READ(61,ERR=99,END=100) CHKSUM 
      READ(61,ERR=99,END=100) NPRINT
      READ(61,ERR=99,END=100) MASKW
      READ(61,ERR=99,END=100) MWNDGF
      READ(61,ERR=99,END=100) WMXW
      READ(61,ERR=99,END=100) WMXE
      READ(61,ERR=99,END=100) WMYS
      READ(61,ERR=99,END=100) WMYN
      READ(61,ERR=99,END=100) PERIOD
      READ(61,ERR=99,END=100) YNORTH 
      READ(61,ERR=99,END=100) YSOUTH
      READ(61,ERR=99,END=100) XWEST
      READ(61,ERR=99,END=100) NSEG
      READ(61,ERR=99,END=100) NTAPE
      READ(61,ERR=99,END=100) NREWND
      READ(61,ERR=99,END=100) NATM 
      NS=NSEG+1  
C 11 champs MV
      READ(61,ERR=99,END=100) AKBM
      READ(61,ERR=99,END=100) UBM
      READ(61,ERR=99,END=100) HBM
      READ(61,ERR=99,END=100) ABC
      READ(61,ERR=99,END=100) ROSS
      READ(61,ERR=99,END=100) TR
      READ(61,ERR=99,END=100) UBNDYM
      READ(61,ERR=99,END=100) HBNDYM
      READ(61,ERR=99,END=100) H1M
      READ(61,ERR=99,END=100) U1M
      READ(61,ERR=99,END=100) V1M
C lecture 8 champs autres, NATM=2
      READ(61,ERR=99,END=100) Q0O
      READ(61,ERR=99,END=100) UO
      READ(61,ERR=99,END=100) VO
      READ(61,ERR=99,END=100) DO
      READ(61,ERR=99,END=100) TO
      READ(61,ERR=99,END=100) HTAU
      READ(61,ERR=99,END=100) SL
      READ(61,ERR=99,END=100) H1

C LECTURE RUN2CCCCCCCCCCCCCCC
C lecture 35 params
      READ(62,ERR=99,END=100) NMODE2
      READ(62,ERR=99,END=100) TD2
      READ(62,ERR=99,END=100) NT2
      READ(62,ERR=99,END=100) NXP2
      READ(62,ERR=99,END=100) NYP2
      READ(62,ERR=99,END=100) NSEG2
      READ(62,ERR=99,END=100) NX2
      READ(62,ERR=99,END=100) NY2
      READ(62,ERR=99,END=100) HEQUIV2
      READ(62,ERR=99,END=100) TZERO2
      READ(62,ERR=99,END=100) TENDD2
      READ(62,ERR=99,END=100) DTD2
      READ(62,ERR=99,END=100) XWD2
      READ(62,ERR=99,END=100) XED2
      READ(62,ERR=99,END=100) YSD2
      READ(62,ERR=99,END=100) YND2
      READ(62,ERR=99,END=100) TDECAY2
      READ(62,ERR=99,END=100) TPLMIN2
      READ(62,ERR=99,END=100) TSTPRT2
      READ(62,ERR=99,END=100) CHKSUM2
      READ(62,ERR=99,END=100) NPRINT2
      READ(62,ERR=99,END=100) MASKW2
      READ(62,ERR=99,END=100) MWNDGF2
      READ(62,ERR=99,END=100) WMXW2
      READ(62,ERR=99,END=100) WMXE2
      READ(62,ERR=99,END=100) WMYS2
      READ(62,ERR=99,END=100) WMYN2
      READ(62,ERR=99,END=100) PERIOD2
      READ(62,ERR=99,END=100) YNORTH2
      READ(62,ERR=99,END=100) YSOUTH2
      READ(62,ERR=99,END=100) XWEST2
      READ(62,ERR=99,END=100) NSEG2
      READ(62,ERR=99,END=100) NTAPE2
      READ(62,ERR=99,END=100) NREWND2
      READ(62,ERR=99,END=100) NATM2 
      NSa=NSEGa+1  
C 11 champs MV
      READ(62,ERR=99,END=100) AKBM2
      READ(62,ERR=99,END=100) UBM2
      READ(62,ERR=99,END=100) HBM2
      READ(62,ERR=99,END=100) ABC2
      READ(62,ERR=99,END=100) ROSS2
      READ(62,ERR=99,END=100) TR2
      READ(62,ERR=99,END=100) UBNDYM2
      READ(62,ERR=99,END=100) HBNDYM2
      READ(62,ERR=99,END=100) H1M2
      READ(62,ERR=99,END=100) U1M2
      READ(62,ERR=99,END=100) V1M2
C lecture 8 champs autres, NATM=2
      READ(62,ERR=99,END=100) Q0O2
      READ(62,ERR=99,END=100) UO2
      READ(62,ERR=99,END=100) VO2
      READ(62,ERR=99,END=100) DO2
      READ(62,ERR=99,END=100) TO2
      READ(62,ERR=99,END=100) HTAU2
      READ(62,ERR=99,END=100) SL2
      READ(62,ERR=99,END=100) H12

C fin boucle lecture en boucle sur timesteps
      enddo

CCCCCCCCCCCCCCCCCCCCCCC
C
C sur dernier step, comparaison run1 et run2
      print *, '     '
      print *,'readhist.f: compa run1 et run2 sur dernier step lu:'
      print *,'NMODE',NMODE,NMODE2
      print *,'TD=',TD,TD2
      print *,'NT=',NT,NT2
      print *,'NXP=',NXP,NXP2
      print *,'NYP=',NYP,NYP2
      print *,'NSEG=',NSEG,NSEG2
      print *,'NX=',NX,NX2
      print *,'NY=',NY,NY2
      print *,'HEQUIV=',HEQUIV,HEQUIV2
      print *,'TZERO=',TZERO,TZERO2
      print *,'TENDD=',TENDD,TENDD2
      print *,'DTD=',DTD,DTD2
      print *,'XWD=',XWD,XWD2
      print *,'XED=',XED,XED2
      print *,'YSD=',YSD,YSD2
      print *,'YND=',YND,YND2
      print *,'TDECAY=',TDECAY,TDECAY2
      print *,'TPLMIN=',TPLMIN,TPLMIN2
      print *,'TSTPRT=',TSTPRT,TSTPRT2
      print *,'CHKSUM=',CHKSUM,CHKSUM2
      print *,'NPRINT=',NPRINT,NPRINT2
      print *,'MASKW=',MASKW,MASKW2
      print *,'MWNDGF=',MWNDGF,MWNDGF2
      print *,'WMXW=',WMXW,WMXW2
      print *,'WMXE=',WMXE,WMXE2
      print *,'WMYS=',WMYS,WMYS2
      print *,'WMYN=',WMYN,WMYN2
      print *,'PERIOD=',PERIOD,PERIOD2
      print *,'YNORTH=',YNORTH,YNORTH2
      print *,'YSOUTH=',YSOUTH,YSOUTH2
      print *,'XWEST=',XWEST,XWEST2
      print *,'NSEG=',NSEG,NSEG2
      print *,'NTAPE=',NTAPE,NTAPE2
      print *,'NREWND=',NREWND,NREWND2
      print *,'NATM=',NATM,NATM2

      if (0 .eq. 1) then
      print *, '     '
      print *, 'pour les champs regarder difference:'
      print *,'AKBM=',AKBM2-AKBM
      print *,'UBM=',UBM2-UBM
      print *,'HBM=',HBM2-HBM
      print *,'ABC=',ABC2-ABC
      print *,'ROSS=',ROSS2-ROSS
      print *,'TR=',TR2-TR
      print *,'UBNDYM=',UBNDYM2-UBNDYM
      print *,'HBNDYM=',HBNDYM2-HBNDYM
      print *,'H1M=',H1M2-H1M
      print *,'U1M=',U1M2-U1M
      print *,'V1M=',V1M2-V1M
      print *,'Q0O=',Q0O2-Q0O
      print *,'UO=',UO2-UO
      print *,'VO=',VO2-VO
      print *,'DO=',DO2-DO
      print *,'TO=',TO2-TO
      print *,'HTAU=',HTAU2-HTAU
      print *,'SL=',SL2-SL
      print *,'H1=',H12-H1
      endif

CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C messages erreur ou fin de la lecture
      print *, '      '
      print *, 'fin de lecture: '
99    print *, 'ERREUR READ (aucun effet si apres fin de lecture)'
100   print *, 'END OF FILE(aucun effet si apres fin de lecture)'
      print *, '      '





      END