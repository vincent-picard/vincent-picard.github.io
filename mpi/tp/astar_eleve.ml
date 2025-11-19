type grille = int array array;;

Random.self_init ();;

let print_grille g = 
    let n = Array.length g in
    let m = Array.length g.(0) in
    for i = 0 to n-1 do 
        for j = 0 to m-1 do
            match g.(i).(j) with
            | 0 -> print_char ' '
            | 9 -> print_char '#'
            (* a completer pour les autres types de case *)
            | _ -> ()
        done;
        print_newline ()
    done
;;


(* Pour un affichage plus joli je propose ci dessous un code permettant
   l'export de la grille vers un fichier de type metapost *)

(* Pour compiler le metapost en pdf on utilise la commande : mptopdf fichier.mp *)

(* dimension : string representant la dimension d'une case
   en metapost par exemple "1cm", de même width est l'epaisseur
   des traits *)

let export_mp grille dimension width filename =
    let n = Array.length grille in
    let m = Array.length grille.(0) in
    try
        let oc = open_out filename in
        Printf.fprintf oc "beginfig(1)\n";
        Printf.fprintf oc "dim := %s ; \n" dimension;
        Printf.fprintf oc "w := %s ; \n" width;
        Printf.fprintf oc "n := %d ; \n" n;
        Printf.fprintf oc "m := %d ; \n" m;
        Printf.fprintf oc "color coulg; coulg := (black + 2white)/3 ; \n";
        Printf.fprintf oc "color coulo; coulo := black ; \n";
        Printf.fprintf oc "color coulsol; coulsol := (2green + black)/3 ; \n";
        Printf.fprintf oc "color coulnodes; coulnodes := blue ; \n";
        Printf.fprintf oc "pickup pencircle scaled w ; \n";
        
        Printf.fprintf oc "for i = 0 upto n : \n";
        Printf.fprintf oc "draw (0, i * dim) -- (m * dim, i * dim) withcolor coulg ; \n";
        Printf.fprintf oc "endfor \n";
        Printf.fprintf oc "for j = 0 upto m : \n";
        Printf.fprintf oc "draw (j * dim, 0) -- (j * dim, n * dim) withcolor coulg ; \n";
        Printf.fprintf oc "endfor \n";
        for i = 0 to n-1 do 
            for j = 0 to m-1 do
                match grille.(i).(j) with
                | 9 ->
                        begin
                            Printf.fprintf oc "fill unitsquare scaled dim shifted (%d * dim, (n - 1 - %d) * dim) withcolor coulo ; \n" j i
                        end
                | 1 ->  
                        begin
                            Printf.fprintf oc "draw fullcircle scaled 0.5dim shifted ((%d + 0.5) * dim, (n - 1 - %d + 0.5) * dim) withcolor coulnodes ; \n" j i
                        end 
                | 2 -> 
                        begin
                            Printf.fprintf oc "fill fullcircle scaled 0.5dim shifted ((%d + 0.5) * dim, (n - 1 - %d + 0.5) * dim) withcolor coulnodes ; \n" j i
                        end 
                | 5 ->
                        begin
                            Printf.fprintf oc "fill unitsquare scaled dim shifted (%d * dim, (n - 1 - %d) * dim) withcolor coulsol ; \n" j i
                        end
                | _ -> ()
            done;
        done;

        Printf.fprintf oc "endfig; \n";
        Printf.fprintf oc "end; \n";
        close_out oc
    with
    _ -> failwith "Erreur exportmp"
;;

let g = creer_grille 40 40 500;;

let p = (astar g);;
reconstruire g p;;

(* Sortie console *)
print_grille g;;
(* Sortie fichier *)
export_mp g "0.4cm" "1pt" "grille.mp";;
