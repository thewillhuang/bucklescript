let suites :  Mt.pair_suites ref  = ref []
let test_id = ref 0
let eq loc x y = 
  incr test_id ; 
  suites := 
    (loc ^" id " ^ (string_of_int !test_id), (fun _ -> Mt.Eq(x,y))) :: !suites

let b loc x  = 
  incr test_id ; 
  suites := 
    (loc ^" id " ^ (string_of_int !test_id), 
     (fun _ -> Mt.Ok x)) :: !suites

(* module N = Bs.LinkList     *)
module N = Bs.List
module A = Bs.Array 
module J = Js.Json 
let sum xs = 
  let v = ref 0 in 
  N.forEach xs (fun[@bs] x -> v := !v + x);
  !v 

let sum2 xs ys =   
  let v = ref 0 in 
  N.forEach2 xs ys (fun[@bs] x y -> v := !v + x  + y);
  !v 
let () = 
  let u = (N.makeBy 5 (fun[@bs] i -> i * i )) in 

  (* N.checkInvariantInternal u ; *)
  let f i = 
    eq __LOC__ (N.getExn u i) (i * i) in 
  for i = 0 to 4 do 
    f i 
  done ;
  eq __LOC__  (N.map u (fun [@bs] i -> i + 1)) [1;2;5;10;17]

let () =
  let (=~) = eq "FLATTEN" in 


  N.(concatMany
       [[1]; [2]; [3];[]; makeBy 4 (fun [@bs] i -> i )]
    ) =~
  [1;2;3; 0;1;2;3];
  N.concatMany [] =~ [];  
  N.concatMany [[];[]; [2]; [1];[2];[]] =~ [2;1;2]

let () = 
  eq __LOC__
    (N.
       (concat
          (makeBy 100 (fun [@bs] i -> i) )
          (makeBy 100 (fun [@bs] i -> i)))
     |> N.toArray
    )

    (A.
       (concat
          (makeBy 100 (fun [@bs] i -> i) )
          (makeBy 100 (fun [@bs] i -> i)))
    )
let () = 
  let (=~) = eq "APPEND" in 
  N.concat [1] [] =~ [1];
  N.concat [] [1] =~ [1]

let () =     
  let (=~) = eq "ZIP"   in 

  (N.zip [1;2;3] [3;4]) =~ [1,3; 2,4];
  N.zip [] [1] =~ [];
  N.zip [] [] =~ [];
  N.zip [1;2;3] [] =~ [] ;
  N.zip [1;2;3] [2;3;4] =~ [1,2;2,3;3,4]
let mod2 = (fun[@bs] x -> x mod 2 = 0) 
let () =   
  let (=~) = eq "PARTITION" in 

  (N.partition [1;2;3;2;3;4] mod2 )
  =~ ([2;2;4], [1;3;3]);
  (N.partition [2;2;2;4] mod2)
  =~ ([2;2;2;4], []);
  (N.partition  [2;2;2;4] (fun[@bs] x -> not (mod2 x [@bs] )))
  =~ ([], [2;2;2;4]);
  N.partition [] mod2 =~ ([], [])

let () =   
  let (=~) = eq "UNZIP" in 
  N.unzip [] =~ ([],[]) ; 
  N.unzip [1,2] =~ ([1] ,[2]);
  N.unzip [1,2;3,4] =~ ([1;3], [2;4])

let () = 
  let (=~) = eq "FILTER" in 
  N.keepBy [1;2;3;4] mod2 =~ [2;4];
  N.keepBy [1;3;41] mod2 =~ [];
  N.keepBy [] mod2 =~ [];
  N.keepBy  [2;2;2;4;6] mod2 =~ [2;2;2;4;6]
let id : int -> int [@bs] = fun [@bs] x -> x 

let () =   
  let (=~) = eq "MAP" in 
  N.map (N.makeBy 5 id )(fun [@bs] x -> x * 2 ) 
  =~ [0;2;4;6;8];
  N.map [] id  =~ [];
  N.map [1] (fun [@bs] x-> -x)  =~ [-1]
let add = (fun [@bs] a b -> a + b)
let length_10_id = N.makeBy 10 id  
let length_8_id = N.makeBy 8 id 
let () = 
  let (=~) = eq "MAP2" in   
  let b = length_10_id in
  let c = length_8_id in 
  let d = N.makeBy 10 (fun [@bs] x -> 2 * x ) in     
  let map2_add x y = N.zipBy  x y add in 
  map2_add length_10_id b =~ d ;
  map2_add [] [1] =~ [];
  map2_add [1] [] =~ [];
  map2_add [] [] =~ [];
  map2_add length_10_id b =~  N.(concat (map c (fun[@bs] x -> x * 2)) [16;18]);
  map2_add length_10_id length_8_id =~
  N.(mapWithIndex length_8_id (fun [@bs] i x -> i + x ) );
  N.reverse (N.mapReverse2 length_10_id length_10_id add) 
  =~ N.map length_10_id (fun [@bs] x -> x * 2);
  let xs = (N.reverse (N.mapReverse2 length_8_id length_10_id add)) in 
  eq __LOC__ (N.length xs) 8;
  xs =~ (N.zipBy length_10_id length_8_id add)

let () =   
  let (=~) = eq "TAKE" in 
  N.take [1;2;3] 2 =~ Some [1;2];
  N.take [] 1 =~ None;
  N.take [1;2] 3 =~ None ; 
  N.take [1;2] 2 =~ Some [1;2];
  N.take length_10_id 8 =~ Some length_8_id ;
  N.take length_10_id 0 =~ Some [];
  N.take length_8_id (-2) =~ None 

let () =   
  let (=~) = eq "DROP" in 
  N.drop length_10_id 10 =~ Some [];
  N.drop length_10_id 8 =~ Some [8;9];
  N.drop length_10_id 0 =~ Some length_10_id ;
  N.drop length_8_id (-1) =~ None

let () = 
  let (=~) = eq "SPLIT" in 
  let a = N.makeBy 5 id in 
  N.splitAt [] 1 =~ None;
  N.splitAt a 6 =~ None;
  N.splitAt a 5 =~ Some (a,[]);
  N.splitAt a 4 =~ Some ([0;1;2;3],[4]);
  N.splitAt a 3 =~ Some ([0;1;2],[3;4]);
  N.splitAt a 2 =~ Some ([0;1],[2;3;4]);
  N.splitAt a 1 =~ Some ([0],[1;2;3;4]);
  N.splitAt a 0 =~ Some ([],a);
  N.splitAt a (-1) =~ None
let succx =   (fun[@bs] x -> x + 1)

let () = 
  let (=~) = eq "REMOVEASSOQ" in 
  let eq = fun [@bs] x y -> (x : int) = y in 
  N.removeAssocByReference [1,"1";2,"2"; 3,"3"] 3 =~ [1,"1";2,"2"];
  N.removeAssocByReference [1,"1";2,"2"; 3,"3"] 1 =~ [2,"2"; 3,"3"];
  N.removeAssocByReference [1,"1";2,"2"; 3,"3"] 2 =~ [1,"1"; 3,"3"];
  N.removeAssocByReference [1,"1";2,"2"; 3,"3"] 0 =~ [1,"1"; 2,"2"; 3,"3"];

  N.removeAssoc [1,"1";2,"2"; 3,"3"] 3 eq =~ [1,"1";2,"2"];
  N.removeAssoc [1,"1";2,"2"; 3,"3"] 1 eq =~ [2,"2"; 3,"3"];
  N.removeAssoc [1,"1";2,"2"; 3,"3"] 2 eq =~ [1,"1"; 3,"3"];
  N.removeAssoc [1,"1";2,"2"; 3,"3"] 0 eq =~ [1,"1"; 2,"2"; 3,"3"]
  
let ()   = 

  eq __LOC__ N.(head length_10_id, tail length_10_id)  (Some 0, N.drop length_10_id 1);
  eq __LOC__ (N.head [])  None ;
  N.forEachWithIndex length_10_id (fun[@bs] i x ->
      eq __LOC__ (N.get length_10_id i) (Some x));     
  eq __LOC__ (N.tail [])  None ; 
  eq __LOC__ (N.drop [] 3) None ; 
  eq __LOC__ (N.mapWithIndex [] (fun [@bs] i x -> i + x)) [];
  eq __LOC__ (N.get  length_10_id (-1) ) None; 
  eq __LOC__ (N.get  length_10_id 12 ) None;
  eq __LOC__ (sum []) 0;
  eq __LOC__ (sum length_10_id) 45;
  eq __LOC__ (N.makeBy 0 id) [];
  eq __LOC__ (N.(reverse (reverse length_10_id)))  length_10_id ; 
  eq __LOC__ (N.(reverse (reverse length_8_id)))  length_8_id ;
  eq __LOC__ (N.reverse []) [];
  eq __LOC__ 
    (N.reverse (N.mapReverse length_10_id succx))
    (N.map length_10_id succx  );
  eq __LOC__
    (N.reduce length_10_id 0 add) 45;
  eq __LOC__
    (N.reduceReverse length_10_id 0 add) 45;
  (* eq __LOC__ 
     (N.mapRev2 length_10_id length_8_id add ) *)
  eq __LOC__ (sum2 length_10_id length_10_id) 90;
  eq __LOC__ (sum2 length_8_id length_10_id) 56;
  eq __LOC__ (N.reduce2 length_10_id length_8_id 0 
                (fun [@bs] acc x y -> acc + x + y)) 56;
  eq __LOC__ (N.reduceReverse2 length_10_id length_8_id 0 
                (fun [@bs] acc x y -> acc + x + y)) 56;                
  eq __LOC__ (N.reduceReverse2 length_10_id length_10_id 0 
                (fun [@bs] acc x y -> acc + x + y)) 90;
  eq __LOC__ (N.every [2;4;6] mod2) true;
  eq __LOC__ (N.every [1] mod2) false;
  eq __LOC__ (N.every [] mod2) true;
  eq __LOC__ (N.some [1;2;5] mod2)  true;
  eq __LOC__ (N.some [1;3;5] mod2)  false;
  eq __LOC__ (N.some [] mod2)  false;
  eq __LOC__ (N.every2 [] [1] (fun [@bs] x y -> x > y)) true;  
  eq __LOC__ (N.every2 [2] [1] (fun [@bs] x y -> x > y)) true;
  eq __LOC__ (N.every2 [2;3] [1;4] (fun [@bs] x y -> x > y)) false;
  eq __LOC__ (N.some2 [] [1] (fun [@bs] x y -> x > y)) false;
  eq __LOC__ (N.some2 [2;3] [1;4] (fun [@bs] x y -> x > y)) true;
  eq __LOC__ (N.some2 [0;3] [1;4] (fun [@bs] x y -> x > y)) false;
  eq __LOC__ (N.has [1;2;3] "2" (fun [@bs] x s -> string_of_int x = s)) true;
  eq __LOC__ (N.has [1;2;3] "0" (fun [@bs] x s -> string_of_int x = s)) false

let makeTest n =  
  eq __LOC__ (N.make n 3) (N.makeBy n (fun[@bs] _ -> 3))

let () =   
  makeTest 0;
  makeTest 1;
  makeTest 2;
  makeTest 3

let () = 
  let u0 = N.makeBy 20 (fun[@bs] x -> x) in   
  let u1 = N.keepMap u0 (fun [@bs] x -> if x mod 7 = 0 then Some (x+1) else None) in 
  eq __LOC__ u1 [1;8;15]

;; Mt.from_pair_suites __FILE__ !suites
