{
open Parser
}

let space = [' ' '\t' '\n' '\r']
let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let alpha = lower | upper


rule token = parse
  | space+ { token lexbuf }
  | "(*" [^ '\n']* "\n"
         { token lexbuf}
  | "(" { LPAREN }
  | ")" { RPAREN }
  | "-" { MINUS  }
  | "*" { TIMES  }
  | digit+
        { NUMBER (int_of_string (Lexing.lexeme lexbuf))}
  | eof { EOF }
  | _   { failwith ("unknown token: " ^ Lexing.lexeme lexbuf)}
