# Algorithmes probabilistes, algorithmes d'approximation

## 1. Algorithmes probabilistes

Un algorithme est dit **probaliste** lorsque son exécution dépend de valeurs générées aléatoirement. Nous étudierons à l'aide d'exemples, deux classes d'algorithmes probabilistes :

- Les algorithmes de **Las Vegas** qui donnent toujours un résultat correct mais dont le temps d'exécution est aléatoire. L'idée est que l'espérance du temps d'exécution soit meilleure que celle d'un algorithme déterministe.
- Les algorithmes de **Monte Carlo** qui donnent un résultat qui n'est pas forcément correct (soit faux avec faible probabilité, soit approché) mais dont le temps d'exécution est déterministe.

### A. Génération du hasard

### B. Algorithmes de *Las Vegas*

Un algorithme de *Las Vegas* est un algorithme probabiliste qui donne toujours un résultat exact. L'utilisation du hasard permet en général d'obtenir de meilleurs performances d'exécution.

#### Tri rapide probabiliste

On sait que dans le pire cas, c'est-à-dire par exemple quand l'entrée est déjà triée, le tri rapide utilise $O(n^2)$ compraisons.

On peut améliorer ce résultat en choisissant le pivot de manière aléatoire entre les indices $0$ et $n-1$. Cela permet d'obtenir un nombre de comparaisons de $O(n \log n)$ en moyenne.

Le résultat sera toujours un tableau trié mais les performances d'exécution ont été améliorées.

#### Sélection rapide (quick select)

Considérons un tableau de taille $n$ dans lequel on souhaite déterminer la $t$-ième plus grande valeur. Une manière de faire est de trier le tableau. Cependant, on sait qu'un tri par comparaisons effectuera au minimum $\Omega(n \log n)$ comparaisons dans le pire cas.

Hoare propose en 1961 l'algorithme probabiliste de type *Las Vegas* suivant :

1. Choisir une valeur $y$ au hasard dans le tableau
2. Comparer $y$ avec les $n-1$ autres valeurs en réorganisant le tableau pour avoir les valeurs plus petites de $y$ à gauche et les plus grandes à droite : à l'instar du tri rapide. $y$ finit en position d'indice $k$.
3. Si $k = t - 1$ retourner $y$
4. Si $k > t - 1$ chercher le $t$-ième élément du sous-tableau $T[0] \dots T[k-1]$ avec la même méthode
5. Si $k < t - 1$ chercher le $(t-k-1)$-ième élément du sous-tableau $T[k+1] \dots T[n-1]$ avec la même méthode.

L'analyse mathématique du nombre moyen de comparaisons est un peu technique : elle a été publiée 10 ans plus tard (toujours par Hoare). On peut par exemple montrer que le nombre moyen de comparaisons à effectuer  avec cet algorithme pour trouver la valeur médiane d'un ensemble de $n$ valeurs est de l'ordre de :

$$
(2 + 2 \ln 2) n
$$

C'est donc un temps linéaire ce qui est beaucoup plus efficace que de trier le tableau.
 
### C. Algorithmes de *Monte Carlo*


Un algorithme de *Monte Carlo* est un algorithme probabiliste qui s'exécute en un temps déterministe (qui ne dépend pas du hasard). Le résultat est soumis à une incertitude :
* soit il est approximatif
* soit il est parfois faux (on espère avec une faible probabilité)

Exemples : recuit simulé, tests de primalité, algorithme de Karger

#### Tester si un nombre est premier

L'algorithme naïf pour tester si $p$ est premier a une complexité $O(p)$. Cela est suffisant pour tester si un petit entier est premier, mais cela n'est pas adapté aux applications cryptographiques. Typiquement la taille des entiers utilisés en cryptographie est de l'ordre de 512 bits, ce qui représente 155 chiffres en base 10. Même si une itération de boucle pouvait s'effectuer en 1 nanoseconde, il faudrait de l'ordre de $10^{137}$ années pour vérifier si un entier de taille cryptographique est premier.

Pour résoudre ce problème on utilise des tests de primalité qui sont des algorithmes probabilistes. A titre d'exemple, on peut considérer le test de Fermat qui repose sur le petit théorème de Fermat :

!!! tip "Petit théorème de Fermat"
    Soit $p$ un nombre premier et $a$ un entier non divisible par $p$ alors $a^{p-1} \equiv 1 \, (\mathrm{mod}\  p)$.

L'algorithme probabiliste qui en découle est le suivant :

1. Choisir une entier $a$ qui vérifie $1 < a < p$.
2. Tester si $a^{p-1} \equiv 1 \, (\mathrm{mod}\ p)$
3. Si le test est vrai : répondre vrai
4. Si le test est faux : répondre faux

C'est bien un algorithme de *Monte Carlo* : le temps d'exécution ne dépend pas du hasard. De plus, si l'algorithme répond faux l'algorithme est correct. Si l'algorithme répond vrai il est possible qu'il se trompe (mais avec une faible probabilité). Rappelons en effet que le calcul de $a^{p-1} \, (\mathrm{mod}\ p)$ peut renvoyer $p$ valeurs possibles et que seule la valeur 1 est acceptée.
Un entier $p$ qui reussit ce test est dit *probablement premier*

Si on veut diminuer le risque d'erreur, on peut répéter ce test $k$ fois :

1. Choisir $k$ entiers aléatoires $a$ dans $]1, p[$
2. Tester si chaque $a$ vérifie $a^{p-1} \equiv 1 \, (\mathrm{mod}\ p)$
3. Dès qu'un test échoue : répondre faux
4. Si tous les tests réussissent : répndre vrai

Proposons une implémentation en langage `Python` de cette procédure. Nous utilisons exceptionnellement `Python` car il permet de pouvoir manipuler les grands entiers (> 64 bits) de manière native. On commence par implémenter le calcul de $a^n \, (\mathrm{mod}\ p)$ appelé *exponentiation modulaire* en utilisant l'algorithme d'*exponentiation rapide*. On implémente ensuite la procédure avec $k$ répétitions du test.

```python
# Calcul a^n modulo p
def mod_exp(a, n, p):
    if n == 0:
        return 1
    elif n == 1:
        return (a % p)
    elif (n % 2 == 0):
        return mod_exp((a * a) % p, n // 2, p)
    else:
        return (a * mod_exp((a * a) % p, n // 2, p)) % p

def test_de_fermat(p, k):
    # On itère k fois le test de fermat
    for _ in range(k):
        a = rd.randint(1, p-1)
        if mod_exp(a, p-1, p) != 1:
            return False
    return True

```

Aparté mathématique : si le nombre $p$ n'est pas premier et n'est pas un nombre de Carmichael (nombres très rares), alors il y a une probabilité $\leq 1/2$ que le test réussisse. Autrement dit si on répète le test $k$ fois comme on l'a fait, il y a une probabilité d'erreur inférieure à $1/2^k$.

Il existe des tests encore plus précis que celui de Fermat : Miller-Rabin, Solovay-Strassen.

#### Las Vegas + Monte Carlo : générer un nombre probablement premier de taille cryptographique

Pour générer un nombre premier de taille cryptographique, disons de 512 bits, on peut utiliser l'algorithme de type *Las Vegas* suivant :

1. Générer un nombre aléatoire $n$ impair de taille 512 bits
2. Tester avec un algorithme de Monte Carlo si $n$ est probablement premier
3. Si oui, retourner $n$
4. Si non, faire $n \gets n + 2$ et aller en 2

Ce type de procédure est aujourd'hui utilisé par les librairies cryptographiques telles que SSL (https).

Voici une implémentation en `Python` de cet algorithme qui permet de générer en moins d'une seconde un grand nombre premier :

```python

# Génère un nombre entier impair de 512 bits
def random_big_odd_int():
    n = 0
    for _ in range(511):
        n = 2 * n + rd.randint(0, 1)
    n = 2 * n + 1
    return n

# Génère un nombre premier de taille cryptographique
def big_prime():
    n = random_big_odd_int()
    echecs = 0
    while not(test_de_fermat(n, 10)):
           echecs += 1
           n += 2
    print("Echecs : ", echecs)
    return n
```

Dans le programme on a également affiché le nombre de tentatives infructueuses avant de trouver un nombre premier. On constate que le plus souvent, moins de 500 itérations suffisent.

Cela est expliqué par le fameux *Théorème des nombres premiers* qui nous dit que le nombre de nombres premiers inférieur à $x$, noté  $\pi(x)$ vérifie :

$$
\pi(x) \sim \frac{x}{\ln(x)}
$$

Ainsi, la probabilité qu'un entier aléatoire soit premier est de l'ordre de $\frac{1}{\ln(x)}$. Dans notre cas, on a environ $x = 2^{512}$ ce qui donne une probabilité de 0,28%. Les nombres premiers sont rares mais pas si rares ! Ainsi si on teste pour 500 entiers grands entiers s'ils sont premier, on en trouvera en moyenne 1,5, ce qui explique que notre procédure fonctionne en pratique.
 
## 2. Algorithmes d'approximation

### A. Problèmes de décision et d'optimisation

### B. Notion d'approximation

### C. Exemples
Glouton, probabiliste
