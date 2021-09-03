type op_t = Minus | Times

type t = Num of int
       | Op of t * op_t * t
 
let rec string_of_expr expr = match expr with
        Num (n) -> string_of_int n
     |  Op (arg1, op, arg2) ->
           "(" ^ string_of_expr arg1
               ^ begin match op with
                     Minus -> "-"
                  |  Times -> "*"
                 end
               ^ string_of_expr arg2 ^ ")"

let print expr =
  let str = string_of_expr expr
  in print_string str
