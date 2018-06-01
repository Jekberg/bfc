-- |
-- | The Token module contains the data for defining tokens which exist within
-- | brainfuck and functions which act on a sequence of tokens, known as a
-- | TokenStream.
module Token where
    -- | The enum data type which represents the tokens which are recognised by
    -- | the brainfuck programming language.
    data Token  = IncPtr
                | DecPtr
                | IncData
                | DecData
                | Read
                | Write
                | Begin
                | End
                | EOF
                deriving (Show, Eq)
    -- | The stream (list) of tokens.
    type TokenStream = [Token]
    -- | Look at the next token in the token stream.
    -- | If the token stream is empty, then an error will be raised.
    lookAhead :: TokenStream -> Token
    lookAhead (t:_)     = t
    lookAhead []        = error "Unexpected end of stream."
    -- | Advance the token stream.
    -- | If the stream is empty, then an error will be raised.
    accept :: TokenStream -> TokenStream
    accept (_:ts)   = ts
    accept []       = error "Unexpected end of stream."
