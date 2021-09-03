type op_t = Plus | Minus | Times | Divide | Mod | And | Or | Equal | NotEqual | Less | LessEqual

type t = Number of int
       | Op of t * op_t * t
       | Bool of bool
       | If of t * t * t
       | IfThen of t * t
       | Var of string
       | Let of string * t * t
       | Letrec of string * string * t *
       | Fun of string * t
       | App of t * t
       | Nil
       | Cons of t * t
       | Match of t * t * string * string * t
       | Tuple of t * t list
       | Seq of t * t list


       
