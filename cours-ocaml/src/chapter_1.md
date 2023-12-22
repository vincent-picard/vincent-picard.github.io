# Introduction

Ce livre a pour but de vous familiariser rapidement et efficacement au langage de programmation `OCaml` et plus généralement à la programmation **fonctionnelle**. Nous traiteront uniquement les aspects de `OCaml` qui sont au programme d'informatique de la MP2I/MPI.

`OCaml` est un langage à la philosophie plutôt opposée à celle du langage `C` :
- `OCaml` est un langage principalement **fonctionnel** : on programme *mathématiquement* en exprimant ce que le programme est censé faire contrairement au langage `C` dans lequel on programme **impérativement** en donnant une suite d'ordres à la machine.
- `OCaml` est un langage de **haut niveau** : il ne vous demande pas de programmer par vous même les aspects machines tels que les allocations et libérations de mémoire sur le *tas* ou la manipulation directe d'adresses mémoires via les *pointeurs*. En fait on peut quasiment programmer en oubliant qu'une machine va exécuter notre code.
- `OCaml` est un langage **fortement typé** : le système de type de `OCaml` est **statique** comme en C : c'est-à-dire qu'une variable possède un seul type, connu à la compilation, qui ne changera pas lors de l'exécution. Toutefois le typage en `OCaml` est bien plus rigide qu'en `C` : toute expression, toute fonction a un type précis qu'il faudra bien respecter sous peine de voir le compilateur refuser le programme. C'est aussi ce qui fait la force de `OCaml` de nombreux bugs sont détectés et corrigés dès la compilation.
- Le langage `C` est plutôt mimimaliste et c'est ce qui fait son charme mais aussi ses défauts : pas de **gestion des erreurs**, gestion fastidieuse des **chaînes de caractères**, pas de gestion native des **listes**, pas de gestion du **polymorphisme**. Nous verrons que `OCaml` est plus riche et permet de manipuler des concepts plus puissants.

Tous ces aspects contribuent à faire de `OCaml` l'un des langages les plus sûrs et les plus efficaces du moment. En raison de son haut degré d'abstraction et d'une prise en main difficile, il souffre aujourd'hui d'une fausse réputation de langage *purement académique*. Dans les faits, `OCaml` est utilisé dans l'industrie :
- `Facebook` (Hack, Flow), `Messenger` et `What's app` : utilisent `OCaml` pour faire fonctionner leurs services en raison de sa rapidité et du faible taux de bugs
- Vérificateurs de programmes : analyseur statique `ASTREE` qui a vérifié les programmes de bord de l'Airbus A340
- Logiciels du monde de la finance : sociétés `Jane Street` et `LexiFi`
- Assistant de preuve mathématique `Coq` : première preuve entièrement formalisée du [théorème des 4 couleurs](https://fr.wikipedia.org/wiki/Th%C3%A9or%C3%A8me_des_quatre_couleurs) !
- FFTW : calcul rapide de transformée de Fourier discrètes
- Unison :  synchroniseur de fichiers sûr et multi-plateformes


```
let x = 2 in if x > 3 then 2 else 7;;
``` 
