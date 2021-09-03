{
  open Parser
}

let space = [' ' '\t' '\n' '\r']
let digit = ['0'-'9']
let lower = ['a'-'z']
let upper = ['A'-'Z']
let alpha = lower | upper

rule token = parse
| space+  { token lexbuf }      
| "(*"    { comment lexbuf;
            token lexbuf }
| "+"     { PLUS }
| "-"     { MINUS }
| "*"     { TIMES }
| "/"     { DIVIDE }
| "mod"   { MOD }
| "true"  { TRUE }
| "false" { FALSE }
| "&&"    { AND }
| "||"    { OR }
| "="     { EQUAL }
| "<>"    { NOTEQUAL }
| "<"     { LESS }
| "<="    { LESSEQUAL }
| ">"     { GREATER }
| ">="    { GREATEREQUAL }
| "if"    { IF }
| "then"  { THEN }
| "else"  { ELSE }
| "let"   { LET }
| "rec"   { REC }
| "in"    { IN }
| "fun"   { FUN }
| "->"    { ARROW }
| "["     { LBRACKET }
| "]"     { RBRACKET }
| "match" { MATCH }
| "with"  { WITH }
| "::"    { CONS }
| "|"     { BAR }
| ";"     { SEMI }
| "("     { LPAREN }
| ")"     { RPAREN }
| ","     { COMMA }
| digit+                        
          { NUMBER (int_of_string (Lexing.lexeme lexbuf)) }
| lower (alpha | digit | '_')*  
          { VAR (Lexing.lexeme lexbuf) }
| eof     { EOF }               
| _       { failwith ("unknown token: " ^ Lexing.lexeme lexbuf) }


and comment = parse
| "*)"  { () }
| "(*)" { comment lexbuf;
          comment lexbuf}
| eof     { failwith "unterminated comment" }
| _       { comment lexbuf }
