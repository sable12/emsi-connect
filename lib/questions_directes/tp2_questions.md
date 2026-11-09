# Réponses directes — TP2 Flutter : Mise en page et écran Profil

## Partie 2 — Comparer Expanded et Flexible

1\. Quel est le rôle de `Expanded` dans une `Row` ?

`Expanded` force l'enfant à occuper tout l'espace horizontal disponible après que les autres widgets non-Expanded ont pris leur espace. Dans une `Row` avec plusieurs `Expanded`, l'espace restant est distribué équitablement entre eux (sauf si on utilise la propriété `flex` pour définir des proportions différentes).

2\. Quelle différence existe-t-il entre `Expanded` et `Flexible (fit: FlexFit.loose)` ?

`Expanded` (équivalent à `Flexible(fit: FlexFit.tight)`) force l'enfant à remplir tout l'espace alloué par le parent. En revanche, `Flexible(fit: FlexFit.loose)` permet à l'enfant de prendre seulement l'espace nécessaire à son contenu (taille intrinsèque), sans forcer à remplir tout l'espace disponible. Par exemple, dans une `Row` avec un `Expanded` et un `Flexible(loose)`, le premier occupera tout l'espace restant après le deuxième.

## Partie 4 — Vérification et bilan

3\. Pourquoi placer Stack dans un SizedBox de hauteur définie ?

Le `Stack` est placé dans un `SizedBox` de hauteur définie pour contrôler sa taille et garantir un positionnement prévisible des widgets enfants. Sans hauteur fixe, le `Stack` s'étendrait indéfiniment, rendant la superposition des widgets (comme le Container de fond et le CircleAvatar) imprévisible et incohérente selon l'espace disponible.

4\. Quelle différence existe-t-il entre Padding et Container ?

`Padding` est un widget dont le seul but est d'ajouter un espace intérieur autour de son enfant. `Container` est un widget plus polyvalent qui peut gérer le padding, mais aussi la décoration (couleur, bordure, ombre), les contraintes de taille, les marges (margin), et bien d'autres propriétés de mise en forme.

5\. Pourquoi conserve-t-on SingleChildScrollView sur la page Profil ?

On conserve `SingleChildScrollView` pour permettre le défilement vertical du contenu si l'écran est trop petit pour afficher toutes les informations (bandeau, avatar, informations personnelles, boutons, carte étudiant). Cela évite les débordements et garantit que tout le contenu reste accessible sur tous les écrans.

6\. Pourquoi ne peut-on pas encore ouvrir le profil en cliquant sur « Mon profil » ?

La navigation entre les écrans n'a pas encore été implémentée. Pour permettre le clic sur "Mon profil", il faudrait ajouter un `GestureDetector` ou utiliser `Navigator.push()` dans un `onPressed` ou `onTap`, ce qui sera fait dans un prochain TP dédié à la navigation.

## Partie 5 – Exercices d'approfondissement

7\. Quelles modifications ont été apportées pour améliorer l'affichage sur petits écrans ?

Les modifications incluent : réduction du padding horizontal (de 16 à 12 pixels), réduction de la taille du bandeau et de l'avatar, ajout de `Expanded` avec `TextOverflow.ellipsis` pour les textes longs, réduction des espacements verticaux entre les éléments, et réduction de la taille de police des boutons pour éviter les débordements.

## Analyse de code

8\. Quel problème peut apparaître si le code suivant est exécuté sur un écran étroit ?

```dart
Row(
  children: [
    Container(width: 200, height: 80, color: Colors.blue),
    Container(width: 200, height: 80, color: Colors.orange),
  ],
)
```

Si l'écran a une largeur inférieure à 400 pixels (200 + 200), les deux containers déborderont horizontalement, provoquant une erreur de layout ou un débordement visuel, car les widgets ont des largeurs fixes sans contrainte flexible.

9\. Modifier le code en utilisant Expanded pour éviter que les deux blocs dépassent la largeur disponible.

```dart
Row(
  children: [
    Expanded(
      child: Container(height: 80, color: Colors.blue),
    ),
    Expanded(
      child: Container(height: 80, color: Colors.orange),
    ),
  ],
)
```

10\. Ajouter un espace horizontal de 10 pixels entre les deux blocs sans modifier leur hauteur.

```dart
Row(
  children: [
    Expanded(
      child: Container(height: 80, color: Colors.blue),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: Container(height: 80, color: Colors.orange),
    ),
  ],
)
```

11\. Modifier le code pour que le premier bloc occupe deux fois plus d'espace que le second.

```dart
Row(
  children: [
    Expanded(
      flex: 2,
      child: Container(height: 80, color: Colors.blue),
    ),
    const SizedBox(width: 10),
    Expanded(
      flex: 1,
      child: Container(height: 80, color: Colors.orange),
    ),
  ],
)
```
