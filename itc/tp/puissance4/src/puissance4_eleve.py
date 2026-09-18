import numpy as np

VIDE = 0
A = 1
B = 2

def est_libre(grille, j):
    pass

def coups_possibles(grille):
    pass

def est_final(grille):
    pass

def jouer(grille, joueur, j):
    pass

## Fonctions pour tester si un joueur a gagné

# Retourne true si le joueur indiqué a reussi a former une 4ligne
def ligne(grille, joueur):
    pass

# Retourne true si le joueur indiqué a reussi a former une 4colonne
def colonne(grille, joueur):
    pass

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
    pass

def gagne(grille, joueur):
    pass

def h1(grille):
    if gagne(grille, A):
        return +float('inf')
    elif gagne(grille, B):
        return -float('inf')
    else:
        return 0

def eval(grille, joueur, profondeur, heuristique):
    pass

def minmax(grille, joueur, profondeur, heuristique):
    pass


## Cellule à evaluer pour lancer le jeu

# Parametres globaux du jeu

grille = np.zeros([6,7], dtype='int')
joueur = A
profondeur = 3
heuristique = h1
joueurIA = False # mettre a True pour jouer contre la machine

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

