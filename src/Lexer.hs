module Lexer where
    import Data.Maybe
    import Token

    tokenize :: String -> TokenStream
    tokenize str = map fromJust $ filter isJust $ stringToTokenStream str

    stringToTokenStream :: String -> [Maybe Token]
    stringToTokenStream (t:ts)  = lexicon t :stringToTokenStream ts
    stringToTokenStream ""      = [Just EOF]

    lexicon :: Char -> Maybe Token
    lexicon '>' = Just IncPtr
    lexicon '<' = Just DecPtr
    lexicon '+' = Just IncData
    lexicon '-' = Just DecData
    lexicon ',' = Just Read
    lexicon '.' = Just Write
    lexicon '[' = Just Begin
    lexicon ']' = Just End
    lexicon _   = Nothing
