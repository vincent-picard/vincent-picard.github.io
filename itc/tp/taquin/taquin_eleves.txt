# Auteur : Vincent Picard <vincent.picard2@ac-reunion.fr>

import numpy as np

"""
Une position du jeu de taquin sera représentée par une matrice 3x3 codée
sous forme d'une liste de 3 listes (une liste par ligne).
"""

"""
Les deux fonctions ci-dessous servent à afficher joliment
une position du jeu de taquin. print_ligne est une fonction
auxilaire pour print_taquin. print_taquin est la fonction
à utiliser.
"""

def print_ligne(a, b, c):
    l = ""
    l += u'\u2551 ' + (str(a) if a != 0 else u'\u25C8') + ' '
    l += u'\u2551 ' + (str(b) if b != 0 else u'\u25C8') + ' '
    l += u'\u2551 ' + (str(c) if c != 0 else u'\u25C8') + ' '
    l += u'\u2551'
    print(l)

"""
Cette fonction prend en arguments une position de jeu de taquin
et l'affiche joliment à l'écran.
"""
def print_taquin(t):
    bord_haut = u'\u2554' + (u'\u2550' * 3 + u'\u2566') * 2 + u'\u2550' * 3 + u'\u2557'
    bord_bas = u'\u255A' + (u'\u2550' * 3 + u'\u2569') * 2 + u'\u2550' * 3 + u'\u255D'
    bord_int = u'\u2560' + (u'\u2550' * 3 + u'\u256C') * 2 + u'\u2550' * 3 + u'\u2563'
    print(bord_haut)
    print_ligne(t[0][0], t[0][1], t[0][2])
    print(bord_int)
    print_ligne(t[1][0], t[1][1], t[1][2])
    print(bord_int)
    print_ligne(t[2][0], t[2][1], t[2][2])
    print(bord_bas)


