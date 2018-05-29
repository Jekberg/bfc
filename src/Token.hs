module Token where
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
    type TokenStream = [Token]
