%{
open Syntax
let create_fun variables expr = 
        List.fold_right (fun var expr -> Fun (var, expr)) variables expr
let create_list exprs = 
        List.fold_rigjt (fun expr lst -> Cons (expr, lst)) exprs Mil
let create_seq exprs = match exprs with
        [] -> failwith "Can't happen"
        | first :: [] -> first
        | first :: rest -> Seq(first,rest)
%}

%token <int> NUMBER
%token PLUS MINUS TIMES DEVIDE MOD
%token TRUE FALSE AND OR
%token EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%token IF THEN ELSE
%token <string> VAR
%token LET REC IN FUN ARROW
%token LBRACKET RBRACKET MATCH WITH CONS BAR
%token LPAREN RPAREN COMMA
%token SEMI
%token EOF

%type <Syntax.t> start

%start start

%nonassoc IN
%nonassoc below_SEMI
%nonassoc SEMI
%nonassoc THEN
%nonassoc ELSE
%nonassoc ARROW
%right OR
%right AND
%nonassoc EQUAL NOTEQUAL LESS LESSEQUAL GREATER GREATEREQUAL
%right CONS
%left PLUS MINUS
%left TIMES DIVIDE MOD
%nonassoc UNARY

start:
| expr EOF { $1 }

simple_expr:
| NUMBER             { NUMBER ($1) }
| TRUE               { Bool (true) }
| FALSE              { Bool (false) }
| VAR                { Var ($1) }  
| LPAREN expr RPAREN { $2 }
| expr simple_expr { App ($1, $2)}
| LBRACKET RBRACKET  { Nil }
| LBRACKET expr_semi_list RBRACKET  { create_list $2 }
| LPAREN expr comma_expr_list_rest
        { Tuple ($2, $4 :: $5 ) }

comma_expr_list:
| COMMA expr
        { [$2] }
| COMMA expr comma_expr_list
        { $2 :: $3 }

comma_expr_list_rest:
| RPAREN
        { [] }
| COMMA expr comma_expr_list_rest
        { $2 :: $3 }

seq_expr: 
| expr %prec below_SEMI
        { [$1] }
| expr SEMI seq_expr
        { $1 :: $3}

variables:
| VAR { [$1] }
| VAR variables
      { $1 :: $2 }

app:
| simple_expr simple_expr
        { App ($1, $2)}
| app   simple_expr
        { App ($1, $2)}
 
opt_semi:
|       { () }
| SEMI  { () }

expr_semi_list:
| expr opt_semi { [$1] }
| expr SEMI expr_semi_list { $1::$3 }

expr:
| simple_expr { $1 }
| app         { $1 }
| expr CONS expr { Cons ($1, $3)}
| expr PLUS expr { Op ($1, Plus, $3)}
| expr MINUS expr
        { Op ($1, Minus, $3) }
| expr TIMES expr
        { Op ($1, Times, $3) }
| expr DIVIDE expr
        { Op ($1, Divide, $3) }
| expr MOD expr
        { Op ($1, Mod, $3) }
| expr AND expr
        { Op ($1, And, $3) }
| expr OR expr
        { Op ($1, Or, $3) }
| expr EQUAL expr
        { Op ($1, Equal, $3) }
| expr NOTEQUAL expr
        { Op ($1, NotEqual, $3) }
| expr LESS expr
        { Op ($1, Less, $3) }
| expr LESSEQUAL expr
        { Op ($1, LessEqual, $3) }
| expr GREATER expr
        { Op ($3, Less, $1) }
| expr GREATEREQUAL expr
        { Op ($3, LessEqual, $1) }
| MINUS expr %prec UNARY
        { Op (Number (0), Minus, $2) }

| IF expr THEN expr ELSE expr
        { If ($2, $4, $6)}

| VAR
        { Var ($1) }
| FUN variables ARROW seq_expr
        { create_fun $2 (create_seq $4)}

| LET VAR EQUAL expr in seq_expr
        { Let ($2, $4, create_seq $6)}
| LET VAR variables EQUAL expr IN seq_expr
        { Let ($2, create_fun $3 $5, create_seq $7)}
| LET REC VAR EQUAL expr in seq_expr
        { Letrec ($3, $4, $6, create_seq $8)}
| LET REC VAR VAR variables EQUAL expr IN seq_expr
        { Letrec ($3, $4, create_fun $5 $7, create_seq $9)}
| MATCH expr WITH LBRACKET RBRACKET ARROW seq_expr BAR VAR CONS VAR ARROW seq_expr
        { Match ($2, create_seq $7, $9, $11, create_seq $13)}
