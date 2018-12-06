%LARMIGNAT THOMAS
%version du 20/10/2018
%%%%%%%%%%%%%%%%%%%%%%%%%      MODULAIRE        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Predicats pour les conditions de victoire.(modualire)
%3 type de victoire : Colonnes, Diagonales,lignes
victoire(G,Joueur):-victoireEnDiagonale(G,Joueur).
victoire(G,Joueur):-victoireEnLigne(G,Joueur).
victoire(G,Joueur):-victoireEnColonne(G,Joueur).

%victoire en Diagonale
victoireEnDiagonale([[Joueur,_,_],[_,Joueur,_],[_,_,Joueur]],Joueur).
victoireEnDiagonale([[_,_,Joueur],[_,Joueur,_],[Joueur,_,_]],Joueur).
%Victoire en ligne
victoireEnLigne([[Joueur,Joueur,Joueur],[_,_,_],[_,_,_]],Joueur).
victoireEnLigne([[_,_,_],[Joueur,Joueur,Joueur],[_,_,_]],Joueur).
victoireEnLigne([[_,_,_],[_,_,_],[Joueur,Joueur,Joueur]],Joueur).
%Victoire en Colonne
victoireEnColonne([[Joueur,_,_],[Joueur,_,_],[Joueur,_,_]],Joueur).
victoireEnColonne([[_,Joueur,_],[_,Joueur,_],[_,Joueur,_]],Joueur).
victoireEnColonne([[_,_,Joueur],[_,_,Joueur],[_,_,Joueur]],Joueur).

%Evalution de la Grille(modulaire)
evalGrille(_,G,100):- victoire(G,o),!. %on maximise les gains de l'IA
evalGrille(_,G,-100):- victoire(G,x),!.%on minimise les gains du joueurs.
evalGrille(_,[],0).
evalGrille(_,G,0):- grillePleine(G).%en dernier sinon prolog ne fais pas les deux clauses d'avant


evalGrille(Joueur,[Ligne|Reste],Poid):- evalGrilleCb(Joueur,[Ligne|Reste],0,Poid).

evalGrilleCb(_,[],Old,P):- P is Old, !.
evalGrilleCb(Joueur,[Ligne|Reste],Old,_) :-evalLigne(Joueur,Ligne,Poid),NewPoid is Old + Poid, evalGrilleCb(Joueur,Reste,NewPoid,_).



test(P) :- evalGrilleCb(o,[[x,o,-],[o,-,-],[-,-,-]],0,P).


evalLigne(J,[J,J,-],4).
evalLigne(J,[J,-,J],4).
evalLigne(J,[-,J,J],4).

evalLigne(J,[J,-,-],1).
evalLigne(J,[-,J,-],1).
evalLigne(J,[-,-,J],1).
evalLigne(_,_,0).








%Validitée d'un coup(modulaire)
coupValide([Lettre,Numero],G):- caseVide(Lettre,Numero,G).

%Premier coup optimal (modulaire)
premierCoup([[-,-,-],[-,J,-],[-,-,-]],J).


%%%%%%%%%%%%%%%%%%%%%%%%%      GRILLE        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Grille de Depart (Tic-tac-toe donc vide au depart)
grilleDepart([[-,-,-],[-,-,-],[-,-,-]]).

%On apprend a prolog à representer la grille par des indices.
grilleListe([[a,1],[b,1],[c,1],
             [a,2],[b,2],[c,2],
             [a,3],[b,3],[c,3]]).

%Indices pour parcourir la matrice (ajouter des connaissance pour plus grande grille)
suivantLigne(1,2).
suivantLigne(2,3).
suivantCol(a,b).
suivantCol(b,c).

precedentLigne(3,2).
precedentLigne(2,1).
precedentCol(c,b).
precedentCol(b,a).

%%%%%%%%%%%%%%%%%%%%%%%%%      OUTILS        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%La façon dont un coup est joué est different d'un jeu à l'autre donc modulaire
coupJoueDansLigne(a, Val, [-|Reste],[Val|Reste]).%A la premiere case vide de la colonne on unifie
coupJoueDansLigne(Lettre, Val, [X|Reste1],[X|Reste2]):-suivantCol(I,Lettre),coupJoueDansLigne(I, Val, Reste1, Reste2).%On decremente la valeur de la col, se qui permet de reduire le nombre de col jusqu'à la cible.

%Predicat pour joué un coup dans la grille (Repris de votre code ...)
ajoutCaseGrille(Lettre,1,Val,[HeadOld|Reste],[Head|Reste]):- coupJoueDansLigne(Lettre, Val, HeadOld, Head).
ajoutCaseGrille(Lettre, Chiffre, Val, [X|TailOld], [X|Tail]):- suivantLigne(Suivant, Chiffre),ajoutCaseGrille(Lettre, Suivant, Val, TailOld, Tail).


%Permet au Joueur de saisir un coup (repris de votre code ...)
saisieUnCoup(NomCol,NumLig) :-
	writeln("[Jeu] Entrez le nom de la colonne a jouer (a,b,c) :"),
	read(NomCol), nl,
	writeln("[Jeu] Entrez le numero de ligne a jouer (1, 2 ou 3) :"),
	read(NumLig),nl.

%Conditions de fin de partie
%on utilise victoire et grillePleine et non pas evalGrille qui sera modifier en fonction du jeu (poids)
%AVEC DES BREAKS NON DEFINITIF
verifierFin(G):- victoire(G,o),writeln("[Jeu] Perdu"),break,!.
verifierFin(G):- victoire(G,x),writeln("[Jeu] Gagné"),break,!.
verifierFin(G):- grillePleine(G),writeln("[Jeu] Egalité"),break,!.
verifierFin(_):- true.
