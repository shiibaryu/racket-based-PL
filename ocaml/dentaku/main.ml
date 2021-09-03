let go () = 
  let expr = Parser.start Lexer.token (Lexing.from_channel stdin) in
  print_string "Parsed result : ";
  Syntax.print expr;
  print_newline ();
  print_string "Result : ";
  print_int (Eval.f expr);
  print_newline ()


let _ = go ()
