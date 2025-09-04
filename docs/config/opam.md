# :camel: Installer et configurer `opam`

`Opam` (*OCaml package manager*) est un gestionnaire de paquets pour OCaml. Il permet automatiquement de télécharger, compiler et installer un environnement de développement (interprètes, compilateurs, outils, bibliothèques...) pour OCaml.

Même si la plupart des distributions Linux intègrent des paquets pour installer OCaml, je recommande fortement d'utiliser Opam pour installer OCaml (et compagnie) sur vos ordinateurs pour bénéficier des avantages suivants :

- Installation aisée des outils ('dune', 'menhir', etc)
- Installation aisée des bibliothèques OCaml
- Installation du serveur LSP pour OCaml (Aides pour la programmation dans VSCode)
- Tous les outils sont compilés sur votre machine à partir du code source OCaml (ce qui est cool)

## 1. Installation de Opam

Premièrement Opam doit être installé sur votre ordinateur. En général, les distributions Linux proposent Opam dans leurs paquets, par exemple sous Debian ou Ubuntu vous pouvez l'installer avec :

=== "Debian / Ubuntu"

    ```sh
       >>> sudo apt install opam
    ```

=== "Arch Linux"

    ```sh
       >>> sudo pacman -S opam
    ```

!!!warning
    Cette commande doit s'exécuter en mode administrateur d'où la présence de sudo. Ca sera la seule commande à utiliser avec sudo.


## 2. Initialisation de Opam

Opam installe ses éléments dans un répertoire caché `.opam` de votre répertoire utilisateur : cela permet à chaque utilisateur d'avoir sa configuration propre, cela permet aussi d'installer tous les outils et bibliothèques utiles sans polluer son système et sans avoir besoin de disposer des droits administrateurs. Exécutez simplement :

```sh
    >>> opam init
```

Cette commande télécharge et copile automatiquement une suite basique d'outils pour commencer à faire du OCaml. Au cours de cette procédure `opam` vous posera la question suivante :
```
  In normal operation, opam only alters files within ~/.opam.

  However, to best integrate with your system, some environment variables
  should be set. If you allow it to, this initialisation step will update
  your zsh configuration by adding the following line to ~/.zshrc:

    [[ ! -r '/Users/vincent/.opam/opam-init/init.zsh' ]] || source '/Users/vincent/.opam/opam-init/init.zsh' > /dev/null 2> /dev/null

  Otherwise, every time you want to access your opam installation, you will
  need to run:

    eval $(opam env)

  You can always re-run this setup with 'opam init' later.

Do you want opam to configure zsh?
> 1. Yes, update ~/.zshrc
  2. Yes, but don't setup any hooks. You'll have to run eval $(opam env)
     whenever you change your current 'opam switch'
  3. Select a different shell
  4. Specify another config file to update instead
  5. No, I'll remember to run eval $(opam env) when I need opam
```

Ce message peut varier selon le programme shell que vous utilisez. Opam explique simplement qu'il faut configurer le shell pour qu'il puisse trouver les outils OCaml installés dans votre répertoire `.opam`. Cette configuration dépend du shell utilisé. Personnellement j'utilise le shell `zsh` donc opam me propose de modifier le fichier de configuration de ce shell `.zshrc`. Répondez simplement `1` à la question pour laiser opam configurer votre shell.

Ensuite laissez opam travailler, cela peut prendre du temps :
```sh
    <><> Processing actions <><><><><><><><><><><><><><><><><><><><><><><><><><>  🐫
∗ installed base-bigarray.base
∗ installed base-threads.base
∗ installed base-unix.base
∗ installed ocaml-options-vanilla.1
⬇ retrieved ocaml-config.3  (2 extra sources)
⬇ retrieved ocaml-config.3  (2 extra sources)
⬇ retrieved ocaml-compiler.5.3.0  (https://opam.ocaml.org/cache)
Processing 20/33: [ocaml-compiler: make]
```
(opam est en train de télécharger les composants, et actuellement il est train de compiler mon compilateur ocaml)

Une fois l'installation terminée, **redémarrez l'ordinateur** (ou au moins relogguez vous) et vérifiez que tout s'est bien installé :

```sh
   >>> opam switch
#  switch   compiler                                           description
→  default  ocaml-base-compiler.5.3.0,ocaml-options-vanilla.1  ocaml >= 4.05.0
```

Opam m'indique qu'il a installé une version par défaut, qui correspond à OCaml version 5.3.

On peut aussi vérifier que l'exécutable est bien disponible au bon endroit :
```sh
    >>> whereis ocaml
ocaml: /Users/vincent/.opam/default/bin/ocaml /Users/vincent/.opam/default/man/man1/ocaml.1
```

## 3. Mise à jour d'une configuration Opam

De temps en temps, vous pouvez taper les deux commandes suivantes pour mettre à jour votre opam et l'installation actuelle.

- **Mettre à jour la liste des composants disponibles :**
```
    >>> opam update
```
- **Effectuer les mises à jour disponibles :**
```
    >>> opam upgrade
```

## 4. Installation de nouveaux composants

Par défaut opam installe uniquement un ensemble minimal de paquets de base pour faire du ocaml. Vous pouvez lister les paquets installés ainsi :

```sh
    >>> opam list
# Packages matching: installed
# Name                # Installed # Synopsis
base-bigarray         base
base-domains          base
base-effects          base
base-nnp              base        Naked pointers prohibited in the OCaml heap
base-threads          base
base-unix             base
ocaml                 5.3.0       The OCaml compiler (virtual package)
ocaml-base-compiler   5.3.0       Official release of OCaml 5.3.0
ocaml-compiler        5.3.0       Official release of OCaml 5.3.0
ocaml-config          3           OCaml Switch Configuration
ocaml-options-vanilla 1           Ensure that OCaml is compiled with no special
```

Pour installer de nouveaux composants on utilise la commande :
```sh
    >>> opam install (liste de composants)
```

### Paquets recommandés

**Je vous recommande d'installer les composants suivants :**
```sh
    >>> opam install utop ocaml-lsp-server dune menhir
```

- **utop** : est un interprète OCaml un peu plus confortable d'utilisation que l'interprète de base `ocaml`
- **ocaml-lsp-server** : permet à des éditeurs tels que VSCode de *comprendre* le langage OCaml et de vous proposer des fonctionnalités avancées (par exemple afficher les types)
- **dune** : un système pour compiler facilement les projets OCaml (compilation séparée)
- **menhir** : un analyseur syntaxique permettant d'écrire facilement des parseurs

A l'exécution de la commande `opam install` opam déterminera toutes les dépendances de paquets nécessaires et vous proposera de tout installer. Il faut répondre oui (`y`).

### Recherche de bibliothèques

Si vous êtes à la recherche d'une bibliothèque OCaml spécifique, vous pouvez utiliser la commande `opam search` pour déterminer quel paquet installer. Par exemple, si je souhaite disposer d'une bibliothèque permettant de travailler avec des *expressions regulières*, je peux taper :
```sh
    >>> opam search regular expression
# Packages matching: match(*regular*) & match(*expression*)
# Name         # Installed # Synopsis
expect         --          Simple implementation of 'expect' to help building unitary testing of interactive
grenier        --          A collection of various algorithms in OCaml
humane-re      --          A human friendly interface to regular expressions in OCaml
iri            --          IRI (RFC3987) native OCaml implementation
mparser-pcre   --          MParser plugin: PCRE-based regular expressions
mparser-re     --          MParser plugin: RE-based regular expressions
ocamlregextkit --          A regular expression toolkit for OCaml
oniguruma      --          Bindings to the Oniguruma regular expression library
pcre           --          Bindings to the Perl Compatibility Regular Expressions library
pcre2          --          Bindings to the Perl Compatibility Regular Expressions library (version 2)
ppx_regexp     --          Matching Regular Expressions with OCaml Patterns
ppx_tyre       --          PPX syntax for tyre regular expressions and routes
re             1.13.2      RE is a regular expression library for OCaml
re2            --          OCaml bindings for RE2, Google's regular expression library
re_parser      --          Typed parsing using regular expressions.
regenerate     --          Regenerate is a tool to generate test-cases for regular expression engines
text           --          Library for dealing with "text", i.e. sequence of unicode characters, in a conveni
tyre           --          Typed Regular Expressions
zed            3.2.3       Abstract engine for text edition in OCaml
```
Opam répond par une proposition de paquets correspodant à la recherche. On voit ici que `re` semble être la bibliothèque adaptée et qu'elle est *déjà* installée (en version 1.13.2) : il n'y a donc rien à faire. Sinon il faut installer le paquet voulu avec `opam install`.


## 5. Désinstallation

Si vous voulez désinstaller OCaml et repartir de zéro, supprimez simplement votre répertoire '.opam' :


```sh
    >>> rm -rf ~/.opam
```
