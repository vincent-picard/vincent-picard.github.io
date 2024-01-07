# Expressions conditionnelles

Une caractéristique essentielle des programmes informatiques est la possibilité d'exécuter une certain code lorsqu'une condition est vraie et un autre code lorsque cette condion est faux. En `OCaml`, cette possibilité est fournie par l'**expression conditionnelle** : `if ... then ... else ...`.

## Syntaxe

La syntaxe générale d'une expression conditionnelle est :
```ocaml
if test then expr_vrai else expr_faux
```

`test` est un test, c'est-à-dire une **expression booléenne** dont la valeur est évaluée par le programme. Si elle est évaluée à `true` alors l'expression `expr_vrai` est évaluée et son résultat est retourné, sinon c'est le résultat de l'évaluation de `expr_faux` qui est retourné.

À titre d'exemple, nous pouvons (ré)-écrire la fonction valeur absolue :
```ocaml
let abs x =
    if x > 0 then
        x
    else
        -x
;;
```

## Le `if` est une expression

Encore une fois, `OCaml` se distingue du `C` par le fait que le `if` n'est pas une instruction mais une **expression** : en Caml, un `if` possède un type et une valeur.

Voici un exemple faisant intervenir cette particularité. Nous allons écrire une fonction qui prend en entrée la longueur d'un côté de carré, qui diminue cette longueur de 4 et qui calcule l'aire du carré. Evidemment, si le carré a initialement un côté inférieur à 4 alors le résultat sera nul. Nous pourrions écrire :
```ocaml
let aire_reduite cote =
    if cote < 4 then
        0
    else
        (cote - 4) * (cote - 4)
;;
```
mais il est tout à fait possible d'écrire également
```ocaml
let aire_reduite cote =
    let carre x = x * x in
    carre (if cote < 4 then 0 else cote)
;;
```
où l'expression `if` sert à calculer la longueur du côté reduit.  

## Typage fort

Comme `OCaml` est fortement typé, toute expression possède un type, et les expressions conditionnelles n'échappent pas à cette règle. Il n'est par exemple pas possible d'écrire :
```ocaml
if 72 > 35 then 7 else 3.5;;
```
Nous obtenons la réponse suivante :
```
# if 72 > 35 then 7 else 3.5;;
Error: This expression has type float but an expression was expected of type
         int 
```
En effet, `OCaml` n'est pas capable de déterminer le type de cette expression conditionnelle qui pourrait être évaluée à `7` de type `int` ou `3.5` de type `float`, cela conduit à une erreur de typage. Cela arrive même lorsque le résultat du test pourrait être prédit à l'avance comme c'est le cas ici.  

La règle est donc la suivante : `expr_vrai` et `expr_faux` **doivent être de même type**.

Pour la même raison, il n'est pas possible d'avoir un `if` qui ne contient pas de else :
```
# if 3 > 8 then 71;;
Error: This expression has type int but an expression was expected of type
         unit because it is in the result of a conditional with no else branch
```
En effet, cette expression doit nécessairement avoir une valeur en OCaml dont le `else` est nécessaire.

L'interprète nous parle ici du type `unit` car cette seconde règle souffre d'une seule exception que nous verrons dans le chapitre sur la programmation impérative.
