module Parser where
    import Token
    import Ast
    import Grammar

    parse :: TokenStream -> SyntaxTree
    parse ts = Program $ snd  $ begin ts
