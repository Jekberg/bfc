module Main where
    import System.Environment
    import System.FilePath
    import System.IO
    import Lexer
    import Parser
    import Intermidiate
    import Synthesize

    compile :: (String -> String)
    compile = (generate. optimize . convert . parse . tokenize)

    main :: IO()
    main = do
        args <- getArgs
        foldr (>>) (return()) $ map compileFile args

    compileFile :: String -> IO()
    compileFile fileName = do
        if takeExtension fileName == ".bf"
        then withFile fileName ReadMode (\handle -> do
            contents <- hGetContents handle
            ((writeFile (takeBaseName fileName ++ ".c")) . compile) contents)
        else
            putStrLn $ fileName ++ " is not a brainfuck source file."
