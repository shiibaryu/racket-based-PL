%{

%}

%token LPAREN RPAREN
%token MINUS TIMES
%token <int> NUMBER
%token EOF

%start start

%type <Syntax.t> start

%left MINUS
%left TIMES
%nonassoc UNARY

%%

start:
  | expr EOF    { $1 }

simple_expr:
  | NUMBER      {Syntax.Num ($1)}
  | LPAREN expr RPAREN { $2 }

expr:
 | simple_expr  { $1 }
 | expr MINUS expr { Syntax.Op ($1, Syntax.Minus, $3) }
 | expr TIMES expr { Syntax.Op ($1, Syntax.Times, $3) }
 | MINUS expr %prec UNARY {Syntax.Op (Syntax.Num (0), Syntax.Minus, $2)}
