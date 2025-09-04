# :book: Installer et utiliser les *man pages*

Les `man pages` (*Manual pages*) sont des pages de documentation accessibles depuis le terminal d'un système Linux (ou Mac, BSD, ... privé de Windows). On y trouve en particulier de la docimentation pour :

- Toutes les fonctions de la bibliothèque standard C (`stdlib`, `stdio`, `string`, etc).
- De la documentation sur les outils disponibles dans le terminal (`ls`, `pwd`, `cp`, etc).

## 1. Installation des *man pages*

Il est probable que les pages de manuels soient installées par défaut sur votre machine. Si ce n'est pas le cas il faut trouver et installer les bons paquets selon votre distribution Linux. Il existe aussi des paquets permettant une **traduction en français** :fr: de certaines pages manuel. Par exemple sous Debian ou Ubuntu vous pouvez installer les paquets :

=== "Debian / Ubuntu"

    ```sh
       >>> sudo apt install man-db manpages manpages-dev manpages-fr manpages-fr-dev
    ```

=== "Arch Linux"

    ```sh
       >>> sudo pacman -S man-db man-pages man-pages-fr
    ```

!!!warning
    Cette commande doit s'exécuter en mode administrateur d'où la présence de sudo. Ca sera la seule commande ici à utiliser avec sudo.


## 2. Lecture d'une page de manuel

Pour utiliser les *man pages* on invoque la commande `man` suivie du nom de la page à consulter. Par exemple :
```sh
    >>> man strcmp
```

Ceci affiche dans le terminal la page de manuel concernant la fonction `strcmp` de C. Chez moi cela affiche :
```
STRCMP(3)                                 Library Functions Manual                                STRCMP(3)

NAME
     strcmp, strncmp – compare strings

LIBRARY
     Standard C Library (libc, -lc)

SYNOPSIS
     #include <string.h>

     int
     strcmp(const char *s1, const char *s2);

     int
     strncmp(const char *s1, const char *s2, size_t n);

DESCRIPTION
     The strcmp() and strncmp() functions lexicographically compare the null-terminated strings s1 and s2.

     The strncmp() function compares not more than n characters.  Because strncmp() is designed for
     comparing strings rather than binary data, characters that appear after a ‘\0’ character are not
     compared.

RETURN VALUES
     The strcmp() and strncmp() functions return an integer greater than, equal to, or less than 0,
     according as the string s1 is greater than, equal to, or less than the string s2.  The comparison is
     done using unsigned characters, so that ‘\200’ is greater than ‘\0’.

SEE ALSO
     bcmp(3), memcmp(3), strcasecmp(3), strcoll(3), strxfrm(3), wcscmp(3)

STANDARDS
     The strcmp() and strncmp() functions conform to ISO/IEC 9899:1990 (“ISO C90”).
``` 

On y trouve de nombreuses informations utiles comme :

- La bibliothèque concernée (ici `libc`)
- Le fichier d'en-tête à include (`string.h`)
- Les prototypes des fonctions
- La description précise des fonctions et des valeur de retour
- Des exemples classiques d'utilisation
- D'autres fonctions proches (dans `SEE ALSO`)

### Navigation

Pour afficher la page de manuel dans le terminal, l'outil `man` fait appel au pager `less` qui n'est pas très intuitif la première fois. Voici quelques commandes de base pour s'y retrouver :

- `q` permet de quitter la page
- les touches fléchées permettent de se dépacer sur la page
- alternativement `j`/`k` permet de défiler bas/haut (comme dans `vi`)
- `g` va au début de la page
- `G` va à la fin de la page
- `/mot` suivi de la touche entrée permet de trouver localiser un mot dans la page (très utile), on appuie enseuite sur `n` pour passer d'une occurrence à la suivante


## 3. Organisation du manuel

Le manuel est organisé en différentes **sections** portant toutes un numéro. Les deux sections principalement utiles pour vous sont :

- Section 1 : commandes terminal
- Section 3 : fonctions des bibliothèques C

Sur toutes les pages manuel, le numéro de section est précisé entre parenthèses à côté du nom de la page, par exemple : `STRCMP(3)` dans l'exemple ci-dessus.

Parfois, un même nom de fonction peut être utilisé dans des contextes différents, par exemple `man printf` emmène sur la page `PRINTF(1)` qui correspond à la documentation de la commande `printf` du terminal (et pas du tout celle de la fonction `C`. Dans ce cas il faut préciser à `man` la section de manuel voulue :

```
    >>> man 3 printf
```

### Recherche d'une page

Si vous ne savez pas exactement le nom de la page qui vous intéresse, vous pouvez utiliser la commande `apropos` pour trouver les pages intéressantes. Par exemple, si je cherche des informations sur les `mutex` en C je tape :
```
    >>> apropos mutex
```
qui répond :
```
Mutex(3o)                - Locks for mutual exclusion
Stdlib.Mutex(3o)         - no description
gnutls_global_set_mutex(3) - API function
plockstat(1)             - front-end to DTrace to print statistics about POSIX mutexes and read/write locks
APR::ThreadMutex(3pm)    - Perl API for APR thread mutexes
Tcl_ConditionNotify(3tcl), Tcl_ConditionWait(3tcl), Tcl_ConditionFinalize(3tcl), Tcl_GetThreadData(3tcl), Tcl_MutexLock(3tcl), Tcl_MutexUnlock(3tcl), Tcl_MutexFinalize(3tcl), Tcl_CreateThread(3tcl), Tcl_JoinThread(3tcl) - Tcl thread support
plockstat(1)             - front-end to DTrace to print statistics about POSIX mutexes and read/write locks
pthread_mutex_destroy(3) - free resources allocated for a mutex
pthread_mutex_init(3)    - create a mutex
pthread_mutex_lock(3)    - lock a mutex
pthread_mutex_trylock(3) - attempt to lock a mutex without blocking
pthread_mutex_unlock(3)  - unlock a mutex
pthread_mutexattr_init(3), pthread_mutexattr_destroy(3), pthread_mutexattr_setprioceiling(3), pthread_mutexattr_getprioceiling(3), pthread_mutexattr_setprotocol(3), pthread_mutexattr_getprotocol(3), pthread_mutexattr_settype(3), pthread_mutexattr_gettype(3) - mutex attribute operations
```

On retrouve alors dans la liste, en section 3, toutes les pages concernant les fonctions de mutex utilisées dans le programme de MPI.
