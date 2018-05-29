module Ast where
    import Token

    data SyntaxTree = Program Node
                    deriving Show
    data Node   = Root Node
                | List Node Node
                | Statment Token
                | Loop Node
                | Empty
                deriving Show
