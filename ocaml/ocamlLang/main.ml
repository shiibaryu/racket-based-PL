let go () = 
  let program = Parser.start Lexer.token (Lexing.from_channel stdin) in
  Syntax.print program;
  print_newline ()

let _ = go ()

