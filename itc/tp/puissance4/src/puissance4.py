import numpy as np

VIDE = 0
A = 1
B = 2

def est_libre(grille, j):
    return grille[0][j] == VIDE

def coups_possibles(grille):
    coups = []
    for j in range(7):
        if est_libre(grille, j):
            coups.append(j)
    return coups

def est_final(grille):
    return coups_possibles(grille) == []

def jouer(grille, joueur, j):
    assert(est_libre(grille, j))
    
    i = 5
    while (grille[i][j] != VIDE):
        i -= 1
    grille[i][j] = joueur

## Fonctions pour tester si un joueur a gagné

# Retourne true si le joueur indiqué a reussi a former une 4ligne
def ligne(grille, joueur):
    for i in range(6):
        for j in range(4):
            if (grille[i][j] == joueur
                and grille[i][j+1] == joueur
                and grille[i][j+2] == joueur
                and grille[i][j+3] == joueur
                ):
                return True
    return False

# Retourne true si le joueur indiqué a reussi a former une 4colonne
def colonne(grille, joueur):
    for i in range(3):
        for j in range(7):
            if (grille[i][j] == joueur
                and grille[i+1][j] == joueur
                and grille[i+2][j] == joueur
                and grille[i+3][j] == joueur
                ):
                return True
    return False


def diagonale1(grille, joueur):
    for i in range(3):
        for j in range(4):
            if (grille[i][j] == joueur
                and grille[i+1][j+1] == joueur
                and grille[i+2][j+2] == joueur
                and grille[i+3][j+3] == joueur
                ):
                return True
    return False

def diagonale2(grille, joueur):
    for i in range(3,6):
        for j in range(4):
            if (grille[i][j] == joueur
                and grille[i-1][j+1] == joueur
                and grille[i-2][j+2] == joueur
                and grille[i-3][j+3] == joueur
                ):
                return True
    return False

def gagne(grille, joueur):
    return (ligne(grille, joueur)
            or colonne(grille, joueur)
            or diagonale1(grille, joueur)
            or diagonale2(grille, joueur)
            )

def h1(grille):
    if gagne(grille, A):
        return +float('inf')
    elif gagne(grille, B):
        return -float('inf')
    else:
        return 0

#Fonction heuristique améliorée, on regarde tous les alignements de 4 cases,
#si le joueur peut former un alignement (l'adversaire n'a rien placé à cet endroit)
#alors on compte :
# 1 s'il a placé 1 jeton
# 3 s'il a placé 2 jetons
# 6 s'il a placé 3 jetons

def tous_les_alignements():
    l = []
    # lignes 
    for i in range(6):
        for j in range(4):
            l.append([(i, j), (i, j+1), (i, j+2), (i, j+3)])
    # colonnes
    for i in range(3):
        for j in range(7):
            l.append([(i,j), (i+1, j), (i+2, j), (i+3, j)])
    # diag1
    for i in range(3):
        for j in range(4):
            l.append([(i,j), (i+1,j+1), (i+2, j+2), (i+3, j+3)])
    # diag 2
    for i in range(3,6):
        for j in range(4):
            l.append([(i,j), (i-1,j+1), (i-2, j+2), (i-3, j+3)])
    return l

align = tous_les_alignements()

def score(grille, joueur):
    s = 0
    for a in align:
        compte = 0
        for c in a:
            if (grille[c[0]][c[1]] == joueur):
                compte += 1
            elif (grille[c[0]][c[1]] != VIDE):
                compte += -100
            if compte == 1:
                s += 1
            elif compte == 2:
                s += 3
            elif compte == 3:
                s += 6
    return s

def h2(grille):
    if gagne(grille, A):
        return +float('inf')
    if gagne(grille, B):
        return -float('inf')
    return score(grille, A) - score(grille, B)

def eval(grille, joueur, profondeur, heuristique):
    coups = coups_possibles(grille)
    if profondeur==0 or coups == []:
        return heuristique(grille)
    if joueur == A:
        max_eval = -float('inf')
        for c in coups:
            ng = grille.copy()
            jouer(ng, joueur, c)
            e = eval(ng, B, profondeur-1, heuristique)
            if e > max_eval:
                max_eval = e
        return max_eval
    if joueur == B:
        min_eval = +float('inf')
        for c in coups:
            ng = grille.copy()
            jouer(ng, joueur, c)
            e = eval(ng, A, profondeur-1, heuristique)
            if e < min_eval:
                min_eval = e
        return min_eval
            
def minmax(grille, joueur, profondeur, heuristique):
    coups = coups_possibles(grille)
    if profondeur==0 or coups == []:
        return (heuristique(grille), None)
    if joueur == A:
        max_eval = -float('inf')
        best = None
        for c in coups:
            ng = grille.copy()
            jouer(ng, joueur, c)
            (e, z) = minmax(ng, B, profondeur-1, heuristique)
            if e >= max_eval:
                max_eval = e
                best = c
        return (max_eval, best)
    if joueur == B:
        min_eval = +float('inf')
        best = None
        for c in coups:
            ng = grille.copy()
            jouer(ng, joueur, c)
            (e, z) = minmax(ng, A, profondeur-1, heuristique)
            if e <= min_eval:
                min_eval = e
                best = c
        return (min_eval, best)

## Parametres globaux du jeu

grille = np.zeros([6,7], dtype='int')
joueur = A
profondeur = 4
heuristique = h2
joueurIA = True # mettre a True pour jouer contre la machine

# NE PAS MODIFIER TOUT CE QUI SUIT
from tkinter import *
import tkinter.messagebox as tkmsg

root = Tk()
root.title('Puissance 4')

can = Canvas(root, width=50*7+10*8, height=50*6+10*7, bg='blue')
can.pack()

gg = [[can.create_oval(10+j*60,10+i*60,10+j*60+50,10+i*60+50,outline='black',fill='white',activedash=1) for j in range(7)] for i in range(6)]

def gui_show_grille(g):
    for i in range(6):
        for j in range(7):
            if g[i][j] == VIDE:
                c = 'white'
            elif g[i][j] == A:
                c = 'red'
            elif g[i][j] == B:
                c = 'yellow'
            else:
                c = 'black'
            can.itemconfig(gg[i][j], fill=c)
    print("h2 : ", h2(grille))

fchoix = Frame(root,height=50, width=370,bg='magenta')
fchoix.pack()

def gui_newgame():
    global grille, joueur
    grille = np.zeros([6,7], dtype='int')
    joueur = A
    gui_show_grille(grille)

def gui_jouer(j):
    global joueur
    if est_libre(grille, j):
        print("Coup joué : ", j)
        jouer(grille, joueur, j)
        gui_show_grille(grille)
        if gagne(grille,joueur):
            print("Le joueur ", joueur, " a remporté la partie !")
            tkmsg.showinfo("Fin de partie", "Le joueur " + str(joueur) + " a remporté la partie !")
            gui_newgame()
        else:
            if est_final(grille):
                print("Partie nulle")
                tkmsg.showinfo("Fin de partie", "Partie nulle !")
                gui_newgame()
            else :
                if joueur==A:
                    joueur=B
                    if joueurIA:
                        (eval, guess) = minmax(grille, joueur, profondeur,heuristique=heuristique)
                        print("J'évalue la partie à ", eval)
                        gui_jouer(guess)
                else:
                    joueur=A
                #(eval, guess) = minmax(grille, joueur, profondeur,heuristique=heuristique)
                #print("Evaluation : ", eval, " Coup proposé : ", guess)

    else:
        print("Coup interdit : ", j)
        tkmsg.showerror("Coup illégal", "La colonne "+str(j)+ " est pleine")

for j in range(7):
    b = Button(fchoix, text=str(j),width=4, command = (lambda j=j : gui_jouer(j)))
    b.grid(column=j,row=0)

qb = Button(root, text='Quitter', command=root.quit)
qb.pack()


root.mainloop()

