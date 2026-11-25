type 'a abd =
  | Feuille of 'a
  | Noeud of int * ('a abd) * ('a abd)
;;

let log2 x = log x /. log 2.0;;

let enleve l x =
  List.filter (fun y -> not (y = x)) l
;;

(* Pour tester *)
let exemple = [
   [| false; true ; true  |];
   [| true ; true ; true  |];
   [| false; true ; false |];
   [| false; false; false |];
   [| true ; true ; true  |];
   [| true ; true ; true  |];
   [| false; true ; false |];
   [| false; false; false |]
 ];;

