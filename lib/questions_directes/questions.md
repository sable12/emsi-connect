# Réponses directes — TP1 Flutter : EMSI Connect

## Partie 1 – Préparer le projet

Q4. Quel est le rôle de `main.dart` ?

`main.dart` contient le point d’entrée de l’application Flutter. Il lance l’application avec `runApp()`.

Q5. Pourquoi séparer `home_page.dart` de `main.dart` ?

Pour séparer la configuration générale de l’application de l’interface de la page d’accueil, rendre le code plus lisible et faciliter sa maintenance.

## Partie 2 – Construire la structure principale

Q6. Quelle est la différence entre `MaterialApp` et `Scaffold` ?

`MaterialApp` configure l’application (thème, titre, navigation et page initiale). `Scaffold` définit la structure visuelle d’une page (`AppBar`, `body`, bouton flottant, etc.).

Q7. Pourquoi `StatelessWidget` convient-il ici ?

Parce que la page affiche des éléments statiques qui ne nécessitent pas de gérer un état mutable interne.

## Partie 3 – Ajouter la barre supérieure

Q8. Quelle différence existe-t-il entre `Icon` et `IconButton` ?

`Icon` affiche simplement une icône, tandis que `IconButton` affiche une icône cliquable et permet d’exécuter une action avec `onPressed`.

## Partie 4 – Construire le contenu principal

Q7. Quel est le rôle de `Column` ?

`Column` organise plusieurs widgets verticalement, de haut en bas.

Q8. Quelle différence existe-t-il entre `Padding` et `SizedBox` ?

`Padding` ajoute un espace intérieur autour d’un widget. `SizedBox` permet de définir une taille fixe ou un espace entre plusieurs widgets.

## Partie 5 – Afficher les rubriques

Q8. Pourquoi utiliser `Row` à l’intérieur d’une `Column` ?

`Row` organise les rubriques horizontalement, tandis que `Column` organise les lignes verticalement. Cela permet d’obtenir une grille de deux colonnes et deux lignes.

## Partie 6 – Ajouter un bouton flottant

Q3. À quoi sert `onPressed` ?

`onPressed` définit la fonction exécutée lorsque l’utilisateur clique sur le bouton.

Q4. Pourquoi déclarer `floatingActionButton` dans `Scaffold` ?

Parce que `Scaffold` gère la disposition du bouton flottant dans la page, généralement en bas à droite.

## Questions de synthèse

1\. Quel est le rôle de `runApp()` ?

`runApp()` démarre l’interface Flutter en installant le widget racine de l’application.

2\. Qu’appelle-t-on un arbre de widgets ?

C’est la hiérarchie des widgets qui composent l’interface, du widget racine jusqu’aux widgets enfants.

3\. Comment afficher plusieurs éléments alors que `body` reçoit un seul widget ?

En utilisant un widget parent comme `Column`, `Row` ou `ListView`, qui peut contenir plusieurs widgets enfants.

4\. Quelle différence existe-t-il entre `child` et `children` ?

`child` reçoit un seul widget, tandis que `children` reçoit une liste de widgets.

5\. Dans quel cas utiliserait-on `StatefulWidget` ?

Lorsqu’un widget doit gérer un état qui évolue, par exemple un compteur, une case à cocher ou un formulaire interactif.

6\. Quel avantage apporte la séparation `main.dart` / `home_page.dart` ?

Elle améliore l’organisation du code, sa lisibilité, sa maintenance et facilite l’ajout de nouvelles pages.
