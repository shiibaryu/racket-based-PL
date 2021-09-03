type token =
  | LPAREN
  | RPAREN
  | MINUS
  | TIMES
  | NUMBER of (int)
  | EOF

val start :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Syntax.t
