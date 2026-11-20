(* Auteur : Vincent Picard <vincent.picard1@ac-lyon.fr> *)


let u0 = 42;;


(*
Une position du jeu de taquin sera représentée par une matrice 3x3 codée
sous forme d'une liste de 3 listes (une liste par ligne).
*)

type taquin = int array array;;

(*
Les deux fonctions ci-dessous servent à afficher joliment
une position du jeu de taquin. print_ligne est une fonction
auxilaire pour print_taquin. print_taquin est la fonction
à utiliser.
*)

let print_ligne a b c =
    let l = "" in
    let l = l ^ ("| " ^ (if a = 0 then "*" else string_of_int a) ^ " ") in
    let l = l ^ ("| " ^ (if b = 0 then "*" else string_of_int b) ^ " ") in
    let l = l ^ ("| " ^ (if c = 0 then "*" else string_of_int c) ^ " ") in
    let l = l ^ "|\n" in
    print_string l
;;

(*
Cette fonction prend en arguments une position de jeu de taquin
et l'affiche joliment à l'écran.
*)
let print_taquin t =
    let bord = "+---+---+---+\n" in
    print_string bord;
    print_ligne t.(0).(0) t.(0).(1) t.(0).(2);
    print_string bord;
    print_ligne t.(1).(0) t.(1).(1) t.(1).(2);
    print_string bord;
    print_ligne t.(2).(0) t.(2).(1) t.(2).(2);
    print_string bord
;;

let test = Array.make_matrix 3 3 0;;
test.(2).(2) <- 5;;
test.(0).(1) <- 4;;
print_taquin test;;


