(* Copyright (C) 2018 Authors of BuckleScript
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 * 
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)



type ('key, 'a) t = ('key, 'a) node Js.null

and ('k,  'v) node  = private {
  mutable left : ('k,'v) t;
  mutable key : 'k; 
  mutable value : 'v; 
  mutable right : ('k,'v) t;
  h : int 
} [@@bs.deriving abstract]


external toOpt : 'a Js.null -> 'a option = "#null_to_opt"
external return : 'a -> 'a Js.null = "%identity"
external empty : 'a Js.null = "#null"

type ('k, 'id) cmp = ('k, 'id) Bs_Cmp.cmp
    
val copy : ('k, 'v) t -> ('k, 'v) t
val create :
  ('a,'b) t -> 'a -> 'b -> ('a,'b) t -> ('a,'b) t
val bal :
  ('a,'b) t -> 'a -> 'b -> ('a,'b) t -> ('a,'b) t

val singleton : 'a -> 'b -> ('a,'b) t

val updateValue : ('k, 'v) node -> 'v -> ('k,'v) node

val minKey: ('a, 'b) t -> 'a option 
val minKeyUndefined: ('a, 'b) t -> 'a Js.undefined

val maxKey : ('a, 'b) t -> 'a option 
val maxKeyUndefined : ('a, 'b) t -> 'a Js.undefined

val minimum : ('a, 'b) t -> ('a * 'b) option
val minUndefined : ('a,'b) t -> ('a * 'b) Js.undefined

val maximum : ('a,'b) t -> ('a * 'b) option
val maxUndefined : ('a,'b) t -> ('a * 'b) Js.undefined

val removeMinAuxWithRef : ('a, 'b) node -> 'a ref -> 'b ref -> ('a,'b) t

val empty : _ t
val isEmpty : _ t -> bool

val stackAllLeft :
  ('a,'b) t -> ('a, 'b) node list -> ('a, 'b) node list

val forEach :  ('a,'b) t -> ('a -> 'b -> unit [@bs]) -> unit
val map :  ('c, 'a) t -> ('a -> 'b [@bs]) -> ('c, 'b) t
val mapWithKey :
   ('a,'b) t -> ('a -> 'b -> 'c [@bs]) -> ('a, 'c) t
val reduce : ('a,'b) t -> 'c -> ( 'c -> 'a -> 'b -> 'c [@bs]) ->  'c
val every :  ('a,'b) t -> ('a -> 'b -> bool [@bs]) -> bool
val some :  ('a,'b) t -> ('a -> 'b -> bool [@bs]) -> bool

val join : ('a,'b) t -> 'a -> 'b -> ('a,'b) t -> ('a, 'b) t

val concat : ('a,'b) t -> ('a,'b) t -> ('a,'b) t

val concatOrJoin :
  ('a,'b) t -> 'a -> 'b option -> ('a,'b) t -> ('a, 'b) t

val filterShared : 
  ('a,'b) t ->
  ('a -> 'b -> bool [@bs]) -> 
  ('a,'b) t

val filterMap :    
  ('a, 'b) t -> 
  ('a -> 'b -> 'c option [@bs]) -> 
  ('a, 'c) t 
(* seems no sharing, could be shared with mutation *)
val partitionShared :  
  ('a,'b) t -> 
  ('a -> 'b -> bool [@bs]) ->
  ('a,'b) t * ('a,'b) t


val lengthNode : ('a, 'b) node -> int
val size : ('a,'b) t -> int

val toList : ('a,'b) t -> ('a * 'b) list
val checkInvariantInternal : ('a,'b) t -> bool

val fillArray : ('a,'b) node -> int -> ('a * 'b) array -> int  

val toArray : ('a, 'b) t -> ('a * 'b) array  
val keysToArray : ('a, 'b) t -> 'a array
val valuesToArray : ('a, 'b) t -> 'b array 
val ofSortedArrayAux : ('a * 'b) array -> int -> int -> ('a, 'b) t
val ofSortedArrayRevAux : ('a * 'b) array -> int -> int -> ('a, 'b) t
val ofSortedArrayUnsafe : ('a * 'b) array -> ('a, 'b) t

val cmp : 
  ('a, 'b) t -> ('a, 'c) t -> 
  kcmp:('a,_) cmp -> 
  vcmp :('b -> 'c -> int [@bs]) -> 
  int 

val eq :   
  ('a, 'b) t -> ('a, 'c) t -> 
  kcmp:('a,_) cmp -> 
  veq:('b -> 'c -> bool [@bs]) -> 
  bool

val get:  
  ('a, 'b) t -> 
  'a -> 
  cmp:('a,_) cmp -> 
  'b option 

val getUndefined:  
  ('a, 'b) t -> 
  'a -> 
  cmp:('a,_) cmp -> 
  'b Js.undefined

val getWithDefault:  
  ('a, 'b) t -> 
  'a -> 
  'b -> 
  cmp:('a,_) cmp -> 
  'b 
val getExn:  
  ('a, 'b) t -> 
  'a -> 
  cmp:('a,_) cmp ->   
  'b 

val has:  
  ('a, 'b) t -> 
  'a -> 
  cmp:('a,_) cmp -> 
  bool


  
val ofArray : ('a * 'b) array ->  cmp:('a,'id) cmp -> ('a, 'b) t

val updateMutate :   
  ('a, 'b) t -> 'a -> 'b -> 
  cmp:('a,'id) cmp -> 
  ('a, 'b) t

val balMutate :   
  ('a, 'b) node -> ('a, 'b) node 

val removeMinAuxWithRootMutate :   
  ('a, 'b) node -> 
  ('a, 'b) node -> 
  ('a, 'b) t 
