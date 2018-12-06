%LARMIGNAT THOMAS
%version du 20/10/2018
%%%%%%%%%%%%%%%%%%%%%%      AFFICHAGE        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%Affichage d'une ligne avec simple parcours recursif
afficherLigne([]):- write('|'),nl.
afficherLigne([T|Q]):-
    write('|'),write(T),
    afficherLigne(Q).

%Affichage d'une grille
%TEST =  afficherGrille([[-,-,-],[x,o,x],[o,-,o]]).
afficherGrille([]).
afficherGrille([T|Q]):- afficherLigne(T),
      afficherGrille(Q).

%%%%%%%%%%%%%%%%%%%%%%      OUTILS        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%savoir si un element est contenu dans une liste de liste
memberlist(X,[H|_]):- member(X,H).
memberlist(X,[_|T2]):- memberlist(X,T2).

%Predicat pour savoir si la Grille est plane càd ne contient aucun "-"
grillePleine(G) :- \+ memberlist(-, G).

%Donne la ligne recherchéé dans la grille
ligneGrille(1,[Head|_],Head).
ligneGrille(Numero,[_|Tail],Ligne):- suivantLigne(Precedent,Numero),ligneGrille(Precedent,Tail,Ligne).

%Donne la case recherchéé dans un ligne
caseLigne(a,[Head|_],Head).
caseLigne(Lettre,[_|Tail],Case):- suivantCol(Precedent,Lettre),caseLigne(Precedent,Tail,Case).

%Donne la Case recherchéé dans la ligne
caseGrille(Lettre,Numero,G,Case):- ligneGrille(Numero,G,Ligne), caseLigne(Lettre,Ligne,Case).

%Verifie si la case est vide (True) ou non (False), caseGrille/4 appelée en Callback.
caseVide(Lettre,Numero,G):- caseGrille(Lettre,Numero,G,-).
