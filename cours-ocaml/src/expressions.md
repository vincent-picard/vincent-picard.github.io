# Expressions

## Expressions, types, valeurs

Une **expression** est un texte qui décrit un *calcul* à effectuer. Par exemple `(2 + 5) * 3` est une expression.
Chaque expression possède une **valeur** qui est le résultat du calcul représenté et un **type** qui est le type
de données du résultat. Ainsi `(2 + 5) * 3` est une expression dont la valeur est `21` et le type est `int` (entier).
L'opération qui consiste à déterminer la valeur d'une expression s'appelle l'**évaluation**.

Pour demander à `OCaml` d'évaluer une expression, on l'écrit et on la fait suivre du *terminateur d'expression* `;;`
```ocaml
(2 + 5) * 3;;
```
Si on travaille avec l'interprète `OCaml`, ce que je conseille pour débuter, on obtiendra la réponse suivante :
```
- : int = 21
```
signifiant que l'expression a été détectée du type entier `int` et que sa valeur est `21`.

Basiquement, un programme `OCaml` a la forme suivante :
```ocaml
expression1;;
expression2;;
expression3;;
...
```
Lorsqu'un programme `OCaml` est exécuté, l'ensemble des expressions sont évaluées dans l'ordre.
Il n'y a donc pas de fonction `main` dans un programme `OCaml`.
