%LARMIGNAT THOMAS
%version du 10/11/2018
chargerModules:- consult(representation), consult(moteur), consult(tictactoe).

%JOUEUR = x.
%ORDI = o.
%%%%%%%%%%%%%%%%%%%%%%%%%      GESTION PARTIE        %%%%%%%%%%%%%%%%%%%%%
%Saisie du coup du Joueur et jouer ce coup.
joueur(OldG, NewG) :- saisieUnCoup(Col,Ligne),ajoutCaseGrille(Col,Ligne,x,OldG,NewG).%a changer, pas vrai pour tout les jeux

%Altenance des coup avec Ordi en premier
lancerJeu1Ordi(G):- minmax(G, GrilleOrdi),
                    verifierFin(GrilleOrdi),
                    joueur(GrilleOrdi,GrilleJoueur),
                    verifierFin(GrilleJoueur),
                    lancerJeu1Ordi(GrilleJoueur).

%Altenance des coup avec Joueur en premier
lancerJeu1Joueur(G):- joueur(G,GrilleJoueur),
                      verifierFin(GrilleJoueur),
                      minmax(GrilleJoueur, GrilleOrdi),
                      verifierFin(GrilleOrdi),
                      lancerJeu1Joueur(GrilleOrdi).

lancerJeu(0) :- writeln("[Jeu] L'ordinateur commence"),
                  grilleDepart(G),
                  afficherGrille(G),nl,
                  lancerJeu1Ordi(G).

lancerJeu(1) :- writeln("[Jeu] Vous commencez"),
                  grilleDepart(G),
                  afficherGrille(G),nl,
                  lancerJeu1Joueur(G).

lancerTicTacToe :- random_between(0,1,R),lancerJeu(R).%a deplacer dans tictactoe.pl
%lancerOthello :-
%lancerKono :-


%Faire un random si possible pour choisir le premier joueur et appelé une des deux Versions de lancerJeu
jeu:- lancerTicTacToe.
