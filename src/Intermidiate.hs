module Intermidiate where
    import Token
    import Ast

    data IR = Cell Int
            | Index Int
            | ReadChr
            | WriteChr
            | LoopCode IRCode
            deriving Show
    type IRCode = [IR]

    convert :: SyntaxTree -> IRCode
    convert (Program tree) = nodeToIR tree

    nodeToIR :: Node -> IRCode
    nodeToIR (Root node)       = nodeToIR node
    nodeToIR (List node rest)   = nodeToIR node ++ nodeToIR rest
    nodeToIR (Statment token)   = [tokenToIR token]
    nodeToIR (Loop node)        = [LoopCode $ nodeToIR node]
    nodeToIR Empty              = []

    tokenToIR :: Token -> IR
    tokenToIR IncPtr    = Index 1
    tokenToIR DecPtr    = Index (-1)
    tokenToIR IncData   = Cell 1
    tokenToIR DecData   = Cell (-1)
    tokenToIR Read      = ReadChr
    tokenToIR Write     = WriteChr
    tokenToIR _         = error "Token not allowed!"

{--
    -- WIP
    optimize :: IRCode -> IRCode
    optimize xs = removeEmptyLoop xs

    removeEmptyLoop :: IRCode -> IRCode
    removeEmptyLoop (x:xs) = case x of
        LoopCode [] -> removeEmptyLoop xs
        loopCode s  ->
        _          -> x: removeEmptyLoop xs
    removeEmptyLoop [] = []
--}
