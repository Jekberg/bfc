
{--
    Grammar:
    
    begin       -> stmtList <EOF>
    stmtList    -> stmt stmtList
    stmtList    -> loop stmtList
    stmtList    -> ''
    stmt        -> <IncPtr>
    stmt        -> <DecPtr>
    stmt        -> <IncData>
    stmt        -> <DecData>
    stmt        -> <Read>
    stmt        -> <Write>
    loop        -> <Begin> stmtList <End>
--}

module Grammar where
    import Token
    import Ast

    lookAhead :: TokenStream -> Token
    lookAhead (t:_)     = t
    lookAhead []        = error "Unexpected end of stream."

    accept :: TokenStream -> TokenStream
    accept (_:ts)   = ts
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
                let (toks, node) = stmt ts
                in let (nToks, nNode) = stmtList toks
                    in (nToks, List node nNode)
        Token.Begin ->
                    let (toks, node) = (loop . accept) ts
                    in
                        let (nToks, nNode) = stmtList toks
                        in (nToks, List node nNode)
        _       -> (ts, Empty)

    stmt :: TokenStream -> (TokenStream, Node)
    stmt ts = (accept ts, Statment t)

    loop :: TokenStream -> (TokenStream, Node)
    loop ts = let (toks, node) = stmtList ts
        in case lookAhead toks of
            End -> (accept toks, Loop node)
            _   -> error "Unexpected: expected end of loop"
