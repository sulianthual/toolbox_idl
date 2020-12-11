


*** Deja fait en IDL pour LODCA: toolbox_idl_lodca (V7-lodcaidl)

- Fichier commentaire de lodca.dat (lodcacomment.dat)

- mylodca pour execution rapide de lodca par idl, avec gestion du cycle saisonnier,comments dans blabla.txt

- Ajout de possibilite de vent a 10j 

- Ajout chemin fichiers clim et SVD atm (modifs lodca.dat)

- Lecture, Ecriture fichier lodca.dat (getdat.pro, putdat.pro)

- Lecture, Ecriture du fichier vents  (getwind.pro, putwind.pro)

- Lecture, Ecriture des fichiers clim (getclim.pro, putclim.pro)

- changement nrdhist.f tel que lecture-ecriture history elements par elements. (tourne mais verifier les erreurs)

- lecture-ecriture history f77_unformatted (gethistory.pro, puthistory.pro)

- Keep ecriture des fichiers netcdf mais mis une clef oui ou non

-mylodcaversion: choix de la version de lodca (conserve dans lodcaversion.dat dans la toolbox)

- /Work/LODCA/.. pour version(s) lodca a utiliser et yourdata pour garder les datas

- mylodcagethistory pour lire sortie history de lodca (choix nombre de steps possible)

- myshowoutput pour lire et graph rapide du netcdf output.nc

-mylodcaputwind: ecrit les fichiers vent en binaire (mettre 2 steps minimum car on reform sous idl,+interpolation lodca)

-mylodcagetwind: lit un fichier vent binaire (ntr du vent doit etre connu)

-mylodcaputhistory pour modifier un fichier history: tstart et ntr ajoutes

-A partir de V6-lodcaidl, modifs skip du wind=T0WIND pour la lecture du vent (ok, ok a 10j)
 A retenir, dans le restart on ecrit toujours le vent couple et non force quelque soit le type de run

-test de comparaison run long/run multiple: ecart numerique faible(C,F,N,month-10days wind...)

- A partir de V7-lodca, larger paths pour filenames en entree de lodca (*****A DEFINIR DEPUIS LE REPERTORY DE LODCA !)
   ****ATTENTION****Les noms de fichiers peuvent etre trop longs pour lodca

-mylodcaset pour choisir les settings du run (edition de lodca.dat)
 utiliser ensuite mylodcaparams pour affiner le lodca.dat 

*** A faire en IDL pour LODCA toolbox : (V7-lodcaidl)

- lodca: parametre scaal tq tous les champs sont mulitplies par scaal a la fin du mois
         utile pour la stabilite methode de mcmynowski




























