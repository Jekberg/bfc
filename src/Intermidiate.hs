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

    optimize :: IRCode -> IRCode
    optimize xs = if newSize /= oldSize then optimize newIR else newIR
        where
            newIR   = (eliminate . compact) xs
            newSize = length newIR
            oldSize = length xs

    compact :: IRCode -> IRCode
    compact (x:[]) = case x of
        (LoopCode xs)   -> [LoopCode $ optimize xs]
        _               -> [x]
    compact (x:xs) = case x of
        (Cell a)    -> case head xs of
            (Cell b)    -> compact $ (Cell $ a + b): tail xs
            _           -> x:compact xs
        (Index a)   -> case head xs of
            (Index b)   -> compact $ (Index $ a + b): tail xs
            _           -> x:compact xs
        (LoopCode subXs)   -> (LoopCode $ optimize subXs):compact xs
        _           ->  x:compact xs
    compact []     = []

    eliminate :: IRCode -> IRCode
    eliminate (x:xs)    = case x of
        (Cell 0)        -> eliminate xs
        (Index 0)       -> eliminate xs
        (LoopCode [])   -> eliminate xs
        _               -> x:eliminate xs
    eliminate []        = []
