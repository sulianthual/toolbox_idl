Pro mynewrandomu,mu,seed
compile_opt hidden
;
print,'PROBLEME mynewrandomn, utiliser plutot myrandomn pour distribution complete'
stop
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; NOTE: PREFERER MYRANDOMN.PRO QUI GENERE UNE NOUVELLE DISTRIBUTION SUR NENS MEMBRES DE ENSEMBLE, 
;       ET GERE UN NOUVEAU SEED.
;
; Sulian Thual 2011
; Renvoie un nombre aleatoire comme randomu
; C'est identique a randomu, mais le seed est redefini. Cela permet de ne pas creer une nouvelle variable seed
; a chaque fois que l'on veut reinitialiser la distribution
;
; en fonctionnnement normal
; mu(0)=randomu(seed)
; => retourne mu aleatoire et defini seed
; mu(1)=randomu(seed)
; =>maintenant avec un deuxieme appel,le seed precedent est reutilise
; mynewrandomu,pass,seed & alpha(0)=pass
; alpha(1)=randomu(seed)
; => commence une nouvelle distribution alpha(0,1), en reinitialisant le seed
; => cela permet de ne pas definir une nouvelle variable (seed1 par exemple) dans le code
; Tres utile pour les boucles
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
mu=randomu(seed0)
seed=seed0
;
end