-- |
-- |
module Lexer where
    import Data.Maybe
    import Token

    tokenize :: String -> TokenStream
    tokenize str = map fromJust $ filter isJust $ stringToTokenStream str

    stringToTokenStream :: String -> [Maybe Token]
    stringToTokenStream (t:ts)      = case t of
        '"' -> stringToTokenStream $ comment ts
        _   -> lexicon t :stringToTokenStream ts
    stringToTokenStream ""          = [Just EOF]

    comment :: String -> String
    comment ts    = tail $ dropWhile (/= '"') ts

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
