module Grammar where
    import Token
    import Ast

    lookAhead :: TokenStream -> Token
    lookAhead (t:ts)    = t
    lookAhead []        = error "Unexpected end of stream."

    accept :: TokenStream -> TokenStream
    accept (t:ts)   = ts
    accept []       = error "Unexpected end of stream."

    begin :: TokenStream -> (TokenStream, Node)
    begin ts = let (toks, node) = stmtList ts
        in case lookAhead toks of
            EOF -> ([], Root node)
            _   -> error ("Expected end of file." ++ (show ts))

    stmtList :: TokenStream -> (TokenStream, Node)
    stmtList ts = case lookAhead ts of
        token
            | elem token [IncPtr, DecPtr, IncData, DecData, Read, Write] ->
                    let (toks, node) = (stmtList . accept) ts
                    in (toks, List (snd $ stmt ts) node)
        Token.Begin ->
                    let (toks, node) = (loop . accept) ts
                    in
                        let (nToks, nNode) = stmtList toks
                        in (nToks, List node nNode)
        _       -> (ts, Empty)

    stmt :: TokenStream -> (TokenStream, Node)
    stmt ts = case lookAhead ts of
            Token.Begin ->
                    let (toks, node) = (loop . accept) ts
                    in (toks, node)
            t           -> (accept ts, Statment t)

    loop :: TokenStream -> (TokenStream, Node)
    loop ts = let (toks, node) = stmtList ts
        in case lookAhead toks of
            End -> (accept toks, Loop node)
            _   -> error "Unexpected: expected end of loop"
