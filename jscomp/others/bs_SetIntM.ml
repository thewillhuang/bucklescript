# 2 "setm.cppo.ml"
module I = Bs_internalSetInt
module S = Bs_SortArrayInt
# 10
module N = Bs_internalAVLset
module A = Bs_Array 

type elt = I.elt


type t = {
  mutable data : I.t
} [@@bs.deriving abstract]



let rec remove0 nt (x : elt)= 
  let k = N.key nt in 
  if x = k then 
    let l,r = N.(left nt, right nt) in       
    match N.(toOpt l, toOpt r) with 
    | None, _ -> r 
    | _, None -> l 
    | Some _,  Some nr ->  
      N.rightSet nt (N.removeMinAuxWithRootMutate nt nr);
      N.return (N.balMutate nt)
  else 
    begin 
      if x < k then 
        match N.toOpt (N.left nt) with         
        | None -> N.return nt 
        | Some l ->
          N.leftSet nt (remove0 l x );
          N.return (N.balMutate nt)
      else 
        match N.toOpt (N.right nt) with 
        | None -> N.return nt 
        | Some r -> 
          N.rightSet nt (remove0 r x);
          N.return (N.balMutate nt)
    end

let remove d v = 
  let oldRoot = data d in 
  match N.toOpt oldRoot with 
  | None -> ()
  | Some oldRoot2 -> 
  let newRoot = remove0 oldRoot2 v in 
  if newRoot != oldRoot then 
    dataSet d newRoot       

let rec removeMany0 t xs i len  =  
  if i < len then 
    let ele = A.getUnsafe xs i in 
    let u = remove0 t ele in 
    match N.toOpt u with 
    | None -> N.empty
    | Some t -> removeMany0 t xs (i+1) len
  else N.return t    


let removeMany  (d : t) xs =  
  let oldRoot = data d in 
  match N.toOpt oldRoot with 
  | None -> ()
  | Some nt -> 
    let len = A.length xs in 
    dataSet d  (removeMany0 nt xs 0 len) 
    
let rec removeCheck0  nt (x : elt) removed = 
  let k = N.key nt in 
  if x = k then 
    let () = removed := true in  
    let l,r = N.(left nt, right nt) in       
    match N.(toOpt l, toOpt r) with 
    | None, _ -> r 
    | _ , None -> l 
    | Some _,  Some nr ->  
      N.rightSet nt (N.removeMinAuxWithRootMutate nt nr);
      N.return (N.balMutate nt)
  else 
    begin 
      if x < k then 
        match N.toOpt (N.left nt) with         
        | None -> N.return nt 
        | Some l ->
          N.leftSet nt (removeCheck0  l x removed);
          N.return (N.balMutate nt)
      else 
        match N.toOpt (N.right nt) with 
        | None -> N.return nt 
        | Some r -> 
          N.rightSet nt (removeCheck0  r x removed);
          N.return (N.balMutate nt)
    end



let removeCheck  (d :  t) v =  
  let oldRoot = data d in 
  match N.toOpt oldRoot with 
  | None -> false 
  | Some oldRoot2 ->
    let removed = ref false in 
    let newRoot = removeCheck0  oldRoot2 v removed in 
    if newRoot != oldRoot then  
      dataSet d newRoot ;   
    !removed

    
let rec addCheck0  t (x : elt) added  =   
  match N.toOpt t with 
  | None -> 
    added := true;
    N.singleton x 
  | Some nt -> 
    let k = N.key nt in 
    if x = k then t 
    else
      let l, r = N.(left nt, right nt) in 
      (if x < k then                   
         let ll = addCheck0  l x added in
         N.leftSet nt ll
       else   
         N.rightSet nt (addCheck0 r x added );
      );
      N.return (N.balMutate nt)

let addCheck (m :  t) e = 
  let oldRoot = data m in 
  let added = ref false in 
  let newRoot = addCheck0 oldRoot e added in 
  if newRoot != oldRoot then 
    dataSet m newRoot;
  !added        

let add d k = 
  let oldRoot = data d in 
  let v = I.addMutate oldRoot k in 
  if v != oldRoot then 
    dataSet d v   

  
let addArrayMutate t  xs =       
  let v = ref t in 
  for i = 0 to A.length xs - 1 do 
    v := I.addMutate !v (A.getUnsafe xs i)
  done ;
  !v    

let mergeMany d arr = 
  dataSet d (addArrayMutate (data d) arr)
    


let empty  () = t ~data:N.empty

let isEmpty d = 
  N.isEmpty (data d)

let minimum d = 
  N.minimum (data d)

let minUndefined d =
  N.minUndefined (data d)

let maximum d = 
  N.maximum (data d)

let maxUndefined d =
  N.maxUndefined (data d)

let forEach d f =
  N.forEach (data d) f     

let reduce d acc cb = 
  N.reduce (data d) acc cb 
let every d p = 
  N.every (data d) p 
let some d  p = 
  N.some (data d) p   

let size d = 
  N.size (data d)
let toList d =
  N.toList (data d)
let toArray d = 
  N.toArray (data d)
  

let ofSortedArrayUnsafe xs =
  t ~data:(N.ofSortedArrayUnsafe xs)    
let checkInvariantInternal d = 
  N.checkInvariantInternal (data d)



let ofArray xs = 
  t  ~data:(I.ofArray xs)

let cmp d0 d1 = 
  I.cmp (data d0) (data d1)
let eq d0 d1 = 
  I.eq (data d0) (data d1)
let get d x = 
  I.get (data d) x
let getUndefined d x =
  I.getUndefined (data d) x
let getExn d x =
  I.getExn (data d) x 

let split d  key =  
  let arr = N.toArray (data d) in 
  let i = S.binarySearch arr key   in   
  let len = A.length arr in 
  if i < 0 then 
    let next = - i -1 in 
    (t
      ~data:(N.ofSortedArrayAux arr 0 next)
    , 
    t
      ~data:(N.ofSortedArrayAux arr next (len - next))
    ), false
  else 
    (t
      ~data:(N.ofSortedArrayAux arr 0 i)
    ,
    t
      ~data:(N.ofSortedArrayAux arr (i+1) (len - i - 1))
      ), true   
  
let keepBy d p = 
  t ~data:(N.filterCopy (data d) p )
let partition d p = 
  let a , b = N.partitionCopy (data d) p in 
  t ~data:a, t ~data:b  
let subset a b = I.subset  (data a) (data b)
let intersect dataa datab  = 
  let dataa, datab = data dataa, data datab in
    match N.toOpt dataa, N.toOpt datab with 
    | None, _ -> empty ()
    | _, None -> empty ()
    | Some dataa0, Some datab0 ->  
    let sizea, sizeb = 
        N.lengthNode dataa0, N.lengthNode datab0 in          
    let totalSize = sizea + sizeb in 
    let tmp = A.makeUninitializedUnsafe totalSize in 
    ignore @@ N.fillArray dataa0 0 tmp ; 
    ignore @@ N.fillArray datab0 sizea tmp;
    if ((A.getUnsafe tmp (sizea - 1) < 
        A.getUnsafe tmp sizea))
      || 
      (
      (A.getUnsafe tmp (totalSize - 1) <
      A.getUnsafe tmp 0)
      )
       then empty ()
    else 
    let tmp2 = A.makeUninitializedUnsafe (min sizea sizeb) in 
    let k = S.intersect tmp 0 sizea tmp sizea sizeb tmp2 0  in 
    t ~data:(N.ofSortedArrayAux tmp2 0 k)
  
let diff dataa datab : t = 
  let dataa, datab = data dataa, data datab in
  match N.toOpt dataa, N.toOpt datab with 
  | None, _ -> empty ()
  | _, None -> t ~data:(N.copy dataa)
  | Some dataa0, Some datab0 -> 
    let sizea, sizeb = N.lengthNode dataa0, N.lengthNode datab0 in  
    let totalSize = sizea + sizeb in 
    let tmp = A.makeUninitializedUnsafe totalSize in 
    ignore @@ N.fillArray dataa0 0 tmp ; 
    ignore @@ N.fillArray datab0 sizea tmp;
    if ( (A.getUnsafe tmp (sizea - 1)) < 
        (A.getUnsafe tmp sizea))
      ||       
      (A.getUnsafe tmp (totalSize - 1)
      < A.getUnsafe tmp 0) 
       then t ~data:(N.copy dataa) 
    else 
    let tmp2 = A.makeUninitializedUnsafe sizea in 
    let k = S.diff tmp 0 sizea tmp sizea sizeb tmp2 0  in 
    t ~data:(N.ofSortedArrayAux tmp2 0 k)

let union (dataa : t)  (datab : t) : t = 
  let dataa, datab = data dataa, data datab in
   match N.toOpt dataa, N.toOpt datab with 
  | None, _ -> t ~data:(N.copy datab) 
  | _, None -> t ~data:(N.copy dataa) 
  | Some dataa0, Some datab0 
    -> 
    let sizea, sizeb = N.lengthNode dataa0, N.lengthNode datab0 in 
    let totalSize = sizea + sizeb in 
    let tmp = A.makeUninitializedUnsafe totalSize in 
    ignore @@ N.fillArray dataa0 0 tmp ;
    ignore @@ N.fillArray datab0 sizea tmp ;
    if 
      (A.getUnsafe tmp (sizea - 1) < 
      A.getUnsafe tmp sizea)  then 
      t  ~data:(N.ofSortedArrayAux tmp 0 totalSize) 
    else   
      let tmp2 = A.makeUninitializedUnsafe totalSize in 
      let k = S.union tmp 0 sizea tmp sizea sizeb tmp2 0  in 
      t ~data:(N.ofSortedArrayAux tmp2 0 k) 
  
let has d x = I.has (data d) x 

let copy d = t ~data:(N.copy (data d)) 
