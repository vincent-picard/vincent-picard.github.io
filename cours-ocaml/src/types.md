# Types

Nous allons maintenant étudier plus en détail le système de types de `OCaml`.

Rappelons brièvement les règles que nous avons déjà vues :
1. Toute expression a une valeur et un type
1. Les fonctions et les opérateurs ont une seule signature : il n'y a pas de surcharge en `OCaml`
1. `OCaml` ne fera jamais de conversion de type implicite : les types des fonctions doivent être respectés

Le deuxième point est important. Contrairement à un langage comme `Python` où l'on peut écrire indistinctement `1 + 7`, `1 + 3.5`, `2.4 + 3.6` ou même `"Hello " + "world!"` cela n'est pas possible en `OCaml`. En effet, cela conduirait à certains problèmes, regardons par exemple :
```ocaml
let somme x y =
    x + y
;;
```
Quel serait le type de cette fonction si la surchage du `+` était possible comme en `Python` ? `x` et `y` pourraient être des entiers, des flottants, voire même des chaînes de caractères et il ne serait pas possible de déterminer le type de `somme`... c'est embêtant !

`OCaml` utilise un mécanisme appelé l'**inférence de type** qui détermine automatiquement et sans ambiguité le type de n'importe quelle expression tapée dans un programme. Ainsi OCaml est capable de vérifier dès la compilation le type de chaque expression et vérifier que les fonctions sont appelées avec les bons types de données. Cela permet de corriger un très grand nombre de bugs dès la compilation. Il y a certaines contre-parties comme le fait d'avoir des opérateurs et des fonctions différents pour chaque type et de devoir s'occuper soi-même de toutes les conversions.
