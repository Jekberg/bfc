
module Synthesize where
    import Intermidiate

    cHead :: String
    cHead = "#include<stdio.h>\nchar cells[3000];unsigned ptr=0;int main(void){"
    cFoot :: String
    cFoot = "}"

    generate :: IRCode -> String
    generate xs = cHead ++ generateC xs ++ cFoot
    generateC :: IRCode -> String
    generateC (x:xs) = codeFromIR x ++ generateC xs
    generateC []     = ""

    codeFromIR :: IR -> String
    codeFromIR (Cell n)         = "cells[ptr]+=" ++ (show n) ++ ";"
    codeFromIR (Index n)        = "ptr+=" ++ (show n) ++ ";"
    codeFromIR ReadChr          = "scanf(\"%c\",cells + ptr);"
    codeFromIR WriteChr         = "printf(\"%c\",cells[ptr]);"
    codeFromIR (LoopCode code)  = "while(cells[ptr]){" ++ (generateC code) ++ "}"
