%LARMIGNAT THOMAS
%version du 10/11/2018
%%%%%%%%%%%%%%%%%%%%%%%%%      MOTEUR MIN MAX        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%alterner les coups
autreJoueur(x,o).
autreJoueur(o,x).

%Lister tous les coups possibles
listeCasesValides(_G,[],[]):- !.
listeCasesValides(G,[Case|Tail],[Case|L]):- coupValide(Case,G),listeCasesValides(G,Tail,L).
listeCasesValides(G,[Case|Tail],L):- \+(coupValide(Case,G)),listeCasesValides(G,Tail,L).

%liste des coups valides (generique on peut ajouter des regles)
listeCoupsValides(G, ListeCasesValides):- grilleListe(ListeCases), listeCasesValides(G,ListeCases,ListeCasesValides).

%Genere toutes les nouvelles grilles possible
genererGrillesPossiblesCallBack([],_G,[],_J):-!.
genererGrillesPossiblesCallBack([[Lettre,Chiffre]|Tail],G,[NewGrille|Suite],Joueur):- ajoutCaseGrille(Lettre,Chiffre,Joueur,G,NewGrille),genererGrillesPossiblesCallBack(Tail,G,Suite,Joueur).

%Pour debug
grillesPossibles(Joueur,G,NewGrilles) :- listeCoupsValides(G, ListeCasesValides),genererGrillesPossiblesCallBack(ListeCasesValides,G,NewGrilles,Joueur).

%Comparaison des differents coups en fontion de la position min ou max dans l'arbre, on choisi le coup avec la meilleure valeur.
%Pour max:
compareCoups(o, CoupA, ValeurCoupA, _CoupB, ValeurCoupB, CoupA, ValeurCoupA) :- ValeurCoupA >= ValeurCoupB.
compareCoups(o, _CoupA, ValeurCoupA, CoupB, ValeurCoupB, CoupB, ValeurCoupB) :- ValeurCoupA < ValeurCoupB.
%Pour min:
compareCoups(x, CoupA, ValeurCoupA, _CoupB, ValeurCoupB, CoupA, ValeurCoupA) :- ValeurCoupA =< ValeurCoupB.
compareCoups(x, _CoupA, ValeurCoupA, CoupB, ValeurCoupB, CoupB, ValeurCoupB) :- ValeurCoupA > ValeurCoupB.

%Predicat servant d'encapsultation pour que meilleurCoup soit appelé avec une seule grille.
meilleurCoupJoueur(Joueur, Board, BestMove, BestValue) :-
      grillesPossibles(Joueur, Board, AllMoves),
      meilleurCoup(Joueur, AllMoves, BestMove, BestValue).

%Construction de l'arbre minmax
meilleurCoup(o, [], [], -1000):-!.
meilleurCoup(x, [], [], 1000):-!.
meilleurCoup(Joueur, [Coup | RestCoups], MeilleurCoup, MeilleurValue) :-
    evalGrille(Joueur,Coup, Value),%Evalution de la grille renvois False si pas pleine.
    meilleurCoup(Joueur, RestCoups, NoeudMeilleurCoup, NoeudValeur),%On rappel MeilleurCoup sur le reste des coups
	  compareCoups(Joueur, Coup, Value, NoeudMeilleurCoup, NoeudValeur, MeilleurCoup, MeilleurValue).%On compare les coups et on remonte le meilleur.

meilleurCoup(Joueur, [Coup | RestCoups], MeilleurCoup, MeilleurValue) :-
    	meilleurCoup(Joueur, RestCoups, NoeudMeilleurCoup, NoeudValeur),%On rappel le predicat avec le reste des coups, on remonte le meilleur
    	autreJoueur(Joueur, AutreJoueur),%On change de Joueur
    	meilleurCoupJoueur(AutreJoueur, Coup, _, ValeurCoup),%On rappel le coups courant, on remonte le meilleur
    	compareCoups(Joueur, Coup, ValeurCoup, NoeudMeilleurCoup, NoeudValeur, MeilleurCoup, MeilleurValue).%On compare les coups et on remonte le meilleur.

%Encapsultion, on reduit le nombre d'arités.
minmax(Board, PremierCoup) :-grilleDepart(Board), premierCoup(PremierCoup,o),afficherGrille(PremierCoup),nl, !.
minmax(Board, BestMove) :-
      meilleurCoupJoueur(o, Board, BestMove, _),
      afficherGrille(BestMove),nl.
