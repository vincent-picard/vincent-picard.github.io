(* PARTIE 1 *)
(* Codage des possibilites d'une case *)

(* marque un chiffre possibile *)
let ajoute chiffre code =
  code lor (1 lsl chiffre)
;;

let enleve chiffre code =
  code land (lnot (1 lsl chiffre))
;;
  
(* Rq : un List.fold_left est possible ici *)
let encode liste =
  let rec aux accu = function
    | [] -> accu
    | t::q -> aux (ajoute t accu) q
  in
  aux 0 liste
;;

let decode code =
  let rec aux chiffre_actuel code =
    if code = 0 then
      []
    else if code mod 2 = 1 then
      chiffre_actuel::(aux (chiffre_actuel + 1) (code lsr 1))
    else
      aux (chiffre_actuel + 1) (code lsr 1)
  in
  aux 1 (code lsr 1)
;;

let rec taille code =
  if code = 0 then
    0
  else
    (code mod 2) + taille (code lsr 1)
;;

let all = encode [1; 2; 3; 4; 5; 6; 7; 8; 9];;
let none = encode [];;

let test = enleve 4 all;;

decode all;;
decode test;;

(* PARTIE 2 *)
(* Regles du jeu *)

type grille = int array array;;

let diabolique = [|
    [| 5; -1; -1; -1; 8; -1; -1; -1; -1 |];
    [| 1; -1; 9; -1; -1; -1; -1; -1; -1 |];
    [| 2; -1; -1; -1; -1; 4; -1; 8; -1 |];
    [| 9; -1; 4; -1; -1; 6; 8; -1; -1; |];
    [| -1; -1; -1; 9; -1; -1; -1; -1; 4 |];
    [| -1; 2; -1; -1; -1; 7; -1; -1; -1 |];
    [| 8; -1; -1; 7; -1; -1; 9; -1; -1 |];
    [| -1; 6; -1; -1; -1; -1; -1; -1; -1 |];
    [| -1; -1; 7; 1; 5; -1; 6; -1; 2 |]
  |];;

let print_sudoku s =
  let print_ligne () =
    for k = 1 to 37 do
      print_char '-'
    done;
    print_newline ();
  in
  print_ligne ();
  for i = 0 to 8 do
    print_string "| ";
    for j = 0 to 8 do
      if s.(i).(j) = -1 then
        print_char '?'
      else
        print_int s.(i).(j)
    ;
      print_string " | "
    done;
    print_newline ();
    print_ligne ()
  done
;;

let nb_cases_vides sudoku =
  let c = ref 0 in
  for i = 0 to 8 do
    for j = 0 to 8 do
      if sudoku.(i).(j) = -1 then
        incr c
    done
  done;
  !c
;;

let ajoute_grille grille (i, j) chiffre =
  (* On enleve le chiffre comme possible pour toutes les autres
     cases de la ligne i (sauf la cases (i, j)) *)
  for k = 0 to 8 do
    if not (k = j) then
      grille.(i).(k) <- enleve chiffre grille.(i).(k)
  done;
  (* Meme chose pour la colonne j *)
  for k = 0 to 8 do
    if not (k = i) then
      grille.(k).(j) <- enleve chiffre grille.(k).(j)
  done;

  (* on repere la case en bas a gauche du sous-carre
     concerne *)
  let (p, q) = (i / 3 * 3, j / 3 * 3) in

  (* On enleve la possibilite chiffre dans le sous carre *)
  for a = 0 to 2 do
    for b = 0 to 2 do
      let (k, l) = (p + a, q + b) in
      if not (k = i && l = j) then
        grille.(k).(l) <- enleve chiffre grille.(k).(l)
    done
  done;
  (* enfin on note que la case (i, j) n'a qu'une possibilite *)
  grille.(i).(j) <- encode [chiffre]
;;

let make_grille_possibilites sudoku =
  let p = Array.make_matrix 9 9 1022 in
  for i = 0 to 8 do
    for j = 0 to 8 do
      if not (sudoku.(i).(j) = -1) then
         ajoute_grille p (i, j) sudoku.(i).(j)
    done;
  done;
  p
;;

(* PARTIE 3 - Resolution *)
(* Backtracking *)

let casepluscontrainte sudoku possibles =
  let res = ref (-1, -1) in
  let taille_min = ref 10 in
  for i = 0 to 8 do
    for j = 0 to 8 do
      if (sudoku.(i).(j) = -1) then
        let t = taille possibles.(i).(j) in
        if 0 <= t && t < !taille_min then
          (res := (i, j);
           taille_min := t)
    done
  done;
  !res
;;
      
let grille_copy m =
  let mnew = Array.make_matrix 9 9 0 in
  for i = 0 to 8 do
    for j = 0 to 8 do
      mnew.(i).(j) <- m.(i).(j)
    done
  done;
  mnew
;;

exception Impossible;;

let rec btresolution sudoku possibles r =
  if r = 0 then
    sudoku
  else
    let (i, j) = casepluscontrainte sudoku possibles in
    if (i, j) = (-1, -1) then
      raise Impossible
    else
      let listechiffres = decode possibles.(i).(j) in
      
      let essaye_chiffre k =
        let newsudoku = grille_copy sudoku in
        let newpossibles = grille_copy possibles in
        ajoute_grille newpossibles (i, j) k;
        newsudoku.(i).(j) <- k;
        btresolution newsudoku newpossibles (r - 1)
      in
      
      let rec aux chiffres = match chiffres with
        | [] -> raise Impossible
        | t::q ->
           begin
             try
               essaye_chiffre t
             with
             | Impossible -> aux q
           end
      in
      aux listechiffres
;;

let solve sudoku =
  let possibilites = make_grille_possibilites sudoku in
  let r = nb_cases_vides sudoku in
  let sol = btresolution sudoku possibilites r in
  sol
;;

let diabolique = [|
    [| 5; -1; -1; -1; 8; -1; -1; -1; -1 |];
    [| 1; -1; 9; -1; -1; -1; -1; -1; -1 |];
    [| 2; -1; -1; -1; -1; 4; -1; 8; -1 |];
    [| 9; -1; 4; -1; -1; 6; 8; -1; -1; |];
    [| -1; -1; -1; 9; -1; -1; -1; -1; 4 |];
    [| -1; 2; -1; -1; -1; 7; -1; -1; -1 |];
    [| 8; -1; -1; 7; -1; -1; 9; -1; -1 |];
    [| -1; 6; -1; -1; -1; -1; -1; -1; -1 |];
    [| -1; -1; 7; 1; 5; -1; 6; -1; 2 |]
  |];;

print_sudoku diabolique;;
print_sudoku (solve diabolique);;

let antibt = [|
    [| -1; -1; -1; -1; -1; -1; -1; -1; -1|];
    [| -1; -1; -1; -1; -1; 3; -1; 8; 5 |];
    [| -1; -1; 1; -1; 2; -1; -1; -1; -1|];
    [| -1; -1; -1; 5; -1; 7; -1; -1; -1|];
    [| -1; -1; 4; -1; -1; -1; 1; -1; -1|];
    [| -1; 9; -1; -1; -1; -1; -1; -1; -1|];
    [| 5; -1; -1; -1; -1; -1; -1; 7; 3|];
    [| -1; -1; 2; -1; 1; -1; -1; -1; -1|];
    [| -1; -1; -1; -1; 4; -1; -1; -1; 9|]
  |]
;;

print_sudoku antibt;;
print_sudoku (solve antibt);;
