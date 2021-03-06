(* Copyright (C) 2017 Authors of BuckleScript
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

(** This dictionary is shared by {!Bs.Set} and {!Bs.Map} *)
type 'a compare = 'a -> 'a -> int [@bs]
type ('a, 'id) cmp

(** only used for data structures, not exported for client usage *)
external getCmpInternal: ('a,'id) cmp -> 'a compare = "%identity"

module type T = sig
  type id
  type t
  val cmp : (t,id) cmp
end

type ('key, 'id) t = 
  (module T with type t = 'key and type id = 'id)



val make: cmp:'a compare -> (module T with type t = 'a)     
(** [make cmp] create a dictionary to sign the data structure
    For example:
    {[
      module N = make ~cmp
    ]}
    Such module [N] can be used to initiialize various datastructures,
    [N.id] will be the idenetity
*)
